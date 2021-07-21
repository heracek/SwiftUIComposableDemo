import SwiftUI

struct TodoListScreenView: View {
    var body: some View {
        TodoListView()
    }
}

#if DEBUG

    struct TodoListScreenView_Previews: PreviewProvider {
        static var previews: some View {
            TodoListScreenView()
        }
    }

#endif
