//
//  Test.swift
//  BookTracker
//
//  Created by Sami Hatna on 15/07/2021.
//

import SwiftUI

struct Test: View {
    @State private var textValue = "0"
    var body: some View {
        VStack (spacing: 50) {
            Text(textValue)
                .font(.largeTitle)
                .frame(width: 200, height: 200)
                .transition(.opacity)
                .id("MyTitleComponent" + textValue)
            Button("Next") {
                withAnimation (.easeInOut(duration: 1)) {
                    self.textValue = "\(Int.random(in: 1...100))"
                }
            }
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
