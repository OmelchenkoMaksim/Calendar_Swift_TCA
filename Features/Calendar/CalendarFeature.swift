// Features/Calendar/CalendarFeature.swift
import Foundation
import ComposableArchitecture

/// Клиент для работы с событиями.
struct EventClient {
    /// Загрузка списка событий.
    var load: () async throws -> [Event]
    
    /// Сохранение нового события.
    var save: (Event) async throws -> Void
    
    /// Обновление существующего события.
    var update: (Event) async throws -> Void
    
    /// Удаление события по идентификатору.
    var delete: (UUID) async throws -> Void
}

extension EventClient: DependencyKey {
    /// Живое значение для клиента событий.
    static var liveValue: EventClient = EventClient(
        load: { return [] },
        save: { event in return },
        update: { event in return },
        delete: { id in return }
    )
}

extension DependencyValues {
    /// Свойство для доступа к клиенту событий.
    var eventClient: EventClient {
        get { return self[EventClient.self] }
        set { self[EventClient.self] = newValue }
    }
}

/// Фича для работы с календарём.
struct CalendarFeature: Reducer {
    /// Состояние фичи календаря.
    struct State: Equatable {
        /// Выбранная дата.
        var selectedDate: Date = Date()
        
        /// Список событий.
        var events: IdentifiedArrayOf<Event> = IdentifiedArrayOf<Event>()
        
        /// Текущий режим просмотра.
        var viewMode: ViewMode = ViewMode.month
        
        /// Флаг, указывающий, находится ли пользователь в режиме добавления события.
        var isAddingEvent: Bool = false
        
        /// Режимы отображения календаря.
        enum ViewMode: String, CaseIterable {
            /// Отображение в режиме месяца.
            case month = "Month"
            
            /// Отображение в режиме недели.
            case week = "Week"
        }
    }
    
    /// Действия, доступные в фиче календаря.
    enum Action: Equatable {
        /// Действие выбора даты.
        case selectDate(Date)
        
        /// Изменение режима просмотра.
        case changeViewMode(State.ViewMode)
        
        /// Нажатие на кнопку добавления события.
        case addEventTapped
        
        /// Добавление нового события.
        case addEvent(Event)
        
        /// Удаление события по идентификатору.
        case deleteEvent(UUID)
        
        /// Обновление существующего события.
        case updateEvent(Event)
        
        /// Загрузка списка событий.
        case loadEvents
        
        /// События успешно загружены.
        case eventsLoaded([Event])
    }
    
    /// Зависимости фичи календаря.
    @Dependency(\DependencyValues.date) var dateDependency: DateGenerator
    @Dependency(\DependencyValues.eventClient) var eventClientDependency: EventClient
    
    /// Основная логика обработки действий.
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectDate(selectedDate):
                state.selectedDate = selectedDate
                return .none
                
            case let .changeViewMode(newViewMode):
                state.viewMode = newViewMode
                return .none
                
            case .addEventTapped:
                state.isAddingEvent = true
                return .none
                
            case let .addEvent(newEvent):
                state.events.append(newEvent)
                return .run { send in
                    try await self.eventClientDependency.save(newEvent)
                }
                
            case let .deleteEvent(eventID):
                state.events.remove(id: eventID)
                return .run { send in
                    try await self.eventClientDependency.delete(eventID)
                }
                
            case let .updateEvent(updatedEvent):
                state.events[id: updatedEvent.id] = updatedEvent
                return .run { send in
                    try await self.eventClientDependency.update(updatedEvent)
                }
                
            case .loadEvents:
                return .run { send in
                    let loadedEvents: [Event] = try await self.eventClientDependency.load()
                    await send(CalendarFeature.Action.eventsLoaded(loadedEvents))
                }
                
            case let .eventsLoaded(loadedEvents):
                state.events = IdentifiedArrayOf<Event>(uniqueElements: loadedEvents)
                return .none
            }
        }
    }
}
