//
//  BookRow.swift
//  BookTracker
//
//  Created by Sami Hatna on 04/07/2021.
//

import SwiftUI
import CoreData

struct BookRow: View {
    @ObservedObject var book: Book
    
    var body: some View {
        HStack {
            if book.thumbnail == nil {
                Image("NoThumbnail").resizable().frame(width: 50, height: 80)
            }
            else {
                let uiImage = UIImage(data: book.thumbnail! as Data)!
                Image(uiImage: uiImage).resizable().frame(width: 50, height: 80)
            }
            VStack(alignment: .leading) {
                Text(book.title ?? "")
                Text(book.author ?? "").font(.subheadline).foregroundColor(.secondary)
            }.padding(.horizontal, 10)
            Spacer()
        }.padding()
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(book: Book())
    }
}

