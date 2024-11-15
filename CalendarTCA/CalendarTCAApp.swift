// CalendarTCAApp.swift
import ComposableArchitecture
import SwiftUI

/// Главная точка входа в приложение CalendarTCA.
@main
struct CalendarTCAApp: App {
    /// Хранилище состояния приложения.
    let store: StoreOf<CalendarFeature> = Store<CalendarFeature.State, CalendarFeature.Action>(
        initialState: CalendarFeature.State(),
        reducer: { CalendarFeature() }
    )

    /// Основное тело приложения.
    var body: some Scene {
        WindowGroup {
            /// Главный экран приложения.
            CalendarView(store: self.store)
        }
    }
}
