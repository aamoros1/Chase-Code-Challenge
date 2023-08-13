//
//  Chase_Code_ChallengeTests.swift
//  Chase Code ChallengeTests
//
//  Created by Alex on 5/25/23.
//

import XCTest
@testable import Basic_Weather_App

actor MockWeatherServiceConsumer: WeatherServiceConsumeable {

    func fetchCurrentWeatherWith<Model>(
        type: WeatherServiceSearch,
        _ numberOfDays: Days?)
    async -> Result<Model, WeatherServiceError> where Model : Response
    {
        try! await Task.sleep(nanoseconds: 1000000000)
        return .success(CurrentWeatherResponseModel.mockCurrentWeather as! Model)
    }

    func fetchCurrentWeatherWith<Model>(
        urlString: String)
    async -> Result<Model, WeatherServiceError> where Model : CurrentWeatherDataModeable
    {
        try! await Task.sleep(nanoseconds: 1000000000)
        return .success(CurrentWeatherResponseModel.mockCurrentWeather as! Model)
    }

    func fetchImageData(
        from iconName: String)
    async -> Data?
    {
        nil
    }
}

final class Chase_Code_ChallengeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() async throws {
        let service = MockWeatherServiceConsumer()
        let result: Result<CurrentWeatherResponseModel, WeatherServiceError> = await service.fetchCurrentWeatherWith(type: .zipcode(""), nil)
        
        switch result {
        case .success(let model):
            print(model.name)
        default:
            return
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}


