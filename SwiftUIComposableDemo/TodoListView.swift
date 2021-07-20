import ComposableArchitecture
import SwiftUI

struct TodoListView: View {

    var store: TodoListStore

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewStore.todoList, id: \.id) { todo in
                        TodoListItemView(
                            todo: Binding<TodoItem>(
                                get: { todo },
                                set: { viewStore.send(.updateTodo($0)) }
                            )
                        )
                        Divider()
                    }
                }
            }
            .navigationBarItems(
                leading: Button(action: {
                    viewStore.send(
                        .clearCompleted,
                        animation: .easeInOut
                    )
                }) {
                    Text("Clear")
                },
                trailing: Button(action: {
                    viewStore.send(
                        .addTodo,
                        animation: .easeInOut
                    )
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
            TodoListView(store: .stubStore)
        }
    }

#endif
