//
//  Milestones.swift
//  BookTracker
//
//  Created by Sami Hatna on 06/07/2021.
//

import SwiftUI

func evaluatePlural(index: Int) -> String {
    if index == 0 {
        return "book"
    }
    else {
        return "books"
    }
}

struct Milestones: View {
    @FetchRequest(entity: Book.entity(), sortDescriptors: [])
    var books: FetchedResults<Book>
    
    var options = ["All Time", "This Year", "This Month"]
    @State private var selectedTimeframe = 0
    
    @State var milestones = [1, 5, 10, 25, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 6000, 7000, 8000, 9000, 10000]
    
    var filteredMilestones: [Int] {
        milestones.filter {
            ($0 < 1001 || selectedTimeframe != 2) && ($0 < 5001 || selectedTimeframe != 1)
        }
    }
    
    var topGenre: String {
        var counts = [String : Int]()
        var genres = [String]()
        if books.count > 0 {
            for n in 0...books.count - 1 {
                genres.append(books[n].genre!)
            }
            genres.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
            return counts.max(by: { $0.1 < $1.1 })!.key
        }
        else {
            return "Unknown"
        }
    }
    
    var averageRating: String {
        if books.count > 0 {
            var total = 0
            for n in 0...books.count - 1 {
                total += Int(books[n].rating)
            }
            return String(format: "%.2f", Double(total) / Double(books.count))
        }
        else {
            return "0.0"
        }
    }
    
    var result: Int {
        var counter = 0
        var filteredBookCount = 0
        let calendar = Calendar.current
        if selectedTimeframe == 1 && books.count > 0 {
            for n in 0...books.count-1 {
                let components = calendar.dateComponents([.year], from: books[n].finished!)
                if components.year == calendar.component(.year, from: Date()) {
                    filteredBookCount += 1
                }
            }
        }
        else if selectedTimeframe == 2 && books.count > 0 {
            for n in 0...books.count-1 {
                let components = calendar.dateComponents([.month, .year], from: books[n].finished!)
                if (components.year == calendar.component(.year, from: Date())) && (components.month == calendar.component(.month, from: Date())) {
                    filteredBookCount += 1
                }
            }
        }
        else {
            filteredBookCount = books.count
        }
        for n in 0...filteredBookCount {
            if n == filteredMilestones[counter] {
                counter += 1
            }
        }
        return counter
    }
    
    var average: String {
        var prevMonth = 0
        var monthTotals = [Int]()
        var cache = 0
        var first = true
        let calendar = Calendar.current
        if books.count > 0 {
            let sorted = books.sorted(by: { $0.finished!.compare($1.finished!) == .orderedAscending })
            for n in 0...sorted.count-1 {
                let components = calendar.dateComponents([.month], from: sorted[n].finished!)
                if components.month! == prevMonth {
                    cache += 1
                }
                else {
                    if first {
                        prevMonth = components.month!
                        cache += 1
                        first = false
                    }
                    else {
                        monthTotals.append(cache)
                        cache = 1
                        prevMonth = components.month!
                    }
                }
            }
            monthTotals.append(cache)
            return String(format: "%.2f", Double(monthTotals.reduce(0, +)) / Double(monthTotals.count))
        }
        else {
            return "0.0"
        }
    }
    
    var body: some View {
        if books.count > 0 {
            ScrollView {
                HStack {
                    AverageWidget(average: average).padding(.top, 10).padding(.bottom, 20).padding(.leading, 15)
                    AverageRatingWidget(averageRating: averageRating).padding(.top, 10).padding(.bottom, 20).padding(.trailing, 15)
                }.padding(.top, 10)
                TopGenreWidget(topGenre: topGenre).padding()
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(0 ..< options.count, id: \.self) {
                        Text(self.options[$0]).tag($0)
                    }
                }.pickerStyle(SegmentedPickerStyle()).padding()
                ZStack {
                    VStack {
                        ForEach(0 ..< filteredMilestones.count, id: \.self) { index in
                            ZStack {
                                HStack(alignment: .bottom) {
                                    VStack {
                                        Rectangle().frame(width: 10, height: 40).foregroundColor(Color(red: 246/255, green: 246/255, blue: 246/255))
                                        Circle().frame(width: 40, height: 40).offset(y: -10).foregroundColor(Color(red: 246/255, green: 246/255, blue: 246/255))
                                    }
                                    if index < result {
                                        HStack {
                                            Text(String(self.filteredMilestones[index])).bold().padding(.bottom, 13).padding(.leading, 15).font(.title)
                                            Text(evaluatePlural(index: index)).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).padding(.bottom, 6).font(.subheadline)
                                        }
                                    }
                                    else {
                                        HStack {
                                            Text(String(self.filteredMilestones[index])).padding(.bottom, 13).padding(.leading, 15).font(.title)
                                            Text(evaluatePlural(index: index)).frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).padding(.bottom, 6).font(.subheadline)
                                        }
                                    }
                                }
                            }.padding(.bottom, -20)
                        }.padding(.leading, 20)
                    }
                    VStack {
                        ForEach(0 ..< result, id: \.self) { book in
                            HStack {
                                VStack {
                                    Rectangle().frame(width: 10, height: 40).foregroundColor(.yellow)
                                    Circle().frame(width: 40, height: 40).offset(y: -10).foregroundColor(.yellow)
                                }.padding(.bottom, -20)
                                Spacer()
                            }.padding(.leading, 20)
                        }
                        Spacer()
                    }
                }.padding(.bottom, 25)
            }
        }
        else {
            Placeholder(Message: "Start adding books to see your milestones", firstColor: Color(red: 7.0 / 255, green: 144.0 / 255, blue: 232.0 / 255), secondColor: Color(red: 120.0 / 255, green: 197.0 / 255, blue: 239.0 / 255))
        }
    }
}

struct Milestones_Previews: PreviewProvider {
    static var previews: some View {
        Milestones().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
