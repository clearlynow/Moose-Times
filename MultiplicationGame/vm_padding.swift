//
//  vm_padding.swift
//  multiplications
//
//  Created by Maxime Durand on 27/03/2020.
//  Copyright © 2020 Temmple. All rights reserved.
//

import SwiftUI

struct vm_padding: ViewModifier {
    
    let top: CGFloat
    let trailing: CGFloat
    let bottom: CGFloat
    let leading: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.top, top)
            .padding(.trailing, trailing)
            .padding(.bottom, bottom)
            .padding(.leading, leading)
    }
}
