//
//  HelpCommand.swift
//  RIBsTreeMaker
//
//  Created by 今入　庸介 on 2020/02/05.
//

import Foundation

struct HelpCommand: Command {
    func run() -> Result {
        let helpMessage = "USAGE: RIBsTreeMaker [analyze target path] [--under [RIB name]] [--format [plantUML or markdown (default: plantUML)]] [--summary]"
        return .success(message: helpMessage)
    }
}
