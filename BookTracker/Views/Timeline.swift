//
//  Timeline.swift
//  BookTracker
//
//  Created by Sami Hatna on 12/07/2021.
//

import SwiftUI

// 5 pixels = 1 day

func calculateDifference(Date1: Date, Date2: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: Date1, to: Date2).day!
}

struct dateStruct {
    var label: String
    var difference: Int
}

func getMonthAndYearBetween(from start: Date, to end: Date) -> [dateStruct] {
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents(Set([.month]), from: start, to: end)

    var result: [dateStruct] = []
    let dateRangeFormatter = DateFormatter()
    dateRangeFormatter.dateFormat = "MMM\nyyyy"

    var prevDate = start
    for i in 0 ... components.month! {
        
        guard let date = calendar.date(byAdding: .month, value: i, to: start) else {
        continue
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let component = Calendar.current.dateComponents([.year, .month], from: date)
        var newMonth = component.month!
        var newYear = component.year!
        if newMonth == 12 {
            newMonth = 1
            newYear += 1
        }
        else {
            newMonth += 1
        }
        let comparison = formatter.date(from: "01/\(newMonth)/\(newYear)")!
        
        var difference = 0
        if i == 0 {
            difference = calculateDifference(Date1: start, Date2: comparison)
        }
        else if i == components.month! {
            difference = calculateDifference(Date1: prevDate, Date2: end)
        }
        else {
            difference = calculateDifference(Date1: prevDate, Date2: comparison)
        }
        prevDate = comparison
        
        let formattedDate = dateRangeFormatter.string(from: date)
        
        let temp = dateStruct(label: formattedDate, difference: difference)
        
        result.append(temp)
    }
    return result
}

struct Timeline: View {
    @State var blurAmount = 0
    
    @State var opacity = 0.0
    
    @State var showingOverlay = false
    @State var selectedTitle = ""
    @State var selectedImage: Data? = nil
    @State var selectedStart = Date()
    @State var selectedFinish = Date()

    @FetchRequest(entity: Book.entity(), sortDescriptors: [NSSortDescriptor(key: "started", ascending: true)])
    var books: FetchedResults<Book>
    
    @State private var offset = CGFloat.zero
    
    var hasTopNotch: Bool {
       return (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) > 0
    }
    
    @State private var label = []
    @State private var labelIndex = 0
    @State private var prevPos = CGFloat(0)
    
    var colorParts = [[Color(red: 46.0 / 255, green: 184.0 / 255, blue: 44.0 / 255),
                      Color(red: 131.0 / 255, green: 212.0 / 255, blue: 117.0 / 255)],
                     [Color(red: 223.0 / 255, green: 27.0 / 255, blue: 27.0 / 255),
                      Color(red: 230.0 / 255, green: 87.0 / 255, blue: 88.0 / 255)],
                     [Color(red: 7.0 / 255, green: 144.0 / 255, blue: 232.0 / 255),
                      Color(red: 120.0 / 255, green: 197.0 / 255, blue: 239.0 / 255)]]
    @State private var colorIndex = 0

    var body: some View {
        if books.count > 0 {
            ZStack {
                VStack(spacing: 0) {
                    let mostRecent = books.reduce(books[0], { $0.finished!.timeIntervalSince1970 > $1.finished!.timeIntervalSince1970 ? $0 : $1 } )
                    let earliest = books[0]
                    let label = getMonthAndYearBetween(from: earliest.started!, to: mostRecent.finished!)
                    
                    ZStack(alignment: .bottom) {
                        Rectangle().fill(Color(red: 246/255, green: 246/255, blue: 246/255))
                        Text(label[labelIndex].label).multilineTextAlignment(.center).padding(.bottom, 5)
                    }.ignoresSafeArea().frame(height: hasTopNotch ? 35:50)
                    
                        ScrollView([.vertical, .horizontal]) {
                        VStack (alignment: .leading) {
                            Divider()

                            let colorList = [[[Color]]](repeating: colorParts, count: (books.count - 1)/colorParts.count + 1).flatMap{$0}
                            
                            ForEach(Array(zip(books.indices, books)), id: \.0) { index, book in
                                let startPoint = calculateDifference(Date1: books[0].started!, Date2: book.started!) * 5
                                let length = calculateDifference(Date1: book.started!, Date2: book.finished!) * 5
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [colorList[index
                                        ][0], colorList[index][1]]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .onTapGesture {
                                        selectedTitle = book.title!
                                        selectedImage = book.thumbnail
                                        selectedStart = book.started!
                                        selectedFinish = book.finished!
                                        if blurAmount == 0 {
                                            withAnimation {
                                                opacity += 1
                                            }
                                            blurAmount = 20
                                        }
                                        else {
                                            withAnimation(.linear(duration: 0.1)) {
                                                opacity -= 1
                                            }
                                            blurAmount = 0
                                        }
                                    }
                                    .frame(width: CGFloat(length), height: 25)
                                    .padding(.leading, CGFloat(startPoint))
                                    .padding(.top, 10)
                                    .padding(.bottom, 10)
                                
                                Divider()
                            }
                            Spacer()
                        }.padding().padding(.trailing, 100).background(GeometryReader {
                            Color.clear.preference(key: ViewOffsetKey.self,
                                                value: -$0.frame(in: .named("scroll")).origin.x)
                        })
                        .onPreferenceChange(ViewOffsetKey.self) {
                            var direction = "right"
                            if $0 > prevPos {
                                direction = "right"
                            }
                            else {
                                direction = "left"
                            }
                            prevPos = $0
                            var total = 0
                            if direction == "right" {
                                if labelIndex > 0 {
                                    for n in 1...labelIndex {
                                        total += (label[n].difference * 5)
                                    }
                                }
                                if $0 > CGFloat(total) {
                                    if labelIndex + 1 < label.count {
                                        labelIndex += 1
                                    }
                                }
                            }
                            else {
                                if labelIndex > 0 {
                                    for n in 0...labelIndex-1 {
                                        total += (label[n].difference * 5)
                                    }
                                    if $0 < CGFloat(total) {
                                        if labelIndex - 1 >= 0 {
                                            labelIndex -= 1
                                        }
                                    }
                                }
                            }
                        }
                        }
                    .onTapGesture {
                        if opacity == 1 {
                            withAnimation(.linear(duration: 0.1)) {
                                opacity -= 1
                            }
                        }
                        blurAmount = 0
                    }
                    .coordinateSpace(name: "scroll")
                }.blur(radius: CGFloat(blurAmount))
                TimelineOverlay(title: $selectedTitle, started: selectedStart, finished: selectedFinish, image: selectedImage).opacity(opacity)
            }
        }
        else {
                Placeholder(Message: "Start adding books to see your timeline", firstColor: Color(red: 223.0 / 255, green: 27.0 / 255, blue: 27.0 / 255), secondColor: Color(red: 230.0 / 255, green: 87.0 / 255, blue: 88.0 / 255))
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct Timeline_Previews: PreviewProvider {
    static var previews: some View {
        Timeline()
    }
}
