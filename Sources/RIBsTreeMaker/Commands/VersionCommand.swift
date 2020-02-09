//
//  VersionCommand.swift
//  RIBsTreeMaker
//
//  Created by 今入　庸介 on 2020/02/05.
//

import Foundation

struct VersionCommand: Command {
    let version: String

    func run() -> Result {
        return .success(message: version)
    }
}

