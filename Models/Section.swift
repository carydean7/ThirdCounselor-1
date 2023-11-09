//
//  Section.swift
//  Hero Carousel
//
//  Created by Dean Wagstaff on 7/5/23.
//

import SwiftUI

struct ConductingSheetContent: Identifiable {
    var id = UUID().uuidString
    var index: Int = 0
    var upperContent: String
    var lowerContent: String
}
