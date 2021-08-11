//
//  BookDetail.swift
//  BookTracker
//
//  Created by Sami Hatna on 04/07/2021.
//

import SwiftUI

struct BookDetail: View {
    @ObservedObject var book: Book
    
    @State private var showEdit = false
    
    var body: some View {
        ScrollView {
            bgImage(book.genre ?? "placeholder").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea(edges: .top)
            
            Thumbnail(bookImage: book.thumbnail, width: 130, height: 200).offset(y: -110).padding(.bottom, -110)
            
            VStack (alignment: .leading) {
                Text(book.title ?? "").font(.title)
                HStack {
                    Text(book.author ?? "")
                    Spacer()
                    Text(String(book.year))
                }.font(.subheadline).foregroundColor(.secondary)
                Divider()
                Text(book.blurb ?? "").fixedSize(horizontal: false, vertical: true).padding(.bottom, 20)
                HStack {
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [Self.gradientStartFirst, Self.gradientEndFirst]), startPoint: .topLeading, endPoint: .bottomTrailing).mask(                       RoundedRectangle(cornerRadius: 25, style: .continuous).frame(height: 100).aspectRatio(contentMode: .fill)).opacity(0.8)
                        VStack (alignment: .leading) {
                            Text("Started").font(.subheadline)
                            Text(formatDate(book.started ?? Date())).font(.title)
                            Text(formatTime(book.started ?? Date())).font(.title2)
                        }.foregroundColor(.white)
                    }
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [Self.gradientStartSecond, Self.gradientEndSecond]), startPoint: .topLeading, endPoint: .bottomTrailing).mask(                       RoundedRectangle(cornerRadius: 25, style: .continuous).frame(height: 100).aspectRatio(contentMode: .fill)).opacity(0.8)
                        VStack (alignment: .leading) {
                            Text("Finished").font(.subheadline)
                            Text(formatDate(book.finished ?? Date())).font(.title)
                            Text(formatTime(book.finished ?? Date())).font(.title2)
                        }.foregroundColor(.white)
                    }
                }.padding(.bottom, 27)
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Self.gradientStartThird, Self.gradientEndThird]), startPoint: .topLeading, endPoint: .bottomTrailing).mask(                       RoundedRectangle(cornerRadius: 25, style: .continuous).frame(height: 100).aspectRatio(contentMode: .fill)).opacity(0.8)
                    VStack (alignment: .center) {
                        Text("My Rating").font(.title3)
                        HStack {
                            ForEach(0..<5) { index in
                                if index < book.rating {
                                    Image(systemName: "star.fill").resizable().frame(width: 30, height: 30).foregroundColor(.white)
                                }
                                else {
                                    Image(systemName: "star").resizable().frame(width: 30, height: 30).foregroundColor(.white)
                                }
                            }
                        }
                    }.foregroundColor(.white)
                }.padding(.bottom, 25)
                if book.notes != "" {
                    Divider()
                    Text("Notes").font(.title3).bold()
                    Text(book.notes ?? "").fixedSize(horizontal: false, vertical: true)
                }
            }.padding()
        }
        .navigationTitle(book.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            Button("Edit") {
                self.showEdit = true
            }
        )
        .sheet(isPresented: $showEdit) {
            EditBookForm(book: book, isPresented: $showEdit).highPriorityGesture(DragGesture())
        }
    }
    static let gradientStartFirst = Color(red: 223.0 / 255, green: 27.0 / 255, blue: 27.0 / 255)
    static let gradientEndFirst = Color(red: 230.0 / 255, green: 87.0 / 255, blue: 88.0 / 255)
    static let gradientStartSecond = Color(red: 46.0 / 255, green: 184.0 / 255, blue: 44.0 / 255)
    static let gradientEndSecond = Color(red: 131.0 / 255, green: 212.0 / 255, blue: 117.0 / 255)
    static let gradientStartThird = Color(red: 7.0 / 255, green: 144.0 / 255, blue: 232.0 / 255)
    static let gradientEndThird = Color(red: 120.0 / 255, green: 197.0 / 255, blue: 239.0 / 255)
}

func bgImage(_ imageName: String) -> Image {
    if (UIImage(named: imageName.lowercased().replacingOccurrences(of: " ", with: "")) != nil) {
        return Image(imageName.lowercased().replacingOccurrences(of: " ", with: ""))
    }
    else {
        return Image("placeholder")
    }
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: date)
}

func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
}

struct BookDetail_Previews: PreviewProvider {
    static var previews: some View {
        BookDetail(book: Book())
    }
}

