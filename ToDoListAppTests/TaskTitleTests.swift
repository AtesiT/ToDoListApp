import XCTest
@testable import ToDoListApp

final class TaskLogicTests: XCTestCase {
    
    func testTaskWordDeclension() {
        let tasksCollectionViewController = TasksCollectionVC()
        
        XCTAssertEqual(tasksCollectionViewController.getCorrectRemainderOfTaskWord(1), "задача")
        XCTAssertEqual(tasksCollectionViewController.getCorrectRemainderOfTaskWord(2), "задачи")
        XCTAssertEqual(tasksCollectionViewController.getCorrectRemainderOfTaskWord(5), "задач")
        XCTAssertEqual(tasksCollectionViewController.getCorrectRemainderOfTaskWord(11), "задач")
        XCTAssertEqual(tasksCollectionViewController.getCorrectRemainderOfTaskWord(21), "задача")
    }
}
