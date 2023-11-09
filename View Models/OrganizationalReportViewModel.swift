//
//  OrganizationalReportViewModel.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 1/17/23.
//

import Foundation

struct OrganizationalReportViewModel {
    var allOrgCalMbr: [OrgMbrCalling]?
    var selectedOrgCalMbr: [OrgMbrCalling]?
    var selectedOrganization: String?
    var organizationsTableViewDataSource = [String]()
}
