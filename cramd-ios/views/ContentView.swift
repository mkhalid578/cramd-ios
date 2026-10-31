import SwiftUI

struct ContentView: View {
    @State private var localUser: LoginResponse?
    @State private var email: String = ""
    @State private var password: String = ""

    private let appServices = AppServices(
        baseUrl: URL(string: "http://localhost:3000")!
    )

    var body: some View {
        VStack(spacing: 8) {

            if localUser?.token != nil {
                CarView(
                    carService: appServices.cars,
                    user: $localUser
                )

            } else {
                LoginView(
                    authService: appServices.auth,
                    activeUser: $localUser
                )
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
