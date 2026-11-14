import SwiftUI

struct ContentView: View {
    @State private var localUser: LoginResponse?
    @State private var email: String = ""
    @State private var password: String = ""

    private let appServices = AppServices(
        baseUrl: URL(string: "http://localhost:3000")!
    )

    var body: some View {

        if localUser?.token != nil {

            HomePage( activeUser: $localUser, carService: appServices.cars)
        } else {

            LoginView(
                authService: appServices.auth,
                activeUser: $localUser
            )
        }
    }
}

#Preview {
    ContentView()
}
