//
//  ContentView.swift
//  HabbitTracker
//
//  Created by Сергей Захаров on 03.04.2026.
//

/*
 
 
 Build a habit-tracking app. Users can add different activities (learning a language, practicing an instrument, exercising, etc.), and track it however they want.

 List of must-have features:
 — a list of all activities user can track
 — a form to add new activities – a title and description should be enough
 — detail screen for every created activity and how many times it have been completed
 - use Codable and UserDefaults to load and save data

 */

import SwiftUI

/// Card-shaped press feedback. Avoid `List` for styled `NavigationLink` rows — `List` uses UIKit cells and breaks this.
private struct ListCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.blue.opacity(configuration.isPressed ? 0.14 : 0.08))
            configuration.label
        }
        .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct HabbitItem: Identifiable, Codable {
    var id: UUID = UUID()
    let type: String
    var duration: Double = 0.0
}

@Observable
class Habbits {
    var items = [HabbitItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
        
    init () {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([HabbitItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }

    func removeItem(id: UUID) {
        items = items.filter { $0.id != id }
    }
}


struct ContentView: View {
    @State private var habbits = Habbits()
    
    var body: some View {
        @Bindable var habbits = habbits
        return NavigationStack {
            ScrollView {
                LazyVStack(spacing: 4) {
                    if habbits.items.isEmpty {
                        Text("No habbits added yet. \n Tap the button to get started.")
                            .font(.headline)
                            .padding(.vertical, 48)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.gray)
                            .background(.gray.opacity(0.12))
                            .cornerRadius(16)
                            .multilineTextAlignment(.center)
                    } else {
                        ForEach($habbits.items) { $item in
                            AddItemToView(item: $item, habbits: habbits)
                        }
                    }
                }
                .padding(.top, 12)
            }
            .navigationTitle("Habbit Tracker")
            .safeAreaInset(edge: .bottom, spacing: 0) {
                NavigationLink(destination: AddHabbit(habbits: habbits)) {
                    Text("Add new habbit")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
                .padding(.vertical, 20)
                .buttonStyle(.glassProminent)
            }
        }
    }
    
    func AddItemToView(item: Binding<HabbitItem>, habbits: Habbits) -> some View {
        NavigationLink {
            DetailHabbit(habbits: habbits, itemId: item.wrappedValue.id)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(item.wrappedValue.type)")
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("spend \(item.wrappedValue.duration.formatted()) hours")
                        .font(.caption)
                        .foregroundStyle(.primary.opacity(0.56))
                }
                Spacer()
                Stepper(value: item.duration, in: 0...24, step: 0.5) { }
                    .labelsHidden()
            }
            .padding(20)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(ListCardButtonStyle())
        .navigationLinkIndicatorVisibility(.hidden)
    }
}

#Preview {
    ContentView()
}
