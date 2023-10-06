//
//  FormatType.swift
//  RIBsTreeMaker
//
//  Created by Natsuki Idota on 2023/09/12.
//

enum FormatType {
    case plantUML
    case markdown

    init(value: String?) {
        switch value {
        case "plantUML":
            self = .plantUML
        case "markdown":
            self = .markdown
        default:
            self = .plantUML
        }
    }
}
