//
// HumidityTileView.swift
// 
// Created by Alwin Amoros on 6/24/23.
// 

	

import SwiftUI

struct HumidityTileView: View {
    let humidity: String
    let description: String
}

extension HumidityTileView {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "humidity")
                Text("HUMIDITY")
            }
            HStack {
                Text(humidity)
                    .font(.system(size: 40))
            }
            HStack {
                Text(description)
                    .lineLimit(2)
            }
        }
        .padding()
    }
}

struct HumidityTileView_Previews: PreviewProvider {
    static var previews: some View {
        HumidityTileView(humidity: "82%", description: "The dew point is 75° right now")
            .previewLayout(.sizeThatFits)
    }
}
