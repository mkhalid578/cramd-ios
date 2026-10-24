import SwiftUI

struct ContentView: View {
    @State private var user: GithubUser?
    @State private var localUser: LoginResponse?
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) {
                image in image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
            
                .frame(width: 120, height: 120)
            if(localUser?.token != nil) {
                CarView(user: $localUser)
                
                
            } else {
                LoginView(activeUser: $localUser)
            }
            
            
            Spacer()
        }
        .padding()
        .task {
            do {
                user = try await getUser()
            } catch GHError.invalidUrl {
                print("Invalid url")
            } catch GHError.invalidData {
                print("Invalid Data")
            } catch GHError.invalidResponse {
                print("Invalid reponse")
            } catch {
                print("unexpected error")
            }
        }
    }
    
    func getUser() async throws -> GithubUser {
        let endpoint = "https://api.github.com/users/mkhalid578"
        
        guard let url = URL(string: endpoint) else { throw GHError.invalidUrl
        }
        
        // url session
        
        let (data, response) = try await URLSession.shared.data(from: url)
        	
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GithubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    
}

#Preview {
    ContentView()
}

struct GithubUser : Codable {
    let login: String
    let avatarUrl: String
    let bio: String
}


enum GHError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}
