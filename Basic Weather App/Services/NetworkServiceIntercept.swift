//
// NetworkServiceIntercept.swift
// 
// Created by Alwin Amoros on 6/12/23.
// 

import Foundation
import NetworkComponents

final class NetworkServiceIntercept: NetworkServiceInterceptor {
    private lazy var apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String
        else {
            fatalError("APIKey property was not found in the Info.plist")
        }
        return key
    }()
    func inspect(request: NetworkRequest) {
        request.queryParams?["appid"] = apiKey
    }
    
    func securityHeaders(for request: NetworkRequest, containing body: Data?) -> [String : String]? { nil }
    
    func inspect(response: NetworkResponse, for request: NetworkRequest) {
        
    }
    
    func inspect(challenge: URLAuthenticationChallenge) -> URLCredential? { nil }
    
    func validatePinning(challenge: URLAuthenticationChallenge) -> Bool { true }
    
}
