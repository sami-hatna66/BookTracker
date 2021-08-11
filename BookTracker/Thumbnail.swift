//
//  Thumbnail.swift
//  BookTracker
//
//  Created by Sami Hatna on 04/07/2021.
//

import SwiftUI

struct Thumbnail: View {
    var bookImage: Data?
    var width: Int
    var height: Int
    
    var body: some View {
        if bookImage == nil {
            Image("NoThumbnail").resizable().frame(width: CGFloat(width), height: CGFloat(height)).overlay(Rectangle().stroke(Color.white, lineWidth: 4)).shadow(radius: 7)
        }
        else {
            let uiImage = UIImage(data: bookImage! as Data)!
            Image(uiImage: uiImage).resizable().frame(width: CGFloat(width), height: CGFloat(height)).overlay(Rectangle().stroke(Color.white, lineWidth: 4)).shadow(radius: 7)
        }
    }
}

struct Thumbnail_Previews: PreviewProvider {
    static var previews: some View {
        Thumbnail(bookImage: nil, width: 130, height: 200)
    }
}
