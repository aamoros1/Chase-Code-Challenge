//
//  Chase_Code_ChallengeTests.swift
//  Chase Code ChallengeTests
//
//  Created by Alex on 5/25/23.
//

import XCTest
@testable import Basic_Weather_App

final class Chase_Code_ChallengeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() async throws {
        let currentDayWeather = FiveDayWeatherForeCastModel.mockData
//        print(currentDayWeather.list)
        let act = NSUserActivity(activityType: "com.basicweatherapp.www")
        print(act.activityType)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}


