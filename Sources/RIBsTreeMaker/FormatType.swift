//
//  FormatType.swift
//  RIBsTreeMaker
//
//  Created by Natsuki Idota on 2023/09/12.
//

enum FormatType {
    case plantUML
    case whimsical

    init(value: String?) {
        switch value {
        case "plantUML":
            self = .plantUML
        case "whimsical":
            self = .whimsical
        default:
            self = .plantUML
        }
    }
}
