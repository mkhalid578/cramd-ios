//
//  RegisterPopup.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 10/23/26.
//

import SwiftUI

struct RegisterPopup: View {
    @Environment(\.dismiss) var dismiss
    
    let auth: AuthService
    
    // Form Inputs
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // Computed property to validate inputs
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && password == confirmPassword
        && password.count >= 6
    }
    
    @State private var successMsg: String = ""
    @State private var success: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                // Form Fields
                VStack(spacing: 16) {
                    CustomTextField(
                        placeholder: "First Name",
                        text: $firstName,
                        isSecure: false
                    )
                    .textContentType(.givenName)
                    .autocapitalization(.none)
                    
                    CustomTextField(
                        placeholder: "Last Name",
                        text: $lastName,
                        isSecure: false
                    )
                    .textContentType(.familyName)
                    .autocapitalization(.none)
                    
                    CustomTextField(
                        placeholder: "Email Address",
                        text: $email,
                        isSecure: false
                    )
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    
                    CustomTextField(
                        placeholder: "Password (min 6 chars)",
                        text: $password,
                        isSecure: true
                    )
                    .textContentType(.newPassword)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    CustomTextField(
                        placeholder: "Confirm Password",
                        text: $confirmPassword,
                        isSecure: true
                    )
                    .textContentType(.newPassword)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                }
                .padding(.horizontal)
                
                // Submit Button
                Button(action: {
                    
                    Task {
                        do {
                            try await auth.register(
                                email: email,
                                firstName: firstName,
                                lastName: lastName,
                                password: password
                            )
                        } catch {
                            successMsg = "Registration Failed : \(error)"
                        }
                    }
                }) {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(10)
                    
                }
                .disabled(!isFormValid)
                .padding(.horizontal)
                .padding(.top, 10)
                
                Text(successMsg)
                    .font(.headline)
                    .foregroundColor(success ? .green : .red)
                    .frame(maxWidth: .infinity, maxHeight: 64)
                    .cornerRadius(8)
                    .padding()
                
                Spacer()
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}




#Preview {
    RegisterPopup(
        auth: AuthService(
            client: Client(
                baseURL: URL(
                    string: "http://localhost:3000"
                )!
            )
        )
    )
}
