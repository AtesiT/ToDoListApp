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
