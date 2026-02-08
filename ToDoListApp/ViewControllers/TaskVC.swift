import UIKit
internal import CoreData

final class TaskVC: UIViewController {

    //  Замена label на textField
    @IBOutlet var titleTask: UITextField!
    @IBOutlet var dataTask: UILabel!
    @IBOutlet var textTask: UITextView!
    
    var task: TaskEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTask.borderStyle = .none
        titleTask.delegate = self
        setupUI()
    }
    
    private func setupUI() {
        guard let task = task else {return}
        
        //  Присвоение данных
        titleTask.text = task.todo
        textTask.text = task.taskDescription
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dataTask.text = formatter.string(from: Date())
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
        saveTask()
    }
    
    private func saveTask() {
        guard let task = task else {return}
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        //  Привоение пустых полей изначально
        let context = appDelegate.persistentContainer.viewContext
        let title = titleTask.text ?? ""
        let description = textTask.text ?? ""
        
        //  Если поле задачи и описание пустое, то удаляем только что созданную задачу
        if title.isEmpty && description.isEmpty {
            context.delete(task)
        } else {
            task.todo = title
            task.taskDescription = description
        }
        appDelegate.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name("DataLoaded"), object: nil)
    }
}

extension TaskVC: UITextFieldDelegate {
    //  Скрытие клавиатуры при нажатии на Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
