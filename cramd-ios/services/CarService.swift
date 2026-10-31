//
//  CarService.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 10/30/26.
//

import Foundation

struct Car: Codable, Identifiable{
    let id: Int
    let make: String
    let model: String
    let modelYear: Int
    let trim: String
    let bodyStyle: String
    let powertrain: String
    let cargoVolSeatsFoldedCuFt: Float?
    let cargoVolBehind2ndRowCuFt: Float?
    let createdAt: String
}

enum CarError: Error {
    case invalidUrl
    case missingToken
    case invalidResponse
    case requestFailed(statusCode: Int)
    case invalidData
}

@MainActor	
final class CarService {
    private var client: Client
    
    init(baseURL: URL) {
        self.client = Client(baseURL: baseURL)
    }
    
    func getCars() async throws -> [Car] {
        try await client.get(path: ["cars"])
    }
}
