import ComposableArchitecture
import Foundation

struct TodoListState: Equatable {
    var todoList: [TodoItem] = [
        .init(id: 3, title: "Title 3", completed: false, userId: 42),
        .init(id: 2, title: "Title 2", completed: true, userId: 1),
        .init(id: 1, title: "Title 1", completed: false, userId: 1),
    ]
}

enum TodoListAction: Equatable {
    case addTodo
    case clearCompleted
    case updateTodo(TodoItem)
}

struct TodoListEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let todoListReducer = Reducer<
    TodoListState,
    TodoListAction,
    TodoListEnvironment
> { state, action, environment in
    switch action {
    case .addTodo:
        let id = 1 + (state.todoList.map(\.id).max() ?? 0)
        let todo = TodoItem(
            id: id,
            title: "",
            completed: false,
            userId: 42
        )

        state.todoList.insert(todo, at: 0)
        return .none

    case .clearCompleted:
        state.todoList = state.todoList.filter { !$0.completed }
        return .none

    case .updateTodo(let todo):
        if let index = state.todoList.firstIndex(where: {
            todo.id == $0.id
        }) {
            state.todoList[index] = todo
        }

        return .none
    }
}

typealias TodoListStore = Store<TodoListState, TodoListAction>

#if DEBUG

    extension TodoListStore {
        static let stubStore = TodoListStore(
            initialState: .init(),
            reducer: todoListReducer,
            environment: .init(mainQueue: .main.eraseToAnyScheduler())
        )
    }

#endif
