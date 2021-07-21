import ComposableArchitecture

struct TodoListState: Equatable {
    var todoList: [TodoItem] = [
        .init(id: 3, title: "Hello 3", completed: true, userId: 123),
        .init(id: 2, title: "Hello 2", completed: false, userId: 123),
        .init(id: 1, title: "Hello 1", completed: true, userId: 123),
    ]
}

enum TodoListAction: Equatable {
    case addTodo
    case clearCompleted
    case updateTodo(TodoItem)
}

struct TodoListEnvironment {

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
            title: "Todo \(id)",
            completed: false,
            userId: 42
        )
        state.todoList.insert(todo, at: 0)

        return .none

    case .clearCompleted:
        state.todoList = state.todoList.filter { !$0.completed }

        return Effect(value: TodoListAction.addTodo)
            .delay(for: 2, scheduler: DispatchQueue.main)
            .eraseToEffect()

    case .updateTodo(let todo):
        if let index = state.todoList.firstIndex(where: { todo.id == $0.id }) {
            state.todoList[index] = todo
        }

        return .none
    }
}.debug()
