import Combine
import ComposableArchitecture

struct TodoListClient {
    typealias TodoListResutl = Result<[TodoItem], TodoListClient.Error>

    var fetch: () -> Effect<TodoListResutl, Never>

    struct Error: Swift.Error, Equatable {}
}

extension TodoListClient {
    static let todoListUrl = URL(
        string: "https://jsonplaceholder.typicode.com/todos?_limit=10"
    )!

    static let live = Self(
        fetch: {
            URLSession
                .shared
                .dataTaskPublisher(for: todoListUrl)
                .map(\.data)
                .decode(type: [TodoItem].self, decoder: JSONDecoder())
                .map(Result.success)
                .replaceError(with: .failure(.init()))
                .eraseToEffect()
        })
}

#if DEBUG

    extension TodoListClient {
        static let stub = Self(
            fetch: {
                let todoList = [
                    TodoItem.stubCompleted,
                    TodoItem.stubNotCompleted,
                ]

                return Effect(value: .success(todoList))
            }
        )
    }

#endif
