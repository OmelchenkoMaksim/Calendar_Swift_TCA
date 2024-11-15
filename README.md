# CalendarTCA

**CalendarTCA** is a demo iOS application built with the **Composable Architecture** (TCA). It serves as a calendar application, allowing users to add, edit, delete, and view events. This project demonstrates the use of modern Swift development practices and a robust architectural approach for state management and UI composition.

## Features

- Display events in **Month** and **Week** views.
- Add, delete, and update events with real-time state updates.
- Asynchronous handling of event operations using **Swift Concurrency**.
- Unit tests for business logic using `XCTest`.
- UI tests for verifying user interaction flows.

---

## Architecture

The application is built using the **Composable Architecture (TCA)**, which is a unidirectional data flow pattern designed for Swift. Key components of this architecture include:

- **State**: The entire app state is centralized in a single source of truth.
- **Reducer**: Encapsulates all business logic, describing how state changes in response to user actions.
- **Actions**: Enumerations representing all possible user or system events.
- **View Composition**: Views subscribe to specific slices of state and dispatch actions to reducers.

### Advantages of TCA:
- Clear separation of concerns.
- Predictable state management.
- Ease of testing due to reduced coupling.

---

## Tech Stack

- **Swift**: Core language for development.
- **Composable Architecture (TCA)**: For state management and unidirectional data flow.
- **SwiftUI**: For building modern, declarative user interfaces.
- **XCTest**: For unit testing and UI testing.
- **Swift Concurrency**: For handling asynchronous logic efficiently using `async/await`.

---

## Project Structure

The project follows a modular approach to separate concerns and improve maintainability:

