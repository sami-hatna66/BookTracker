//
//  CustomPicker.swift
//  BookTracker
//
//  Created by Sami Hatna on 05/07/2021.
//

import SwiftUI

struct CustomPicker: View {
    @Binding var genres: [String]
    @Binding var selectedGenreIndex: Int
    @State var isEdit: Bool
    @State var inputGenre: String
    
    @State private var showingSheet = false
    
    @State private var newGenre = ""
    
    var body: some View {
        Picker(selection: $selectedGenreIndex, label: Text("Genre")){
            Button(action: {
                showingSheet = true
            }) {
                HStack {
                    Spacer()
                    Text("Add new genre")
                    Spacer()
                }
            }.buttonStyle(PlainButtonStyle()).foregroundColor(.blue)
            ForEach(0 ..< genres.count, id: \.self) {
                Text(self.genres[$0]).tag($0)
            }
        }
        .onAppear {
            if isEdit {
                if genres.contains(inputGenre) {
                    selectedGenreIndex = genres.firstIndex(of: inputGenre)!
                }
                else {
                    genres.append(inputGenre)
                    selectedGenreIndex = genres.count - 13
                }
                isEdit = false
            }
        }
        .sheet(isPresented: $showingSheet) {
            Form {
                TextField("Input new genre", text: $newGenre)
                Button(action:{
                    self.genres.insert(newGenre, at: 0)
                    newGenre = ""
                    showingSheet = false
                }) {
                    Text("Submit")
                }
            }
        }
    }
}

struct CustomPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomPicker(genres: .constant(["Yuh", "Pog"]), selectedGenreIndex: .constant(0), isEdit: false, inputGenre: "")
    }
}
