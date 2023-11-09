//
//  AppDelegate.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 2/14/22.
//

import UIKit
import CoreData
import UserNotifications
import FirebaseCore
import FirebaseFirestore
import SwiftUI

    @main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        
    var window: UIWindow?
    
    var isLandscape: Bool {
        if UIDevice.current.orientation == .unknown {
            if let orientation = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.windowScene?.interfaceOrientation {
                if orientation == .landscapeLeft || orientation == .landscapeRight {
                    return true
                }
            }
        }
        return UIDevice.current.orientation.isLandscape
    }
    
    static var leader = ""
    static var unitNumber = ""
    static var unitType = ""
    static var stakeNumber = ""
    static var leadershipActionAlertIsDismissed = false
    
    var leaderPickerView: UIPickerView?
    var unitTypePickerView: UIPickerView?
    var unitNumberTextField: UITextField?
    var selectionAlert: UIAlertController?
    var leaderSelectionAlert: UIAlertController?
    
    let defaults = UserDefaults.standard
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
                
        let network = Network.shared
                
        AppDelegate.leader = defaults.string(forKey: UserDefaultKeys.leaderPosition.stringValue) ?? ""
        AppDelegate.unitNumber = defaults.string(forKey: UserDefaultKeys.unitNumber.stringValue) ?? ""
        AppDelegate.unitType = defaults.string(forKey: UserDefaultKeys.unitType.stringValue) ?? ""
        AppDelegate.stakeNumber = defaults.string(forKey: UserDefaultKeys.stakeNumber.stringValue) ?? ""
        
        InfoViewModel.shared.fetchData {
            
        }
        
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
      return true
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
      return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) async {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        if aps["content-available"] as? Int == 1 {}
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register: \(error)")
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ThirdCounselorDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate {
    func showLeaderPicker() {
        leaderSelectionAlert = UIAlertController(title: "Leader Positions"~, message: "Select Your Leadership Position"~ + "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        leaderSelectionAlert?.overrideUserInterfaceStyle = .light
        
        leaderSelectionAlert?.view.frame = CGRect(x: leaderSelectionAlert?.view.frame.origin.x ?? 0, y: leaderSelectionAlert?.view.frame.origin.y ?? 100.0, width: leaderSelectionAlert?.view.frame.size.width ?? 300.0, height: leaderSelectionAlert?.view.frame.size.height ?? 400.0 + 100.0)
        
        if let leaderPickerView = leaderPickerView {
            leaderSelectionAlert?.view.addSubview(leaderPickerView)
            
            leaderPickerView.dataSource = self
            leaderPickerView.delegate = self
        }
        
        leaderSelectionAlert?.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
            self.leaderSelectionAlert?.dismiss(animated: true, completion: nil)
            AppDelegate.leadershipActionAlertIsDismissed = true
        }))
        
        DispatchQueue.main.async(execute: {
            if let selectionAlert = self.leaderSelectionAlert {
                UIApplication.shared.keyWindow?.rootViewController?.present(selectionAlert, animated: true, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.fetchOrganization.stringValue), object: nil)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.fetchOrgMbrCalling.stringValue), object: nil)
                })
            }
        })
    }
    
    func showPicker(with title: String, message: String, pickerView: UIPickerView) {
        if selectionAlert != nil {
            selectionAlert = nil
        }
        
        selectionAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        selectionAlert?.overrideUserInterfaceStyle = .light
        selectionAlert?.view.frame = CGRect(x: selectionAlert?.view.frame.origin.x ?? 0, y: selectionAlert?.view.frame.origin.y ?? 100.0, width: selectionAlert?.view.frame.size.width ?? 300.0, height: selectionAlert?.view.frame.size.height ?? 400.0 + 100.0)
        
        var actionTitle = "Ok"~
        
        if pickerView == leaderPickerView {
            selectionAlert?.view.addSubview(pickerView)
            
            pickerView.dataSource = self
            pickerView.delegate = self
        }
        else {
            if let unitTypePickerView = unitTypePickerView {
                actionTitle = "Done"~
                selectionAlert?.view.addSubview(unitTypePickerView)
                
                unitTypePickerView.dataSource = self
                unitTypePickerView.delegate = self
                
                unitNumberTextField = UITextField(frame: CGRect(x: 10, y: 175, width: 250, height: 40))
                unitNumberTextField?.placeholder = " Enter Unit Number"~
                unitNumberTextField?.layer.borderWidth = 1.0
                unitNumberTextField?.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
                unitNumberTextField?.layer.cornerRadius = 5.0
                unitNumberTextField?.delegate = self
                
                selectionAlert?.view.addSubview(unitNumberTextField ?? UITextField())
            }
        }
        
        selectionAlert?.addAction(UIAlertAction(title: actionTitle, style: .default, handler: {_ in
            if let unitNumber = self.unitNumberTextField?.text {
                self.validUnitNumberAndTypeEntered(number: unitNumber, type: AppDelegate.unitType, completion: { isValid in
                    if !isValid {
                        let alert = UIAlertController(title: "Missing Or Incorrect Required Information"~, message: "Select your Unit Type and entering the correct Unit Number."~, preferredStyle: .alert)
                        
                        alert.overrideUserInterfaceStyle = .light
                        
                        alert.addAction(UIAlertAction(title: "Ok"~, style: .default, handler: { _ in
                            // do some action
                            self.showPicker(with: "Unit Information"~, message: "\n\n\n\n\n\n\n\n\n\n\n\n", pickerView: pickerView)
                        }))
                        
                        DispatchQueue.main.async(execute: {
                            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: {
                                alert.dismiss(animated: true)
                            })
                        })
                    } else {
                        self.selectionAlert?.dismiss(animated: true, completion: {
                            if let text = self.unitNumberTextField?.text {
                                AppDelegate.unitNumber = text
                                
                                self.defaults.set(text, forKey: UserDefaultKeys.unitNumber.stringValue)
                            }
                            
                            self.showLeaderPicker()
                        })
                    }
                })
            }
        }))
        
        DispatchQueue.main.async(execute: {
            if let selectionAlert = self.selectionAlert {
                UIApplication.shared.keyWindow?.rootViewController?.present(selectionAlert, animated: true, completion: {
                    
                })
            }
        })
    }
    
    func validUnitNumberAndTypeEntered(number: String, type: String, completion: @escaping (Bool) -> Void) {
      //  if let stkViewModel = stakeViewModel {
        for stake in StakeViewModel.shared.stakes {
                for unit in stake.units {
                    if unit.unitNumber == number && unit.unitName.contains(type) {
                        completion(true)
                    }
                }
            }
            
            if !StakeViewModel.shared.stakes.isEmpty {
                completion(false)
            }
      //  }
    }
}

extension AppDelegate: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == leaderPickerView {
            return LeadershipPositions.allCases.count
        }
        
        return UnitTypes.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == leaderPickerView {
            return LeadershipPositions.allCases[row].stringValue
        }
        
        return UnitTypes.allCases[row].stringValue
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let defaults = UserDefaults.standard

        if pickerView == leaderPickerView {
            AppDelegate.leader = LeadershipPositions.allCases[row].stringValue
            defaults.set(AppDelegate.leader, forKey: UserDefaultKeys.leaderPosition.stringValue)
        } else {
            AppDelegate.unitType = UnitTypes.allCases[row].stringValue
            defaults.set(AppDelegate.unitType, forKey: UserDefaultKeys.unitType.stringValue)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
        }
        
        if pickerView == leaderPickerView {
            pickerLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)

            pickerLabel?.text = LeadershipPositions.allCases[row].stringValue
        } else {
            pickerLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)

            pickerLabel?.text = UnitTypes.allCases[row].stringValue
        }
        
        pickerLabel?.textColor = UIColor.black

        return pickerLabel!
    }
}

// MARK: - UITextFieldDelegate

extension AppDelegate: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let _ = self.unitNumberTextField?.text?.isEmpty {
            if let _ = self.unitNumberTextField?.text?.isEmpty {
                textField.resignFirstResponder()
            }
        }
        
        return true
    }
}

