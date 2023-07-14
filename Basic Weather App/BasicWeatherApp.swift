//
//  Chase_Code_ChallengeApp.swift
//  Chase Code Challenge
//
//  Created by Alex on 5/25/23.
//

import SwiftUI

@main
struct BasicWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            CurrentForecastView()
                .onAppear {
                    /// Handle permissions for current location 
                    LocationServices.shared.requestLocationAuthorization()
                }
        }
    }
}
