import Combine
import ComposableArchitecture

struct RemoteTodoListState: Equatable {
    var todoListResult: Result<TodoListState, TodoListClient.Error>?

    var todoListState: TodoListState? {
        get {
            switch todoListResult {
            case .success(let todoListState):
                return todoListState
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self.todoListResult = .success(newValue)
            }
        }
    }
}

enum RemoteTodoListAction {
    case fetchTodoList
    case todoListResponse(TodoListClient.TodoListResutl)
    case todoListAction(TodoListAction)
}

struct RemoteTodoListEnvironemt {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var todoListClient: TodoListClient
}

typealias RemoteTodoListReducer = Reducer<
    RemoteTodoListState,
    RemoteTodoListAction,
    RemoteTodoListEnvironemt
>

let remoteTodoListReducer: RemoteTodoListReducer = .combine(
    todoListReducer
        .optional()
        .pullback(
            state: \RemoteTodoListState.todoListState,
            action: /RemoteTodoListAction.todoListAction,
            environment: { environment in
                .init(mainQueue: environment.mainQueue)
            }
        ),
    RemoteTodoListReducer({ state, action, environment in
        switch action {
        case .fetchTodoList:
            return environment
                .todoListClient
                .fetch()
                .receive(on: environment.mainQueue)
                .map(RemoteTodoListAction.todoListResponse)
                .eraseToEffect()

        case .todoListResponse(let response):
            state.todoListResult = response.map {
                .init(todoList: $0)
            }
            return .none

        case .todoListAction:
            return .none
        }
    })
)

typealias RemoteTodoListStore = Store<RemoteTodoListState, RemoteTodoListAction>

#if DEBUG

    extension RemoteTodoListStore {
        static let stubStore = RemoteTodoListStore(
            initialState: .init(),
            reducer: remoteTodoListReducer,
            environment: RemoteTodoListEnvironemt(
                mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                todoListClient: .stub
            )
        )
    }

#endif
