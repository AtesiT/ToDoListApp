import UIKit

private let reuseIdentifier = "taskCell"

private let taskListArray = TemporaryData.allCases

final class TasksCollectionVC: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Cell

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        taskListArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        guard let cell = cell as? TaskCollectionViewCell else { return UICollectionViewCell() }
        cell.label.text = taskListArray[indexPath.row].title
        return cell
    }
}

extension TasksCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 50, height: 50)
    }
}
