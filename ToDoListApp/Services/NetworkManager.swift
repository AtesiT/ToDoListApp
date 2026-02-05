import Foundation
import CoreData

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    //  Самая базовая функция для "забирания" данных из интернета
    func fetchData(from url: URL, completion: @escaping (Result<ToDoList, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                print(error ?? "No error")
                return
            }
            do {
                let jsonData = try JSONDecoder().decode(ToDoList.self, from: data)
                completion(.success(jsonData))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }.resume()
    }
}
