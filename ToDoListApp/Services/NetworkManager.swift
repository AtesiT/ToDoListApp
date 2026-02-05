import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
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
    
    func fetchDataFromYandexDisk(from url: URL) {
        let apiWithURL = "https://cloud-api.yandex.net/v1/disk/public/resources/download?public_key=\(url)"
        guard let url = URL(string: apiWithURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else { return }
            
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let downloadUrlString = jsonData["href"] as? String,
                   let downloadUrl = URL(string: downloadUrlString) {
                    NetworkManager.shared.fetchData(from: downloadUrl) { result in
                        switch result {
                        case .success(let data):
                            print(data)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
