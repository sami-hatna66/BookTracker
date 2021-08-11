//
//  TopGenreWidget.swift
//  BookTracker
//
//  Created by Sami Hatna on 07/07/2021.
//

import SwiftUI

struct TopGenreWidget: View {
    var topGenre: String
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Self.gradientStart, Self.gradientEnd]), startPoint: .topLeading, endPoint: .bottomTrailing).mask(                       RoundedRectangle(cornerRadius: 25, style: .continuous).frame(height: 80).aspectRatio(contentMode: .fill)).opacity(0.8)
            VStack (alignment: .center) {
                HStack {
                    Text("Your top genre is").padding(.bottom, -6)
                    Text(topGenre).bold().font(.title)
                }
            }.foregroundColor(.white)
        }
    }
    static let gradientStart = Color(red: 7.0 / 255, green: 144.0 / 255, blue: 232.0 / 255)
    static let gradientEnd = Color(red: 120.0 / 255, green: 197.0 / 255, blue: 239.0 / 255)
}

struct TopGenreWidget_Previews: PreviewProvider {
    static var previews: some View {
        TopGenreWidget(topGenre: "Politics")
    }
}
