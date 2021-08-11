//
//  StarRating.swift
//  BookTracker
//
//  Created by Sami Hatna on 08/07/2021.
//

import SwiftUI

struct StarRating: View {
    @Binding var starRating: Int16
    
    var body: some View {
        HStack {
            ForEach(0..<Int(self.starRating)) {_ in
                Image(systemName: "star.fill").resizable().frame(width: 30, height: 30).foregroundColor(.white)
            }
            ForEach(0..<5-Int(self.starRating)) {_ in
                Image(systemName: "star").resizable().frame(width: 30, height: 30).foregroundColor(.white)
            }
        }
    }
}

struct StarRating_Previews: PreviewProvider {
    static var previews: some View {
        StarRating(starRating: .constant(3))
    }
}
