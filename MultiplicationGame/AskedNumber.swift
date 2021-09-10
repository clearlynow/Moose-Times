//
//  AskedNumber.swift
//  multiplications
//
//  Created by Maxime Durand on 24/03/2020.
//  Copyright © 2020 Temmple. All rights reserved.
//

import SwiftUI

struct AskedNumber: View {
    
    let number: String
    
    var body: some View {
        Image("panneau")
            .resizable()
            .frame(width:100, height: 80)
            .scaledToFit()
            .overlay(
                Text(number)
                    .bold()
                    .padding(25)
                    .foregroundColor(Color("light"))
                    .font(.largeTitle)
                    
        )
        
    }
}

struct AskedNumber_Previews: PreviewProvider {
    static var previews: some View {
        AskedNumber(number: "5")
    }
}
