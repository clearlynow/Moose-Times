//
//  vm_pad.swift
//  multiplications
//
//  Created by Maxime Durand on 25/03/2020.
//  Copyright © 2020 Temmple. All rights reserved.
//

import SwiftUI

struct vm_pad: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 70, height: 70, alignment: .center)
    }
}
