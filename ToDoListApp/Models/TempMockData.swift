import Foundation

enum TemporaryData: CaseIterable {
    case FirstCell
    case SecondCell
    case ThirdCell
    
    var title: String {
        switch self {
        case .FirstCell: return "First Cell"
        case .SecondCell: return "Second Cell"
        case .ThirdCell: return "Third Cell"
        }
    }
}

struct ToDoList: Decodable {
    let todos: [Todos]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Todos: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
