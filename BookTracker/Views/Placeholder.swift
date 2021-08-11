//
//  Placeholder.swift
//  BookTracker
//
//  Created by Sami Hatna on 15/07/2021.
//

import SwiftUI

struct Placeholder: View {
    var Message: String
    var firstColor: Color
    var secondColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous).fill(
                LinearGradient(gradient: Gradient(colors: [firstColor, secondColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
            ).frame(width: 250, height: 250)
            VStack {
                Image("PlaceholderImage").resizable().frame(width: 80, height: 98).padding(.bottom, 10)
                Text(Message).frame(width: 220).multilineTextAlignment(.center).foregroundColor(.white).font(.title2)
            }.padding()
        }
    }
}

struct Placeholder_Previews: PreviewProvider {
    static var previews: some View {
        Placeholder(Message: "Visit the 'Add Book' tab to start logging books", firstColor: Color.red, secondColor: Color.green)
    }
}
