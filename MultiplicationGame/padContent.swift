//
//  padContent.swift
//  multiplications
//
//  Created by Maxime Durand on 27/03/2020.
//  Copyright © 2020 Temmple. All rights reserved.
//

import SwiftUI

struct padContent: View {
    
    let number: String
    
    var body: some View {
        Color(.clear)
            .overlay(
                Text(number)
                    .foregroundColor(Color.white)
                    .font(.title)
        )
    }
}

struct padContent_Previews: PreviewProvider {
    static var previews: some View {
        
        
        Image("woodPad").resizable()
            .modifier(vm_pad())
        .overlay(
            Button(action: {}) {
                padContent(number: "1")
            }
        )
    }
}
