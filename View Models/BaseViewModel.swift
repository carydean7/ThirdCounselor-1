//
//  BaseViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 6/7/23.
//

import Foundation
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Network

protocol AddButtonDelegate {
    func addButtonAction()
}

@MainActor class BaseViewModel: ObservableObject {
    @Published var shouldShowAddItemButton = true
    @Published var showDeleteMember = true
    @Published var isSheet = false
    @Published var isInnerListHeader = false
    
    var db: Firestore? = Firestore.firestore()
    
    let defaults = UserDefaults.standard
    
    func speakingAssignmentOrPrayerInLast6Months(date: Date) -> Bool {
        let months = Date().months(from: date)
        
        if months <= 6{
            return true
        }
        
        return false
    }

    func speakingAssignmentOrPrayerIsOverAYear(date: Date) -> Bool {
        let months = Date().months(from: date)
        
        if months > 12 {
            return true
        }

        return false
    }
    
    func speakingAssignmentOrPrayerIsBetween6MonthsAnd1Year(date: Date) -> Bool {
        let months = Date().months(from: date)
        
        let range = 6...12
        
        if range.contains(months) {
            return  true
        }
        
        return false
    }
}
