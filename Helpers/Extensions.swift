//
//  Extensions.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 8/10/22.
//

import Foundation
import UIKit

extension String.Index {
    func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
    
    //    func localized() -> String {
    //        return NSLocalizedString(self,
    //                                 tableName: "Localizable",
    //                                 bundle: .main,
    //                                 value: self,
    //                                 comment: self
    //        )
    //    }
}

extension String {
    func localize(comment: String = "") -> String {
        let defaultLanguage = "en"
        let value = NSLocalizedString(self, comment: comment)
        if value != self || NSLocale.preferredLanguages.first == defaultLanguage {
            return value // String localization was found
        }
        
        // Load resource for default language to be used as
        // the fallback language
        guard let path = Bundle.main.path(forResource: defaultLanguage, ofType: "lproj"), let bundle = Bundle(path: path) else {
            return value
        }
        
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

extension StringProtocol {
    func distance(of element: Element) -> Int? { firstIndex(of: element)?.distance(in: self) }
    func distance<S: StringProtocol>(of string: S) -> Int? { range(of: string)?.lowerBound.distance(in: self) }

    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

extension NSMutableAttributedString {
    
    func replace(_ findString: String, with replacement: String, attributes: [NSAttributedString.Key : Any]) {
        
        let ms = mutableString
        
        var range = ms.range(of: findString)
        while range.location != NSNotFound {
            addAttributes(attributes, range: range)
            ms.replaceCharacters(in: range, with: replacement)
            
            range = ms.range(of: findString)
        }
    }
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}

extension Date {
    var startOfWeek: Date {
        return Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    
    var addingOneWeek: Date {
        return Calendar.gregorian.date(byAdding: DateComponents(weekOfYear: 1), to: self)!
    }
    
    var nextSunday: Date {
        return startOfWeek.addingOneWeek
    }
    
    func nextFollowingSundays(_ limit: Int) -> [Date] {
        precondition(limit > 0)
        var sundays = [nextSunday]
        sundays.reserveCapacity(limit)
        return [nextSunday] + (0..<limit-1).compactMap { _ in
            guard let next = sundays.last?.addingOneWeek else { return nil }
            sundays.append(next)
            return next
        }
    }
    
    var month: String {
        let names = Calendar.current.monthSymbols
        let month = Calendar.current.component(.month, from: self)
        return names[month - 1]
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    func blink() {
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.5, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 1.0 },
            completion: { [weak self] _ in self?.alpha = 0.0 })
    }

    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}

extension UIColor {
  static var themeGreenColor: UIColor {
    return UIColor(red: 0.0, green: 104 / 255.0, blue: 55 / 255.0, alpha: 1)
  }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
