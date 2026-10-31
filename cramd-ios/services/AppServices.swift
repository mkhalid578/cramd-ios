//
//  AppServices.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 10/31/26.
//

import Foundation

struct AppServices {
    let auth: AuthService
    let cars: CarService
    
    init(baseUrl: URL) {
        let client = Client(baseURL: baseUrl)
        auth = AuthService(client: client)
        cars = CarService(client: client)
    }
}
