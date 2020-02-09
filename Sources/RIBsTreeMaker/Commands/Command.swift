//
//  Command.swift
//  RIBsTreeMaker
//
//  Created by 今入　庸介 on 2020/02/05.
//

import Foundation

protocol Command {
    func run() -> Result
}
