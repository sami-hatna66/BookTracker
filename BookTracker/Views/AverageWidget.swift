//
//  AverageWidget.swift
//  BookTracker
//
//  Created by Sami Hatna on 07/07/2021.
//

import SwiftUI

struct AverageWidget: View {
    var average: String
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Self.gradientStart, Self.gradientEnd]), startPoint: .topLeading, endPoint: .bottomTrailing).mask(RoundedRectangle(cornerRadius: 25, style: .continuous).frame(height: 80).aspectRatio(contentMode: .fill)).opacity(0.8)
            VStack (alignment: .center) {
                Text("Monthly average:")
                HStack {
                    Text(average).bold().font(.title)
                    Text("books").padding(.bottom, -6)
                }
            }.foregroundColor(.white)
        }
    }
    static let gradientStart = Color(red: 46.0 / 255, green: 184.0 / 255, blue: 44.0 / 255)
    static let gradientEnd = Color(red: 131.0 / 255, green: 212.0 / 255, blue: 117.0 / 255)
}

struct AverageWidget_Previews: PreviewProvider {
    static var previews: some View {
        AverageWidget(average: "5.0")
    }
}
