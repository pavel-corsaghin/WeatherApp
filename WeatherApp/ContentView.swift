//
//  ContentView.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView(viewModel: HomeViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
