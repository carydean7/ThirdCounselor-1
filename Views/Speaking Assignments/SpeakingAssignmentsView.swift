//
//  SpeakingAssignmentsListView.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 3/27/23.
//

import SwiftUI
import WebKit

struct SpeakingAssignmentsView: View {
    @EnvironmentObject var orgMbrCallingViewModel: OrgMbrCallingViewModel

    @StateObject var speakingAssignmentsViewModel: SpeakingAssignmentsViewModel = SpeakingAssignmentsViewModel.shared
    
    @ObservedObject var membersViewModel: MembersViewModel
    
    @State private var showAddSpeakingAssignmentsView = false
    
    public init(showAddSpeakingAssignmentsView: Bool = false,
                orgMbrCallingViewModel: OrgMbrCallingViewModel,
                membersViewModel: MembersViewModel) {
        self.showAddSpeakingAssignmentsView = showAddSpeakingAssignmentsView
        self.membersViewModel = membersViewModel
    }
    
    var body: some View {
        VStack {
            if showAddSpeakingAssignmentsView {
                AddSpeakingAssignmentView(membersViewModel: membersViewModel, orgMbrCallingViewModel: orgMbrCallingViewModel, speakingAssignmentsViewModel: speakingAssignmentsViewModel, showAddSpeakingAssignmentsView: $showAddSpeakingAssignmentsView)
                    .environment(\.colorScheme, .light)
            } else {
                SpeakingAssignmentsListView(membersViewModel: membersViewModel)
                    .environment(\.colorScheme, .light)
            }
        }
        .onViewDidLoad {
            speakingAssignmentsViewModel.fetchData {
                if speakingAssignmentsViewModel.speakingAssignments.isEmpty {
                    showAddSpeakingAssignmentsView = true
                } else {
                    speakingAssignmentsViewModel.filterSpeakingAssignment()
                }
            }
        }
        .environment(\.colorScheme, .light)
    }
}

struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}

extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
    
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(Branding.mock.outerHeaderBackgroundColor)
            .padding(10)
    }
}

struct Webview: UIViewControllerRepresentable {
    static var topic = ""
    
    let url = URL(string: "https://www.churchofjesuschrist.org/study/general-conference?lang=eng") ?? URL(string: "")
    
    func makeUIViewController(context: Context) -> WebviewController {
        var request: URLRequest
        
        let webviewController = WebviewController()
        
        guard let url = self.url else {
            return WebviewController()
        }
        
        request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        webviewController.webview.load(request)
        
        return webviewController
    }
    
    func updateUIViewController(_ webviewController: WebviewController, context: Context) {
        //
    }
}

class WebviewController: UIViewController, WKNavigationDelegate {
    lazy var webview: WKWebView = WKWebView()
    lazy var progressbar: UIProgressView = UIProgressView()
    
    deinit {
        self.webview.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webview.scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webview.navigationDelegate = self
        self.view.addSubview(self.webview)
        
        self.webview.frame = self.view.frame
        self.webview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            self.webview.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.webview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.webview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        self.webview.addSubview(self.progressbar)
        self.setProgressBarPosition()
        
        webview.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
        self.progressbar.progress = 0.1
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webview.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
    
    func setProgressBarPosition() {
        self.progressbar.translatesAutoresizingMaskIntoConstraints = false
        self.webview.removeConstraints(self.webview.constraints)
        self.webview.addConstraints([
            self.progressbar.topAnchor.constraint(equalTo: self.webview.topAnchor, constant: self.webview.scrollView.contentOffset.y * -1),
            self.progressbar.leadingAnchor.constraint(equalTo: self.webview.leadingAnchor),
            self.progressbar.trailingAnchor.constraint(equalTo: self.webview.trailingAnchor),
        ])
    }
    
    // MARK: - Web view progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            if self.webview.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, animations: { () in
                    self.progressbar.alpha = 0.0
                }, completion: { finished in
                    self.progressbar.setProgress(0.0, animated: false)
                })
            } else {
                self.progressbar.isHidden = false
                self.progressbar.alpha = 1.0
                progressbar.setProgress(Float(self.webview.estimatedProgress), animated: true)
            }
            
        case "contentOffset":
            self.setProgressBarPosition()
        case "title":
            if let title = webview.title {
                Webview.topic = title
                SpeakingAssignmentsViewModel.shared.selectedTitle = title
                SpeakingAssignmentsViewController.selectedTitle = title
                if !title.lowercased().contains("general conference") {
                    dismiss(animated: true)
                }
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
