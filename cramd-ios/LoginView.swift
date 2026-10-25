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
    @State private var showSignup = false
    
    @Binding var activeUser: LoginResponse?
    var body: some View {
        VStack(spacing: 16) {
            
            VStack(spacing: 16) {
                CustomTextField(placeholder: "Email Address", text: $email, isSecure: false)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                Text("Forgot password?")
                    .font(.subheadline)
                    .frame(maxWidth: 352, alignment: .trailing)
                
        
            }
            .padding(.horizontal)
            
            HStack {
                	
                Button {
                    Task {
                        do {
                            loginError = nil
                            activeUser = try await loginUser()
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
                .disabled(password.isEmpty)
        
            }
            .padding(.horizontal)
            
            Text("\(loginError?.error ?? "")")
                .foregroundColor(Color.red)
            
            
            Button (action: {showSignup = true}) {
                Text("Don't have an account? Sign up")
                    .font(.headline)
                
            }
            .padding(.horizontal, 40)
            
        }
        .sheet(isPresented: $showSignup) {
            RegisterPopup()
                .presentationDetents([.fraction(0.65), .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    func loginUser() async throws -> LoginResponse {
        let endpoint = ProcessInfo.processInfo.environment["LOGIN_URL"]
        guard let url = URL(string: endpoint ?? "") else {
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
    LoginView(activeUser: .constant(nil))
}
