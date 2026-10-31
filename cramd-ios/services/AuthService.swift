//
//  Auth.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 10/28/26.
//

import Foundation

@MainActor
final class AuthService {
    private var client: Client

    init(baseURL: URL) {
        self.client = Client(baseURL: baseURL)
    }

    func login(email: String, password: String) async throws -> LoginResponse {
        let response: LoginResponse = try await client.post(
            path: ["auth", "login"],
            body: LoginRequest(email: email, password: password)
        )
        client.setToken(token: response.token ?? "")
        return response
    }
    

    func register(
        email: String,
        firstName: String,
        lastName: String,
        password: String
    ) async throws -> RegisterResponse {
        try await client.post(
            path: ["auth", "register"],
            body: RegisterRequest(
                email: email,
                firstName: firstName,
                lastName: lastName,
                password: password
            )
        )
    }
}

struct LoginRequest: Encodable {
    let email: String?
    let password: String?
}

struct RegisterRequest: Encodable {
    let email: String
    let firstName: String
    let lastName: String
    let password: String
}

enum AuthError: Error {
    case invalidResponse
    case requestFailed(statusCode: Int)
}
struct RegisterResponse: Codable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let password: String?
}
struct LoginResponse : Codable {
    let email: String?
    let first_name: String?
    let last_name: String?
    let token: String?
}

struct LoginUser : Codable {
    let email: String
    let password: String
}



struct LoginErrorResponse: Codable {
    let error: String
}

enum LoginError: Error {
    case invalidUrl
    case invalidResponse
    case requestFailed(statusCode: Int)
    case emptyResponse
    case invalidData
}
