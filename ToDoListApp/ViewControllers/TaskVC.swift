import UIKit
internal import CoreData

final class TaskVC: UIViewController {

    @IBOutlet var titleTask: UILabel!
    @IBOutlet var dataTask: UILabel!
    @IBOutlet var textTask: UITextView!
    
    var task: TaskEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        //  Устанавливаем необходимые данные в UI
        guard let task = task else {return}
        
        titleTask.text = task.todo
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dataTask.text = formatter.string(from: Date())
        
        textTask.text = task.taskDescription
    }
    
    func saveTaskDescription() {
        guard let task = task else {return}
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let text = textTask.text
        
        context.perform {
            task.taskDescription = text
            try? context.save()
        }
    }
    
    private func saveAllChanges() {
        guard let task = task else {return}
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        task.taskDescription = textTask.text
        
        let context = appDelegate.persistentContainer.viewContext
        context.perform {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //  Перед тем, как пользователь пожелает закрыть viewController(нажав на кнопку "Назад" или сделав Swipe, мы сохраним данные)
        super.viewWillDisappear(animated)
        guard let task = task else {return}
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        //  Передача данных
        task.todo = titleTask.text
        task.taskDescription = textTask.text
        appDelegate.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name("DataLoaded"), object: nil)
    }
}
