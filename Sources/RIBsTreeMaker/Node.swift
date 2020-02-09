//
//  Node.swift
//  RIBsTreeMaker
//
//  Created by 今入　庸介 on 2020/02/05.
//

import Foundation

struct Node: CustomStringConvertible {
    let name: String

    var description: String {
        return name
    }
}

extension Node: Equatable {
    static func == (left: Node, right: Node) -> Bool {
        return left.name == right.name
    }
}

extension Node: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name.hashValue)
    }
}








