//
//  Auth.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 10/28/26.
//

import Foundation

struct AuthService {
    let baseURL: URL

    func login(email: String, password: String) async throws -> LoginResponse {
        try await post(
            path: ["auth", "login"],
            body: LoginRequest(email: email, password: password)
        )
    }

    func register(
        email: String,
        firstName: String,
        lastName: String,
        password: String
    ) async throws -> RegisterResponse {
        try await post(
            path: ["auth", "register"],
            body: RegisterRequest(
                email: email,
                firstName: firstName,
                lastName: lastName,
                password: password
            )
        )
    }

    private func post<Body: Encodable, Response: Decodable>(
        path: [String],
        body: Body
    ) async throws -> Response {
        let url = path.reduce(baseURL) { $0.appendingPathComponent($1) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw AuthError.requestFailed(statusCode: httpResponse.statusCode)
        }

        return try JSONDecoder().decode(Response.self, from: data)
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
