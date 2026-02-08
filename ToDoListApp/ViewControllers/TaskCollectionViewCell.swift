import UIKit

final class TaskCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
 
    private var task: TaskEntity?
    private var isDone: Bool = false
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //  Делаем кликабельным
        statusImageView.isUserInteractionEnabled = true
        
        //  Добавляем действие, которое происходит при нажатии на кнопку
        let tapOnCell = UITapGestureRecognizer(target: self, action: #selector(toggleStatus))
        statusImageView.addGestureRecognizer(tapOnCell)
    }
    
    override func prepareForReuse() {
        //  Подготовка к переиспользованию ячейки
        super.prepareForReuse()
        titleLabel.attributedText = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        dataLabel.text = nil
        statusImageView.image = nil
    }
    
    func configure(with task: TaskEntity) {
        self.task = task
        self.isDone = task.completed
        
        //  Присвоение информации в labels в ячейках
        titleLabel.attributedText = nil
        titleLabel.text = task.todo
        descriptionLabel.text = (task.taskDescription?.isEmpty ?? true) ? "" : task.taskDescription
        
        dataLabel.text = formatDate(Date())
        updateUI()
    }
    
    private func formatDate(_ date: Date) -> String {
        //  Установка даты
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    //  Меняем значение isDone на противоположное ему, при взаимодействии и обновляем интерфейс.
    //  Также, присваиваем элементу интерфейса значок сделанной\не сделанной задачи, после чего обновляем данные.
    @objc private func toggleStatus() {
        isDone.toggle()
        task?.completed = isDone
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.saveContext()
        }
        updateUI()
    }
    
    private func updateUI() {
        //  Сброс настроек ячейки
        titleLabel.textColor = .label
        descriptionLabel.textColor = .label
        dataLabel.textColor = .secondaryLabel
        //  Добавляем пустой серый кружочек
        statusImageView.image = UIImage(systemName: "circle")
        statusImageView.tintColor = .systemGray
        
        if isDone {
            //  Добавляем значок галочки в кружочке и присваиваем ей цвет
            statusImageView.image = UIImage(systemName: "checkmark.circle")
            statusImageView.tintColor = .systemYellow
            //  Добавляем атрибуты зачеркнутой линии, чтобы присвоить их тексту, вместе с галочкой в кружочке
            let text = titleLabel.text ?? ""
            let crossTitle = NSMutableAttributedString(string: text)
            
            //  Зачеркнутый аттрибут
            crossTitle.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSMakeRange(0, crossTitle.length)
            )
            
            //  Добавляем цвет серый через аттрибуты, т.к. если присвоить напрямую, то вместе с зачеркиванием может не получится серый цвет в некоторых версиях iOS
            crossTitle.addAttribute(
                .foregroundColor,
                value: UIColor.systemGray,
                range: NSMakeRange(0, crossTitle.length)
            )
            
            //  Присваиваем аттрибут
            titleLabel.attributedText = crossTitle
            descriptionLabel.textColor = .systemGray
            dataLabel.textColor = .systemGray
            
        } else {
            // Присваиваем обратно изначальный стандартный цвет текста
            titleLabel.attributedText = nil
            titleLabel.text = task?.todo
        }
    }
}
