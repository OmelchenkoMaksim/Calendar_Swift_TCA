//
//  CalendarTCATests.swift
//  CalendarTCATests
//
//  Created by Омельченко Максим on 15.11.2024.
//

@testable import CalendarTCA
import XCTest
import ComposableArchitecture

final class CalendarTCATests: XCTestCase {
    
    override func setUpWithError() throws {
        // Настройка перед выполнением каждого теста.
    }

    override func tearDownWithError() throws {
        // Очистка после выполнения каждого теста.
    }

    /// Тест на выбор даты в CalendarFeature.
    func testSelectDate() async throws {
        let store = await TestStore(
            initialState: CalendarFeature.State(),
            reducer: { CalendarFeature() }
        )
        
        let testDate = Date()
        
        await store.send(.selectDate(testDate)) {
            $0.selectedDate = testDate
        }
    }
    
    /// Тест на изменение режима отображения.
    func testChangeViewMode() async throws {
        let store = await TestStore(
            initialState: CalendarFeature.State(),
            reducer: { CalendarFeature() }
        )
        
        await store.send(.changeViewMode(.week)) {
            $0.viewMode = .week
        }
    }
    
    /// Тест на добавление события.
    func testAddEvent() async throws {
        let store = await TestStore(
            initialState: CalendarFeature.State(),
            reducer: { CalendarFeature() }
        ) {
            $0.eventClient = EventClient(
                load: { [] },                      // Пустая реализация для загрузки
                save: { _ in },                    // Реализация для сохранения (ничего не делает)
                update: { _ in },                  // Пустая реализация для обновления
                delete: { _ in }                   // Пустая реализация для удаления
            )
        }
        
        let testEvent = Event(
            id: UUID(),
            title: "Test Event",
            description: "This is a test event",
            startDate: Date(),
            endDate: Date().addingTimeInterval(3600),
            category: .work,
            isCompleted: false
        )
        
        await store.send(.addEvent(testEvent)) {
            $0.events.append(testEvent)
        }
    }

    
    /// Тест на удаление события.
    func testDeleteEvent() async throws {
        let testEventID = UUID()
        let testEvent = Event(
            id: testEventID,
            title: "Test Event",
            description: "This is a test event",
            startDate: Date(),
            endDate: Date().addingTimeInterval(3600),
            category: .work,
            isCompleted: false
        )
        
        let store = await TestStore(
            initialState: CalendarFeature.State(events: [testEvent]),
            reducer: { CalendarFeature() }
        ) {
            $0.eventClient.delete = { id in
                XCTAssertEqual(id, testEventID)
            }
        }
        
        await store.send(.deleteEvent(testEventID)) {
            $0.events.remove(id: testEventID)
        }
    }
    
    /// Тест на загрузку событий.
    func testLoadEvents() async throws {
        let testEvents = [
            Event(
                id: UUID(),
                title: "Event 1",
                description: "First test event",
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600),
                category: .work,
                isCompleted: false
            ),
            Event(
                id: UUID(),
                title: "Event 2",
                description: "Second test event",
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600),
                category: .personal,
                isCompleted: false
            )
        ]
        
        let store = await TestStore(
            initialState: CalendarFeature.State(),
            reducer: { CalendarFeature() }
        ) {
            $0.eventClient.load = { return testEvents }
        }
        
        await store.send(.loadEvents)
        await store.receive(.eventsLoaded(testEvents)) {
            $0.events = IdentifiedArrayOf(uniqueElements: testEvents)
        }
    }
}
