//
//  Br.swift
//  multiplications
//
//  Created by Maxime Durand on 24/03/2020.
//  Copyright © 2020 Temmple. All rights reserved.
//

import SwiftUI

struct Br: View {
    
    let size: Int
    
    var body: some View {
        Text("")
        .padding(.top, CGFloat(size))
    }
}

struct Br_Previews: PreviewProvider {
    static var previews: some View {
        Br(size: 10)
    }
}
