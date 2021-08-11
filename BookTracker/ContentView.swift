//
//  ContentView.swift
//  BookTracker
//
//  Created by Sami Hatna on 03/07/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var selectedTab = 1
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Book.entity(), sortDescriptors: [])

    var books: FetchedResults<Book>
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BookList().tabItem {
                Image(systemName: "book.fill")
                Text("My Books")
            }.tag(1)
            AddBookForm().tabItem {
                Image(systemName: "plus.circle.fill")
                Text("Add Book")
            }.tag(2)
            Milestones().tabItem {
                Image(systemName: "rosette")
                Text("Milestones")
            }.tag(3)
            Timeline().tabItem {
                Image(systemName: "calendar")
                Text("Timeline")
            }.tag(4)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
