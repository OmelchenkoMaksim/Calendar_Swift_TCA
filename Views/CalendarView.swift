// Views/CalendarView.swift
import SwiftUI
import ComposableArchitecture

struct CalendarView: View {
    let store: StoreOf<CalendarFeature>
    
    var body: some View {
        WithViewStore(
            self.store,
            observe: { state in state }
        ) { viewStore in
            NavigationStack {
                VStack {
                    Picker(
                        "View Mode",
                        selection: viewStore.binding(
                            get: { state in state.viewMode },
                            send: { newViewMode in CalendarFeature.Action.changeViewMode(newViewMode) }
                        )
                    ) {
                        ForEach(
                            CalendarFeature.State.ViewMode.allCases,
                            id: \.self
                        ) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    
                    CalendarGridView(store: self.store)
                    
                    EventsListView(store: self.store)
                }
                .navigationTitle(Text("Calendar"))
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                        Button(
                            action: {
                                viewStore.send(CalendarFeature.Action.addEventTapped)
                            }
                        ) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(
                    isPresented: viewStore.binding(
                        get: { state in state.isAddingEvent },
                        send: { _ in CalendarFeature.Action.addEventTapped }
                    )
                ) {
                    AddEventView(store: self.store)
                }
            }
            .onAppear {
                viewStore.send(CalendarFeature.Action.loadEvents)
            }
        }
    }
}
