//
//  Error.swift
//  RIBsTreeMaker
//
//  Created by 今入　庸介 on 2020/02/05.
//

import Foundation

enum Error: Swift.Error {
    case unknown
    case notFoundStructure

    var message: String {
        switch self {
        case .unknown:
            return "Unknown error"
        case .notFoundStructure:
            return "Not found structure"
        }
    }

    var code: Int {
        return 1
    }
}
