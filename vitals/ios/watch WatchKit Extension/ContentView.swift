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
            HStack {
                counter(value: manager.beerAmount, emoji: "🍻")
                counter(value: manager.coffeeAmount, emoji: "☕️")
            }
            Spacer()
            Button(action: sendSkal) {
                Text("🍻")
                    .font(.body)
            }
            Button(action: sendCoffee) {
                Text("☕️")
                    .font(.body)
            }
        }.padding()
    }
    
    private func counter(value: Int?, emoji: String) -> some View {
        return VStack {
            if let value = value {
                Text("\(value)").font(.headline).frame(width: 30, height: 30, alignment: .center)
            } else {
                ProgressView().frame(width: 30, height: 30, alignment: .center)
            }
            Text(emoji).font(.headline)
        }
    }

    private func sendSkal() {
        manager.increaseBeer()
    }

    private func sendCoffee() {
        manager.increaseCoffee()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
