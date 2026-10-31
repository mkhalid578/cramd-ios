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

    var authService: AuthService
    @Binding var activeUser: LoginResponse?
    @State private var showSignup = false

    var body: some View {
        VStack(spacing: 16) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
            VStack(spacing: 16) {
                CustomTextField(
                    placeholder: "Email Address",
                    text: $email,
                    isSecure: false
                )
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

                CustomTextField(
                    placeholder: "Password",
                    text: $password,
                    isSecure: true
                )
                Text("Forgot password?")
                    .font(.subheadline)
                    .frame(maxWidth: 352, alignment: .trailing)

            }
            .padding(.horizontal)

            HStack {

                Button {
                    Task {
                        do {
                            activeUser = try await authService.login(
                                email: email,
                                password: password
                            )
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

            //            Text("\(authService. ?? "")")
            //                .foregroundColor(Color.red)
            // @TODO add error msg to auth service

            Button(action: { showSignup = true }) {
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

}

#Preview {
    LoginView(
        authService: AuthService(baseURL: URL(string: "http://localhost:3000")!),
        activeUser: .constant(nil)
    )
}
