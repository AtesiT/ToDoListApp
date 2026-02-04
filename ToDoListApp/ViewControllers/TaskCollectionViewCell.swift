import UIKit

final class TaskCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
 
    private var isDone: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //  Делаем кликабельным
        statusImageView.isUserInteractionEnabled = true
        
        //  Добавляем действие, которое происходит при нажатии на кнопку
        let tapOnCell = UITapGestureRecognizer(target: self, action: #selector(toggleStatus))
        statusImageView.addGestureRecognizer(tapOnCell)
        updateUI()
    }
    
    //  Меняем значение isDone на противоположное ему, при взаимодействии. А также обновляем интерфейс.
    @objc private func toggleStatus() {
        isDone.toggle()
        updateUI()
    }
    
    private func updateUI() {
        if isDone {
            //  Добавляем значок галочки в кружочке и присваиваем ей цвет
            statusImageView.image = UIImage(systemName: "checkmark.circle")
            statusImageView.tintColor = .systemYellow
            //  Добавляем атрибуты зачеркнутой линии, чтобы присвоить их тексту, вместе с галочкой в кружочке
            let crossTitle = NSMutableAttributedString(string: titleLabel.text ?? "")
            
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
            //  Добавляем серый кружочек
            statusImageView.image = UIImage(systemName: "circle")
            statusImageView.tintColor = .systemGray
            
            //  Присваиваем в unCrossTitle наш текст и очищаем аттрибуты
            let unCrossTitle = titleLabel.text ?? ""
            titleLabel.attributedText = nil
            titleLabel.text = unCrossTitle
            
            // Присваиваем обратно изначальный стандартный цвет текста
            titleLabel.textColor = .label
            descriptionLabel.textColor = .label
            dataLabel.textColor = .label
        }
    }
}
