//
//  DetailHabbit.swift
//  HabbitTracker
//
//  Created by Сергей Захаров on 04.04.2026.
//

import SwiftUI

struct DetailHabbit: View {
    @Environment(\.dismiss) private var dismiss

    var habbits: Habbits
    let itemId: UUID

    private var item: HabbitItem? {
        habbits.items.first { $0.id == itemId }
    }

    private var durationBinding: Binding<Double> {
        Binding(
            get: { habbits.items.first(where: { $0.id == itemId })?.duration ?? 0 },
            set: { newValue in
                var next = habbits.items
                if let i = next.firstIndex(where: { $0.id == itemId }) {
                    next[i].duration = newValue
                    habbits.items = next
                }
            }
        )
    }

    var body: some View {
        Form {
            Stepper(value: durationBinding, in: 0...24, step: 0.5) {
                Text(
                    "Spend \(durationBinding.wrappedValue.formatted(.number.precision(.fractionLength(1)))) hours"
                )
            }
        }
        .navigationTitle(item?.type ?? "Sport")
        .onChange(of: habbits.items.map(\.id)) { _, _ in
            if !habbits.items.contains(where: { $0.id == itemId }) {
                dismiss()
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button("Delete", role: .destructive) {
                habbits.removeItem(id: itemId)
                dismiss()
            }
            .padding(.vertical, 20)
            .buttonStyle(.glassProminent)
            .controlSize(.extraLarge)
        }
    }
}

#Preview {
    let id = UUID()
    let store = Habbits()
    store.items = [HabbitItem(id: id, type: "Sport", duration: 1.5)]
    return NavigationStack {
        DetailHabbit(habbits: store, itemId: id)
    }
}
