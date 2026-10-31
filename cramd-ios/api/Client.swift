//
//  Client.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 10/30/26.
//
import Foundation
	
struct Client {
    
    let baseURL: URL
    var token: String = ""
    //@TODO get()
    
    mutating func setToken(token: String) {
        self.token = token
    }	
    
    func post<Body: Encodable, Response: Decodable>(
        path: [String],
        body: Body
    ) async throws -> Response {
        let url = path.reduce(baseURL) { $0.appendingPathComponent($1) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (!token.isEmpty) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
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
    
    func get<Response: Decodable>(
        path: [String]
    ) async throws -> Response {
        let url = path.reduce(baseURL) { $0.appendingPathComponent($1) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (!token.isEmpty) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw AuthError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try decoder.decode(Response.self, from: data)
    }}
