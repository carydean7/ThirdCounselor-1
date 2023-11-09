//
//  Modifiers.swift
//  ThirdCounselor
//
//  Created by Dean Wagstaff on 9/21/23.
//

import SwiftUI

struct TextModifier: ViewModifier {
    var color: Color
    var font: Font
    var btmPad: CGFloat
    var topPad: CGFloat
    var leadPad: CGFloat
    var trailPad: CGFloat
    var width: CGFloat
    var alignment: Alignment
    
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .padding(.bottom, btmPad)
            .padding(.top, topPad)
            .padding(.leading, leadPad)
            .padding(.trailing, trailPad)
            .frame(maxWidth: width, alignment: alignment)
            .frame(maxHeight: .infinity)
    }
}

struct CustomButtonModifier: ViewModifier {
    var color: Color
    var font: Font
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .frame(height: 35)
            .frame(width: 140)
            .background(RoundedCorners(color: color, tl: 10, tr: 10, bl: 10, br: 10))
           // .padding(.bottom, 10)
    }
}

extension View {
    func customButton(color: Color, font: Font) -> some View {
        modifier(CustomButtonModifier(color: color, font: font))
    }
    
    func customText(color: Color,
                    font: Font,
                    btmPad: CGFloat,
                    topPad: CGFloat,
                    leadPad: CGFloat,
                    trailPad: CGFloat,
                    width: CGFloat,
                    alignment: Alignment) -> some View {
        modifier(TextModifier(color: color,
                              font: font,
                              btmPad: btmPad,
                              topPad: topPad,
                              leadPad: leadPad,
                              trailPad: trailPad,
                              width: width,
                              alignment: alignment))
    }
}
