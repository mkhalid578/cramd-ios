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
    @Bindable var isAuthenticated: Bool = false
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
                
                Button(action: {
                    print("username:", $email.wrappedValue)
                    print("password:", $password.wrappedValue)
                    self.isAuthenticated = true
                }) {
                    Text("LOGIN")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
        
            }
            .padding(.horizontal)
            
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
        
        print("here")
        
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(LoginResponse.self, from: data)
        } catch {
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

enum LoginError: Error {
    case invalidUrl
    case invalidData
}


#Preview {
    LoginView()		
}
