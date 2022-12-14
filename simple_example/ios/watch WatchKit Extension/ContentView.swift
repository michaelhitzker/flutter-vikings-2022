//
//  ContentView.swift
//  watch WatchKit Extension
//
//  Created by Michael Hitzker on 21.08.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var manager = WatchCommunicationManager()
    
    var body: some View {
        VStack {
            Text(manager.text ?? "ð¤").font(.headline)
            Spacer()
            Button(action: sendSkal) {
                Text("ð»")
                    .font(.body)
            }
            Button(action: sendHello) {
                Text("ð")
                    .font(.body)
            }
        }.padding()
    }

    private func sendSkal() {
        manager.updateText("SkÃ¥l!âï¸")
    }

    private func sendHello() {
        manager.updateText("Hej!âï¸")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
