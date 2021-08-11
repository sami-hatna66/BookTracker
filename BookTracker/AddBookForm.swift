//
//  AddBookForm.swift
//  BookTracker
//
//  Created by Sami Hatna on 03/07/2021.
//

import SwiftUI
import Combine
import CoreData
import UIKit

struct AddBookForm: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var showAlertPositive = false
    @State var showAlertNegative = false
    
    @State var showThumbnailTick = false
    
    @State var title = ""
    @State var author = ""
    @State var genre = ""
    @State var blurb = ""
    @State var rating = 1
    @State var notes = ""
    @State var year = ""
    @State var started = Date()
    @State var finished = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
    
    @State private var index = 0
    @State private var genreList = ["Action", "Architecture", "Art", "Autobiography", "Biography", "Classic", "Comic", "Coming of Age", "Cookbook", "Crafts", "Crime", "Drama", "Economics", "Education", "Encyclopedia", "Fairytale", "Fantasy", "Fitness", "Gardening", "History", "Horror", "Kids", "Math", "Mystery", "Philosophy", "Play", "Poetry", "Politics", "Religion", "Romance", "Satire", "Science", "Science Fiction", "Thriller", "Travel", "Western", "Young Adult"]
    
    @State private var showPhotoLibrary = false
    @State private var image = UIImage()

    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    Group {
                        TextField("Title", text: $title)
                        TextField("Author", text: $author)
                        CustomPicker(genres: $genreList, selectedGenreIndex: $index, isEdit: false, inputGenre: "")
                        
                        TextField("Year", text: $year)
                            .keyboardType(.numberPad)
                            .onReceive(Just(year)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.year = filtered
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
                        }
                    }
                    
                    Section(header: Text("Blurb")) {
                        TextEditor(text: $blurb).frame(height: 200)
                    }
                    
                    HStack {
                        Text("Rating:").foregroundColor(.secondary).opacity(0.5)
                        Stepper("\(rating)", value: $rating, in: 1...5)
                    }
                    
                    Section(header: Text("Notes")) {
                        TextEditor(text: $notes).frame(height: 200)
                    }
                    
                    HStack {
                        Text("Started").foregroundColor(.secondary).opacity(0.5)
                        DatePicker("", selection: $started)
                    }
                    
                    HStack {
                        Text("Finished").foregroundColor(.secondary).opacity(0.5)
                        DatePicker("", selection: $finished)
                    }
                    
                    Section {
                        Button(action: {
                            guard self.title != "", self.author != "", self.blurb != "", self.year != "", self.finished > self.started else {
                                self.showAlertNegative = true
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                                    self.showAlertNegative = false
                                }
                                return
                            }
                            let newBook = Book(context: viewContext)
                            newBook.title = self.title
                            newBook.author = self.author
                            newBook.genre = genreList[index]
                            newBook.year = Int32(self.year)!
                            newBook.blurb = self.blurb
                            newBook.rating = Int16(self.rating)
                            newBook.notes = self.notes
                            newBook.started = self.started
                            newBook.finished = self.finished
                            newBook.thumbnail = image.pngData()
                            newBook.id = UUID()
                            do {
                                try viewContext.save()
                                self.title = ""
                                self.author = ""
                                self.genre = ""
                                self.blurb = ""
                                self.rating = 1
                                self.notes = ""
                                self.year = ""
                                self.showAlertPositive = true
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                                    self.showAlertPositive = false
                                }
                                self.showThumbnailTick = false
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                }.navigationTitle("Add Book")
            }
            .sheet(isPresented: $showPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image).onDisappear {
                    if image.pngData() != nil {
                        self.showThumbnailTick = true
                    }
                }
            }
            Notification(imageName: "plus.circle", text: "Your new book has \nbeen logged").opacity(showAlertPositive ? 1 : 0)
            Notification(imageName: "xmark.octagon", text: "There was an error\nlogging this book").opacity(showAlertNegative ? 1 : 0)
        }
    }
}

struct AddBookForm_Previews: PreviewProvider {
    static var previews: some View {
        AddBookForm()
    }
}
