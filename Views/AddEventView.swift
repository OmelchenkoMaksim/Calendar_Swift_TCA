// Views/AddEventView.swift
import SwiftUI
import ComposableArchitecture
import Foundation

struct AddEventView: View {
    let store: StoreOf<CalendarFeature>
    @Environment(\EnvironmentValues.dismiss) var dismiss: DismissAction
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(TimeInterval(3600))
    @State private var category: Event.Category = Event.Category.other
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Event Details")) {
                    TextField(
                        "Title",
                        text: self.$title
                    )
                    TextField(
                        "Description",
                        text: self.$description
                    )
                }
                
                Section(header: Text("Time")) {
                    DatePicker(
                        "Start",
                        selection: self.$startDate,
                        displayedComponents: [.date, .hourAndMinute] // Указаны компоненты явно
                    )
                    DatePicker(
                        "End",
                        selection: self.$endDate,
                        displayedComponents: [.date, .hourAndMinute] // Указаны компоненты явно
                    )
                }
                
                Section(header: Text("Category")) {
                    Picker(
                        "Category",
                        selection: self.$category
                    ) {
                        ForEach(
                            Event.Category.allCases,
                            id: \Event.Category.self
                        ) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
            }
            .navigationTitle(Text("New Event"))
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
            .toolbar {
                ToolbarItem(
                    placement: ToolbarItemPlacement.navigationBarLeading
                ) {
                    Button(
                        action: { self.dismiss() },
                        label: { Text("Cancel") }
                    )
                }
                ToolbarItem(
                    placement: ToolbarItemPlacement.navigationBarTrailing
                ) {
                    Button(
                        action: { /* тут добавлю какую нить логику позже */ },
                        label: { Text("Add") }
                    )
                    .disabled(self.title.isEmpty || self.endDate <= self.startDate)
                }
            }
        }
    }
}
