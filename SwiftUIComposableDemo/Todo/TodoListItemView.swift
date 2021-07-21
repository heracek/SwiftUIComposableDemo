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
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading) {
                Text(todo.title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("User: \(todo.userId)")
            }
        }
        .padding()
        .opacity(todo.completed ? 0.5 : 1)
        .background(
            Color.gray.opacity(
                todo.completed ? 0.3 : 0
            )
        )
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
