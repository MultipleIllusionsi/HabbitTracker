//
//  AddHabbit.swift
//  HabbitTracker
//
//  Created by Сергей Захаров on 03.04.2026.
//

import SwiftUI

struct AddHabbit: View {
    @Environment(\.dismiss) private var dismiss

    @State private var type = "Sport"
    @State private var duration = 0.0

    var habbits: Habbits

    let types = ["Sport", "Walking", "Reading", "Coding", "Cooking"]

    var body: some View {
        Form {
            Picker("Type", selection: $type) {
                ForEach(types, id: \.self) {
                    Text($0)
                }
            }
        }
        .navigationTitle("Add new habbit")
//        .toolbar {
//            ToolbarItem(placement: .confirmationAction) {
//                Button("Save") {
//                    let item = HabbitItem(type: type, duration: duration)
//                    var next = habbits.items
//                    next.append(item)
//                    habbits.items = next
//                    dismiss()
//                }
//            }
//        }
        
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button("Save") {
                let item = HabbitItem(type: type, duration: duration)
                var next = habbits.items
                next.append(item)
                habbits.items = next
                dismiss()
            }
            .padding(.vertical, 20)
            .buttonStyle(.glassProminent)
            .controlSize(.extraLarge)
        }
    }
}

#Preview {
    NavigationStack {
        AddHabbit(habbits: Habbits())
    }
}
