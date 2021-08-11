//
//  EditBookForm.swift
//  BookTracker
//
//  Created by Sami Hatna on 08/07/2021.
//

import SwiftUI
import Combine
import CoreData
import UIKit
    
struct EditBookForm: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var book: Book
    
    @Binding var isPresented: Bool
    
    @State var showThumbnailTick = false
    
    @State var newTitle = ""
    @State var newAuthor = ""
    @State var newBlurb = ""
    @State var newNotes = ""
    @State var newYear = ""
    @State var newRating = 1
    @State var newStarted = Date()
    @State var newFinished = Date()
    
    @State private var genreList = ["Action", "Architecture", "Art", "Autobiography", "Biography", "Classic", "Comic", "Coming of Age", "Cookbook", "Crafts", "Crime", "Drama", "Economics", "Education", "Encyclopedia", "Fairytale", "Fantasy", "Fitness", "Gardening", "History", "Horror", "Kids", "Math", "Mystery", "Philosophy", "Play", "Poetry", "Politics", "Religion", "Romance", "Satire", "Science", "Science Fiction", "Thriller", "Travel", "Western", "Young Adult"]
    @State private var index = 0
    
    @State private var showPhotoLibrary = false
    @State private var image = UIImage()

    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    Group {
                        TextField("Title", text: $newTitle).onAppear {
                            self.newTitle = book.title!
                        }
                        TextField("Author", text: $newAuthor).onAppear {
                            self.newAuthor = book.author!
                        }
                        CustomPicker(genres: $genreList, selectedGenreIndex: $index, isEdit: true, inputGenre: book.genre!)

                        TextField("Year", text: $newYear)
                            .onAppear {
                                self.newYear = String(book.year)
                            }
                            .keyboardType(.numberPad)
                            .onReceive(Just(newYear)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.newYear = filtered
                            }
                        }
                    }
                    
                    Section(header: Text("Thumbnail")) {
                        HStack {
                            Button(action: {
                                self.showPhotoLibrary = true
                            }) {
                                Text("Choose File")
                            }
                            Spacer()
                            Image(systemName: "checkmark.circle.fill").foregroundColor(.green).opacity(showThumbnailTick ? 1 : 0)
                        }.onAppear {
                            self.image = UIImage(data: book.thumbnail ?? Data() as Data) ?? UIImage(named: "NoThumbnail")!
                        }
                    }
                    
                    Section(header: Text("Blurb")) {
                        TextEditor(text: $newBlurb).frame(height: 200).onAppear {
                            self.newBlurb = book.blurb!
                        }
                    }
                    
                    HStack {
                        Text("Rating:").foregroundColor(.secondary).opacity(0.5)
                        Stepper("\(newRating)", value: $newRating, in: 1...5).onAppear {
                            self.newRating = Int(book.rating)
                        }
                    }
                    
                    Section(header: Text("Notes")) {
                        TextEditor(text: $newNotes).frame(height: 200).onAppear {
                            self.newNotes = book.notes!
                        }
                    }
                    
                    HStack {
                        Text("Started").foregroundColor(.secondary).opacity(0.5)
                        DatePicker("", selection: $newStarted).onAppear {
                            self.newStarted = book.started!
                        }
                    }
                    
                    HStack {
                        Text("Finished").foregroundColor(.secondary).opacity(0.5)
                        DatePicker("", selection: $newFinished).onAppear {
                            self.newFinished = book.finished!
                        }
                    }
                    
                    Section {
                        Button(action: {
                            guard self.newTitle != "", self.newAuthor != "", self.newBlurb != "", self.newYear != "", self.newFinished > self.newStarted else {
                                return
                            }
                            book.title = self.newTitle
                            book.author = self.newAuthor
                            book.genre = genreList[index]
                            book.year = Int32(self.newYear)!
                            book.blurb = self.newBlurb
                            book.rating = Int16(self.newRating)
                            book.notes = self.newNotes
                            book.started = self.newStarted
                            book.finished = self.newFinished
                            book.thumbnail = image.pngData()
                            do {
                                try viewContext.save()
                                isPresented = false
                            }
                            catch {
                                print(error.localizedDescription)
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text("Submit").font(.title2)
                                Spacer()
                            }
                        }
                    }
                }.navigationTitle("Edit Book")
            }
            .sheet(isPresented: $showPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image).onDisappear {
                    if image.pngData() != nil {
                        self.showThumbnailTick = true
                    }
                }
            }
        }
    }
}

struct EditBookForm_Previews: PreviewProvider {
    static var previews: some View {
        EditBookForm(book: Book(), isPresented: .constant(true))
    }
}
