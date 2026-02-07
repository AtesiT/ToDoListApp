import UIKit

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
        titleTask.text = "\(task.id)"
        dataTask.text = "\(task.completed)"
        textTask.text = "\(task.todo ?? "")"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //  Перед тем, как пользователь пожелает закрыть viewController(нажав на кнопку "Назад" или сделав Swipe, мы сохраним данные)
        super.viewWillDisappear(true)
        guard let task = task, let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        task.todo = textTask.text
        appDelegate.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name("DataLoaded"), object: nil)
    }
}
