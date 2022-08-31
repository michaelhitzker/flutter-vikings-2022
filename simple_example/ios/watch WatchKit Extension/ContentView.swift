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
            Text(manager.text ?? "🤔").font(.headline)
            Spacer()
            Button(action: sendSkal) {
                Text("🍻")
                    .font(.body)
            }
            Button(action: sendHello) {
                Text("👋")
                    .font(.body)
            }
        }.padding()
    }

    private func sendSkal() {
        manager.updateText("Skål!⌚️")
    }

    private func sendHello() {
        manager.updateText("Hej!⌚️")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
