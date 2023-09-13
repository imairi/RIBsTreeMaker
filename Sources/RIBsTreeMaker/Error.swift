//
//  Error.swift
//  RIBsTreeMaker
//
//  Created by 今入　庸介 on 2020/02/05.
//

import Foundation

enum Error: Swift.Error {
    case notFoundStructure
    case failedToRetrieveSummary
    case unknown

    var message: String {
        switch self {
        case .notFoundStructure:
            return "Not found structure"
        case .failedToRetrieveSummary:
            return "Failed to retrieve summary"
        case .unknown:
            return "Unknown error"
        }
    }

    var code: Int {
        return 1
    }
}
