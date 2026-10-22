//
//  LoginView.swift
//  MyApp
//
//  Created by Muhammed Khalid on 10/20/26.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginError: LoginErrorResponse?
    @Binding var isAuthenticated: Bool
    @Binding var activeUser: LoginResponse?
    var body: some View {
        VStack(spacing: 32) {
            Label("Cramd", systemImage: "")
            
            TextField("Username or email", text: $email)
                .font(.body)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.purple, lineWidth: 1)
                )
                .padding(.horizontal)
            VStack (spacing: 8) {
                SecureField("Password", text: $password)
                    .font(.body)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay (
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.purple, lineWidth: 1)
                    )
                    .padding(.horizontal)
                Text("Forgot password?")
                    .font(.subheadline)
                    .frame(maxWidth: 352, alignment: .trailing)

            }
            
            HStack {
                	
                Button {
                    Task {
                        do {
                            loginError = nil
                            activeUser = try await loginUser()
                            isAuthenticated = true
                        } catch {
                            print("Login failed: \(error)")
                        }
                    }
                } label: {
                    Text("LOGIN")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
        
            }
            .padding(.horizontal)
            
            Text("\(loginError?.error ?? "")")
                .foregroundColor(Color.red)
            
            Text("Don't have an account? SIGN UP")
            
        }
    }
    
    func loginUser() async throws -> LoginResponse {
        let endpoint = "http://localhost:3000/auth/login"
        guard let url = URL(string: endpoint) else {
            throw LoginError.invalidUrl
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        

            let encoder = JSONEncoder()
            let loginData = try encoder.encode(LoginUser(email: email, password: password))
        
        request.httpBody = loginData
        
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw LoginError.invalidResponse
        }
        print("Login response status: \(httpResponse.statusCode)")

        guard (200..<300).contains(httpResponse.statusCode) else {
            let decoder = JSONDecoder()
            loginError = try decoder.decode(LoginErrorResponse.self, from: data)
            throw LoginError.requestFailed(statusCode: httpResponse.statusCode)
        }
        guard !data.isEmpty else {
            throw LoginError.emptyResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let loginResponse = try decoder.decode(LoginResponse.self, from: data)
            print("Login response decoded successfully")
            return loginResponse
        } catch let error {
            print("Login response could not be decoded: \(error)")
            throw LoginError.invalidData
        }
    }
}

struct LoginUser : Codable {
    let email: String
    let password: String
}

struct LoginResponse : Codable {
    let email: String
    let firstName: String
    let lastName: String
    let token: String
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


#Preview {
    LoginView(isAuthenticated: .constant(false), activeUser: .constant(nil))
}
