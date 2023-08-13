//
// Bundle+Extension.swift
// 
// Created by Alwin Amoros on 8/13/23.
// 

	

import Foundation

extension Bundle {
    static var testingBundle: Bundle {
        .init(for: type(of: Chase_Code_ChallengeTests.init()))
    }
}
