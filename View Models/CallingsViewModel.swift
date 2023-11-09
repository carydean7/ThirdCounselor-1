//
//  CallingsViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 12/27/21.
//

import Foundation
import CoreData

class CallingsViewModel {
    var callingName: String = ""
    var name: String = ""
    var selectedOrganization: String?
    var callIsFilled: Bool = false
    var organizationsTableViewDataSource = [String]()
    var tableViewDataSource = [OrgMbrCalling]()
    
    @Published var callings: [Calling]? = []
    
    static let shared = CallingsViewModel()
    
    init() {}
}
