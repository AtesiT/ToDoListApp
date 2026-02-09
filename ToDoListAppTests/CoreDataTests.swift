import XCTest
import CoreData
@testable import ToDoListApp

final class CoreDataTests: XCTestCase {
    var mockContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
    
        mockContainer = NSPersistentContainer(name: "DataModel")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        mockContainer.persistentStoreDescriptions = [description]
        
        mockContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Ошибка загрузки Core Data в тестах: \(error)")
            }
        }
    }
    
    override func tearDown() {
        mockContainer = nil
        super.tearDown()
    }

    func testTaskCreation() {
        let context = mockContainer.viewContext
        
        let newTask = TaskEntity(context: context)
        newTask.todo = "Unit Test Task"
        newTask.taskDescription = "Testing description"
        newTask.completed = false
        
        XCTAssertNotNil(newTask)
        XCTAssertEqual(newTask.todo, "Unit Test Task")
        
        do {
            try context.save()
        } catch {
            XCTFail("Сохранение не удалось: \(error)")
        }
        
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            XCTAssertEqual(result.count, 1, "Должна быть ровно 1 задача в базе")
            XCTAssertEqual(result.first?.todo, "Unit Test Task")
        } catch {
            XCTFail("Fetch не удался: \(error)")
        }
    }
}
