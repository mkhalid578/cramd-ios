//
//  CarView.swift
//  cramd-ios
//
//  Created by Muhammed Khalid on 10/23/26.
//

import SwiftUI

struct CarView: View {
    var carService: CarService
    @Binding var user: LoginResponse?
    @State var isCarSelected: Bool = false
    @State private var cars: [Car]?
    @State var selectedCar: Car?

    var body: some View {
        UserBar(user: $user)

        NavigationStack {

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
                    cars = try await carService.getCars()
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
            CarPopup(car: $selectedCar)
                .presentationDetents([.fraction(0.65), .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    CarView(
        carService: CarService(baseURL: URL(string: "http://localhost:3000")!),
        user: .constant(nil),
        isCarSelected: false,
    )
}
