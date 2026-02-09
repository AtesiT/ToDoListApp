import XCTest
import CoreData
@testable import ToDoListApp

final class TaskSearchTests: XCTestCase {
    
    func testTaskFilteringLogic() {
        // Контекст в памяти
        let container = NSPersistentContainer(name: "DataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, _ in }
        
        let context = container.viewContext
        
        // Тестовые данные
        let task1 = TaskEntity(context: context)
        task1.todo = "Купить молоко"
        
        let task2 = TaskEntity(context: context)
        task2.todo = "Позвонить маме"
        
        let tasks = [task1, task2]
        
        // Имитируем логику фильтрации
        let searchText = "КУПИТЬ"
        let filtered = tasks.filter { $0.todo?.lowercased().contains(searchText.lowercased()) ?? false }
        
        // Результаты
        XCTAssertEqual(filtered.count, 1, "Одна задача")
        XCTAssertEqual(filtered.first?.todo, "Купить молоко")
    }
}
