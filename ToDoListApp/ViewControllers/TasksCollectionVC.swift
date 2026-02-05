import UIKit

private let reuseIdentifier = "taskCell"

private let taskListArray = TemporaryData.allCases

private let networkManager = NetworkManager.shared

final class TasksCollectionVC: UICollectionViewController, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavgiationBar()
        setToolBar()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setNavgiationBar() {
        let searchController = UISearchController(searchResultsController: nil)
        let searchBar = searchController.searchBar
        
        searchBar.placeholder = "Search"
        //  Добавляем значок закладки, после чего заменяем на микрофон
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: .normal)
        
        //  Для обрабатывания нажатия
        searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setToolBar() {
        //  Делаем toolbar видимым
        navigationController?.isToolbarHidden = false
        
        //  Добавляем свободное пространство для toolbar
        let freeSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        //  Добавление подсчета количества задач
        let countLabel = UIBarButtonItem(
            title: "\(taskListArray.count) задач",
            style: .plain,
            target: nil,
            action: nil
        )
        
        //  Делаем так, чтобы это не было как кнопка
        countLabel.isEnabled = false
        
        //  Добавление создание кнопки
        let createButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(createNewTask)
        )
        
        toolbarItems = [freeSpace, countLabel, freeSpace, createButton]
    }
    
    @objc private func createNewTask() {
        print("Test")
    }
    
    // MARK: Cell

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        taskListArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        guard let cell = cell as? TaskCollectionViewCell else { return UICollectionViewCell() }
        cell.titleLabel.text = taskListArray[indexPath.row].title
        return cell
    }
    
    private func editTask(at indexPath: IndexPath) {
        
    }
    
    private func shareTask(at indexPath: IndexPath) {
        
    }
    
    private func deleteTask(at indexPath: IndexPath) {
        
    }
}

extension TasksCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 50, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = taskListArray[indexPath.item]
        
        switch userAction {
        case .FirstCell: return
        case .SecondCell: return
        case .ThirdCell: return
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let indexPath = indexPaths.first else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
                self?.editTask(at: indexPath)
            }
            
            let share = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                self?.shareTask(at: indexPath)
            }
            
            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.deleteTask(at: indexPath)
            }
            return UIMenu(title: "", children: [edit, share, delete])
        }
    }
    
}
