//
//  ContentView.swift
//  DucksiCalTest
//
//  Created by Oscar Epp on 4/24/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            DucksGamesView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
