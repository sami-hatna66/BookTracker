//
//  AverageRatingWidget.swift
//  BookTracker
//
//  Created by Sami Hatna on 07/07/2021.
//

import SwiftUI

struct AverageRatingWidget: View {
    var averageRating: String
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Self.gradientStart, Self.gradientEnd]), startPoint: .topLeading, endPoint: .bottomTrailing).mask(                       RoundedRectangle(cornerRadius: 25, style: .continuous).frame(height: 80).aspectRatio(contentMode: .fill)).opacity(0.8)
            VStack (alignment: .center) {
                Text("Average rating:")
                HStack {
                    Text(averageRating).bold().font(.title)
                    Text("stars").padding(.bottom, -6)
                }
            }.foregroundColor(.white)
        }
    }
    static let gradientStart = Color(red: 223.0 / 255, green: 27.0 / 255, blue: 27.0 / 255)
    static let gradientEnd = Color(red: 230.0 / 255, green: 87.0 / 255, blue: 88.0 / 255)
}

struct AverageRatingWidget_Previews: PreviewProvider {
    static var previews: some View {
        AverageRatingWidget(averageRating: "2.5")
    }
}
