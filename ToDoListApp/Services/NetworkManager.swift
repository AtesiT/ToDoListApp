import Foundation
import UIKit
internal import CoreData

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    //  Самая базовая функция для "забирания" данных из интернета
    func fetchData(from url: URL) {
        //  Выполняем в другом потоке
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data else {
                    print(error ?? "No error")
                    return
                }
                do {
                    let jsonData = try JSONDecoder().decode(ToDoList.self, from: data)
                    self?.saveInCoreData(todos: jsonData.todos)
                } catch {
                    print(error)
                }
            }.resume()
        }
    }
    
    private func saveInCoreData(todos: [Todos]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //  Делаем так, чтобы на фоновом потоке выполнялись операции
        let backgroundContext = appDelegate.persistentContainer.newBackgroundContext()
        
        backgroundContext.perform {
            todos.forEach { todoData in
                let task = TaskEntity(context: backgroundContext)
                task.id = Int64(todoData.id)
                task.todo = todoData.todo
                task.completed = todoData.completed
                task.userId = Int64(todoData.userId)
            }
            do {
                try backgroundContext.save()
                print("Проверка: \(todos.count)")
                //  Отправляем уведомление с именем "DataLoaded"
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name("DataLoaded"), object: nil)
                }
            } catch {
                print(error)
            }
        }
    }
}
