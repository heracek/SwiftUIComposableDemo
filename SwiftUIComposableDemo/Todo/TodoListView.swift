import ComposableArchitecture
import SwiftUI

struct TodoListView: View {
    @State var store: Store<TodoListState, TodoListAction> = .init(
        initialState: .init(),
        reducer: todoListReducer,
        environment: .init()
    )

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewStore.todoList, id: \.id) { todo in
                        TodoListItemView(
                            todo: .init(
                                get: { todo },
                                set: { newTodo in
                                    viewStore.send(.updateTodo(newTodo))
                                }
                            )
                        )
                        Divider()
                    }
                }
            }
            .navigationBarTitle("TODO List", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    viewStore.send(.clearCompleted, animation: .easeInOut)
                }) {
                    Text("Clear")
                },
                trailing: Button(action: {
                    viewStore.send(.addTodo, animation: .easeInOut)
                }) {
                    Text("Add")
                }
            )
        }
    }
}

#if DEBUG

    struct TodoListView_Previews: PreviewProvider {
        static var previews: some View {
            TodoListView()
        }
    }

#endif
