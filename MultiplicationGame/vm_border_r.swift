//
//  vm_border.swift
//  multiplications
//
//  Created by Maxime Durand on 27/03/2020.
//  Copyright © 2020 Temmple. All rights reserved.
//

import SwiftUI


// Border rectangle
struct vm_border_r: ViewModifier {
    
    let radius: CGFloat
    let color: Color
    let lineWidth: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: lineWidth)
            )
    }
}
