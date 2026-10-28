//
//  UserBar.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 10/24/26.
//

//
//  CarPopup.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 10/24/26.
//

import SwiftUI

struct UserBar: View {
    @Binding var user: LoginResponse?
    @State private var isExpanded = false
    var body: some View {
        HStack  {
                        
            Text("Hi, \(user?.firstName ?? "User" )")
            Image("face-icon")
                .background(Color.gray.ignoresSafeArea())
                .clipShape(Circle())
                .frame(width: 32, height: 32)
            Image(systemName: "chevron.down")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                                           isExpanded.toggle()
                                                       }
                                    }

        }
    }
    
    
    
}


#Preview {
    UserBar(user: .constant(nil))
}
