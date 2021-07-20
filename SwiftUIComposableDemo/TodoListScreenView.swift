import ComposableArchitecture
import SwiftUI

struct TodoListScreenView: View {

    @State var store = RemoteTodoListStore(
        initialState: .init(),
        reducer: remoteTodoListReducer,
        environment: .init(
            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
            todoListClient: .live
        )
    )

    var body: some View {
        WithViewStore(store) { viewStore in
            IfLetStore(
                self.store.scope(
                    state: \.todoListState,
                    action: { RemoteTodoListAction.todoListAction($0) }
                )
            ) { todoListStore in
                TodoListView(store: todoListStore)
            } else: {
                switch viewStore.todoListResult {
                case .none:
                    Text("Loading...")
                case .failure:
                    Text("Error loading TODO list")
                default:
                    EmptyView()
                }
            }
            .onAppear {
                viewStore.send(.fetchTodoList)
            }
        }
        .navigationBarTitle("TODO List", displayMode: .inline)
    }
}

#if DEBUG

    struct TodoListScreenView_Previews: PreviewProvider {
        static var previews: some View {
            TodoListScreenView()
        }
    }

#endif
