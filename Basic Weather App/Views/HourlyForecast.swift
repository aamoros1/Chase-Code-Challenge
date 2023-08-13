//
// HourlyForecast.swift
// 
// Created by Alwin Amoros on 7/14/23.
// 

import Foundation
import SwiftUI

struct HourlyForecast: View {
    
    private var title: Text {
        Text("HOURLYFORECAST")
    }
    var body: some View {
        NavigationView {
            LazyVStack(alignment: .leading) {
                Grid(alignment: .leading) {
                    GridRow {
                        title
                    }
                    .gridColumnAlignment(.leading)
                    .gridCellColumns(8)
                }
                
                ScrollView(.horizontal) {
                    Grid(alignment: .leading) {
                        GridRow(alignment:.lastTextBaseline) {
                            ForEach(1..<40) { number in
                                Text(number.description)
                                    .frame(width: 40, height: 40)
                                    .background(.red)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HourlyForecast_Preview: PreviewProvider {
    static var previews: some View {
        HourlyForecast()
    }
}
