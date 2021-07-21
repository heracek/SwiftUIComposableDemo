import Foundation

struct TodoItem: Equatable, Decodable {
    var id: Int
    var title: String
    var completed: Bool
    var userId: Int
}

#if DEBUG

    extension TodoItem {
        static let stubCompleted: Self = .init(
            id: 1,
            title: "Title 1",
            completed: true,
            userId: 123
        )

        static let stubNotCompleted: Self = .init(
            id: 1,
            title: "Title 2, abc, 123, Hello, World!",
            completed: false,
            userId: 42
        )
    }

#endif
