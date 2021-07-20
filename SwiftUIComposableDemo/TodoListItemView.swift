import SwiftUI

struct TodoListItemView: View {
    @Binding var todo: TodoItem

    var body: some View {
        HStack(alignment: .top) {
            Button(action: {
                withAnimation(.easeInOut) {
                    todo.completed = !todo.completed
                }
            }) {
                Image(
                    systemName: todo.completed ? "checkmark.square" : "square"
                )
                .padding(4)
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading) {
                TextField(
                    "Todo title",
                    text: .init(
                        get: { todo.title },
                        set: { todo.title = $0 }
                    )
                )
                .font(.headline)
                .disabled(todo.completed)

                if !todo.completed {
                    Text(verbatim: "User: \(todo.userId)")
                        .font(.subheadline)
                        .opacity(1)
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.gray.opacity(todo.completed ? 0.3 : 0))
        .opacity(todo.completed ? 0.5 : 1)
        .animation(.easeInOut, value: todo.completed)
    }
}

#if DEBUG

    struct TodoListItemView_Previews: PreviewProvider {

        static var previews: some View {
            Group {
                TodoListItemView(
                    todo: .constant(.stubCompleted)
                )

                TodoListItemView(
                    todo: .constant(.stubNotCompleted)
                )
            }
            .previewLayout(.sizeThatFits)
        }
    }

#endif
