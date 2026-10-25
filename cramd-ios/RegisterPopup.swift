//
//  RegisterPopup.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 10/23/26.
//

import SwiftUI

struct RegisterPopup: View {
    @Environment(\.dismiss) var dismiss
    
    // Form Inputs
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // Computed property to validate inputs
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && password == confirmPassword && password.count >= 6
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                // Form Fields
                VStack(spacing: 16) {
                    CustomTextField(placeholder: "First Name", text: $firstName, isSecure: false)
                        .textContentType(.givenName)
                        .autocapitalization(.none)
                    
                    CustomTextField(placeholder: "Last Name", text: $lastName, isSecure: false)
                        .textContentType(.familyName)
                        .autocapitalization(.none)
                    
                    
                    CustomTextField(placeholder: "Email Address", text: $email, isSecure: false)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    CustomTextField(placeholder: "Password (min 6 chars)", text: $password, isSecure: true)
                        .textContentType(.newPassword)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    CustomTextField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                        .textContentType(.newPassword)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                .padding(.horizontal)
                
                // Submit Button
                Button(action: {
                    // Handle sign up logic here
                    print("Registering user with email: \(email)")
                    dismiss() // Automatically dismisses the popup on success
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

// MARK: - Reusable Custom Input Component
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

#Preview {
    RegisterPopup()
}
