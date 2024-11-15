// Views/EventsListView.swift
import SwiftUI
import ComposableArchitecture
import Foundation

struct EventsListView: View {
    let store: StoreOf<CalendarFeature>
    
    var body: some View {
        WithViewStore(
            self.store,
            observe: { state in state }
        ) { viewStore in
            List {
                ForEach(
                    viewStore.events,
                    id: \Event.id
                ) { event in
                    EventRow(event: event)
                        .swipeActions {
                            Button(
                                role: ButtonRole.destructive,
                                action: {
                                    viewStore.send(CalendarFeature.Action.deleteEvent(event.id))
                                }
                            ) {
                                Label(
                                    "Delete",
                                    systemImage: "trash"
                                )
                            }
                        }
                }
            }
        }
    }
}

private struct EventRow: View {
    let event: Event
    
    var body: some View {
        VStack(
            alignment: HorizontalAlignment.leading,
            spacing: CGFloat(4)
        ) {
            Text(event.title)
                .font(Font.headline)
            Text(event.description)
                .font(Font.subheadline)
                .foregroundColor(Color.secondary)
            HStack(
                alignment: VerticalAlignment.center,
                spacing: CGFloat(4)
            ) {
                Text(event.startDate, style: Text.DateStyle.time)
                Text("-")
                Text(event.endDate, style: Text.DateStyle.time)
            }
            .font(Font.caption)
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
    }
}
