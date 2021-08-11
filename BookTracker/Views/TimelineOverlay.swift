//
//  TimelineOverlay.swift
//  BookTracker
//
//  Created by Sami Hatna on 14/07/2021.
//

import SwiftUI

struct TimelineOverlay: View {
    @Binding var title: String
    var started: Date
    var finished: Date
    var image: Data?
    
    var formatter: DateFormatter {
        let temp = DateFormatter()
        temp.dateFormat = "dd/MM/yyyy"
        return temp
    }
    
    var body: some View {
        VStack (alignment: .center) {
            Thumbnail(bookImage: image, width: 80, height: 123)
            Text(title).font(.title).padding(.top, 10).padding(.bottom, 5)
            Text("Started: " + formatter.string(from: started)).foregroundColor(.secondary)
            Text("Finished: " + formatter.string(from: finished)).foregroundColor(.secondary)
        }.padding(25).background(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(Color.white)).shadow(radius: 10)
    }
}

struct TimelineOverlay_Previews: PreviewProvider {
    static var previews: some View {
        TimelineOverlay(title: .constant("Pog"), started: Date(timeIntervalSince1970: 1000), finished: Date(timeIntervalSince1970: 2000), image: nil)
    }
}
