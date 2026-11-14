//
//  HomePage.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 11/1/26.
//

import SwiftUI

struct HomePage : View {
    
    @Binding var activeUser: LoginResponse?
    @State var selectedTab: Int = 2
    var carService: CarService
    var body: some View {
        
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: 0) {
                    UserBar(user: $activeUser)
//                ReceivedView()
            }



            Tab("Cars", systemImage: "car", value: 1) {
//                SentView()
                CarView(carService: carService, user: $activeUser)
            }


            Tab("Settings", systemImage: "gear", value: 2) {
//                AccountView()
                NavigationStack {
                    List {
                        NavigationLink("Account") {
                           Text("Hello")
                        }
                        NavigationLink("Account") {
                           Text("Hello")
                        }
                        NavigationLink("Account") {
                           Text("Hello")
                        }
                        NavigationLink("Account") {
                           Text("Hello")
                        }
                    }
                    .navigationTitle("General")
                }
            }
        }
    }
}

#Preview {
    HomePage(activeUser: .constant(nil), carService: CarService(client: Client(baseURL: URL(string: "http://localhost:3000")!)))
}
