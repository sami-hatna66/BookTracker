//
//  BookList.swift
//  BookTracker
//
//  Created by Sami Hatna on 15/07/2021.
//

import SwiftUI

struct BookList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Book.entity(), sortDescriptors: [])
    var books: FetchedResults<Book>
    
    var body: some View {
        if books.count == 0 {
            Placeholder(Message: "Visit the 'Add Book' tab to start logging books", firstColor: Color(red: 46.0 / 255, green: 184.0 / 255, blue: 44.0 / 255), secondColor: Color(red: 131.0 / 255, green: 212.0 / 255, blue: 117.0 / 255))
        }
        else {
            NavigationView {
                    List {
                        ForEach(books) { book in
                            NavigationLink(destination: BookDetail(book: book))
                            {
                                BookRow(book: book)
                            }
                        }.onDelete { indexSet in
                            for index in indexSet {
                                viewContext.delete(books[index])
                            }
                            do {
                                try viewContext.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }.navigationTitle("My Books")
            }
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        BookList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
