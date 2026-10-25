//
//  CarPopup.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 10/24/26.
//

import SwiftUI

struct CarPopup: View {
    @Binding var car: Car?
    var body: some View {
        VStack (spacing: 16) {
            Text("\(car?.make ?? "Toyota")")
            Text("\(car?.trim ?? "Trim")")
            Text("\(car?.powertrain ?? "Powertrain")")

        }
    }
    
    
    
}


#Preview {
    CarPopup(car: .constant(nil))
}
