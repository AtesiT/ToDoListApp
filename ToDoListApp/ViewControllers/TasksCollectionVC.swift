import UIKit
internal import CoreData

private let reuseIdentifier = "taskCell"

private let taskListArray = TemporaryData.allCases

final class TasksCollectionVC: UICollectionViewController, UISearchBarDelegate {
    
    // Будет хранить отфильтрованные задачи
    private var filteredTasks: [TaskEntity] = []
    private var tasks: [TaskEntity] = []
    private let networkManager = NetworkManager.shared
    
    //  Булевое значение того, пользователь набрал текст в search или нет
    private var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavgiationBar()
        setToolBar()
        setupSearchController()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        //  Уведомление об обновлении данных
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("DataLoaded"), object: nil)
        
        //  Загружаем данные
        fetchFromCoreData()
        fetchDataTodos()
    }
    
    @objc func reloadData() {
        fetchFromCoreData()
    }
    
    private func setupSearchController() {
        //  Инициализация поиска
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Запрос к базе данных
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            //  Вытягиваем данные
            tasks = try context.fetch(request)
            collectionView.reloadData()
        } catch {
            print("Failed to fetch data from Core Data: \(error)")
        }
    }
    
    private func fetchDataTodos() {
        networkManager.fetchData(from: URL(string: "https://dummyjson.com/todos")!)
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
        return isFiltering ? filteredTasks.count : tasks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        guard let cell = cell as? TaskCollectionViewCell else { return UICollectionViewCell() }
        let task = isFiltering ? filteredTasks[indexPath.item] : tasks[indexPath.item]
        cell.configure(with: task)
        return cell
    }
    
    private func editTask(at indexPath: IndexPath) {
        let theEditTask = isFiltering ? filteredTasks[indexPath.item] : tasks[indexPath.item]
        //  Создание экземпляра контроллера
        guard let taskVC = storyboard?.instantiateViewController(withIdentifier: "TaskVC") as? TaskVC else { return }
    
        taskVC.task = theEditTask
        //  Выполнение перехода с showSegue
        navigationController?.pushViewController(taskVC, animated: true)
    }
    
    private func shareTask(at indexPath: IndexPath) {
        //  Подготавливаем константу, в которой будет лежать наша задача
        let theTask = tasks[indexPath.item]
        let textOfTheTask = "Задача: \(theTask.todo ?? "")"
        
        //  Создание контроллера для возможно поделиться
        let activityVC = UIActivityViewController(activityItems: [textOfTheTask], applicationActivities: nil)
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func deleteTask(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let deleteTask = tasks[indexPath.item]
        
        context.delete(deleteTask)
        tasks.remove(at: indexPath.item)
        
        appDelegate.saveContext()
        
        collectionView.deleteItems(at: [indexPath])
    }
}

extension TasksCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 50, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        editTask(at: indexPath)
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

extension TasksCollectionVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        
        //  Если в поисковике есть какой-либо текст, то меняем булевое значение на положительное (обозначая, что пользователь написал что-то в поиске)
        if text.isEmpty {
            isFiltering = false
            collectionView.reloadData()
        } else {
            isFiltering = true
            
            //  Переходим в фоновый поток
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self else {return}
                
                //  Фильтруем задачи по полю названий задач (также, при наборе текста, добавляем lowercased, чтобы не было разницы при фильтрации с названием задачи с большими буквами)
                self.filteredTasks = self.tasks.filter { task in
                    return task.todo?.lowercased().contains(text.lowercased()) ?? false
                }
            }
            //  Обновляем интерфейс в main thread
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
