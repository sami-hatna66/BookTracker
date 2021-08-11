//
//  Notification.swift
//  BookTracker
//
//  Created by Sami Hatna on 03/07/2021.
//

import SwiftUI

struct Notification: View {
    var imageName: String
    var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous).frame(width: 250, height: 250).foregroundColor(Color(red: 246/255, green: 246/255, blue: 246/255)).opacity(0.8)
            VStack {
                Image(systemName: imageName).resizable().frame(width: 100, height: 100).foregroundColor(Color(red: 120/255, green: 120/255, blue: 120/255)).padding(.bottom, 10)
                Text(text).font(.title2).multilineTextAlignment(.center).foregroundColor(Color(red: 120/255, green: 120/255, blue: 120/255))
            }
        }
    }
}

struct Notification_Previews: PreviewProvider {
    static var previews: some View {
        Notification(imageName: "xmark.octagon", text: "There was an error\nlogging this book")
    }
}
