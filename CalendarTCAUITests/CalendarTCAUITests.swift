//
//  CalendarTCAUITests.swift
//  CalendarTCAUITests
//
//  Created by Омельченко Максим on 15.11.2024.
//

import XCTest

final class CalendarTCAUITests: XCTestCase {

    override func setUpWithError() throws {
        // Остановка теста при ошибке.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Очистка после выполнения каждого теста.
    }

    /// Тест проверки отображения заголовка на главном экране.
    func testCalendarTitleExists() throws {
        // Запуск приложения.
        let app = XCUIApplication()
        app.launch()
        
        // Проверяем, что заголовок "Calendar" существует.
        let calendarTitle = app.navigationBars["Calendar"]
        XCTAssertTrue(calendarTitle.exists, "Заголовок 'Calendar' должен быть видимым на экране.")
    }
}
