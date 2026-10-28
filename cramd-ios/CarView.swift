//
//  CarView.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 10/23/26.
//

import SwiftUI

struct CarView: View {
    @Binding var user: LoginResponse?
    @State var isCarSelected: Bool = false
    @State private var cars: [Car]?
    @State var selectedCar: Car?

    var body: some View {
        NavigationStack {
            
            UserBar(user: $user)
            
            List(cars ?? []) { car in
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(car.make) \(car.model)")
                            .font(.headline)
                        Text(verbatim: "\(car.modelYear) · \(car.trim)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: 320, alignment: .leading)
                .frame(height: 200)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                )
                .frame(maxWidth: .infinity)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .onTapGesture {
                    isCarSelected = true
                    selectedCar = car
                    print("\(car.model)")
                }
            }
            .listStyle(.plain)
            .navigationTitle("Cars")
            .task {
                do {
                    cars = try await getCars()
                } catch {
                    print("Failed to load cars: \(error)")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Cancel") {
                }
            }
        }
        .sheet(isPresented: $isCarSelected) {
            CarPopup(car: $selectedCar )
                .presentationDetents([.fraction(0.65), .large])
                .presentationDragIndicator(.visible)
        }
    }

    func getCars() async throws -> [Car] {
        let endpoint = "http://localhost:3000/cars"
        guard let url = URL(string: endpoint) else {
            throw CarError.invalidUrl
        }
//        guard let token = user?.token, !token.isEmpty else {
//            throw CarError.missingToken
//        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw CarError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw CarError.requestFailed(statusCode: httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Car].self, from: data)
        } catch {
            print("Car response could not be decoded: \(error)")
            throw CarError.invalidData
        }
    }
}

#Preview {
    CarView(user: .constant(nil), isCarSelected: false)
}

struct Car: Codable, Identifiable{
    let id: Int
    let make: String
    let model: String
    let modelYear: Int
    let trim: String
    let bodyStyle: String
    let powertrain: String
    let cargoVolSeatsFoldedCuFt: Float?
    let cargoVolBehind2ndRowCuFt: Float?
    let createdAt: String
}

enum CarError: Error {
    case invalidUrl
    case missingToken
    case invalidResponse
    case requestFailed(statusCode: Int)
    case invalidData
}
