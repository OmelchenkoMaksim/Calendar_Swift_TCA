// Models/Event.swift
import Foundation

/// Структура, представляющая событие в календаре.
struct Event: Identifiable, Equatable, Codable {
    /// Уникальный идентификатор события.
    let id: UUID
    
    /// Заголовок события.
    var title: String
    
    /// Описание события.
    var description: String
    
    /// Дата и время начала события.
    var startDate: Date
    
    /// Дата и время окончания события.
    var endDate: Date
    
    /// Категория события.
    var category: Event.Category
    
    /// Флаг, указывающий, завершено ли событие.
    var isCompleted: Bool
    
    /// Перечисление категорий события.
    enum Category: String, Codable, CaseIterable {
        /// Событие, связанное с работой.
        case work = "Work"
        
        /// Личное событие.
        case personal = "Personal"
        
        /// Важное событие.
        case important = "Important"
        
        /// Событие другой категории.
        case other = "Other"
    }
}
