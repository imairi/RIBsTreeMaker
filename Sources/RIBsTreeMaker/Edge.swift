//
//  Edge.swift
//  RIBsTreeMaker
//
//  Created by 今入　庸介 on 2020/02/05.
//

import Foundation

struct Edge: CustomStringConvertible {
    let left: Node
    let right: Node

    var description: String {
        return "\"\(left)\" -> \"\(right)\";"
    }
    
    var leftName: String {
        return left.name
    }
    
    var rightName: String {
        return right.name
    }
}

extension Edge: Equatable {
    static func == (left: Edge, right: Edge) -> Bool {
        return left.left == right.left && left.right == right.right
    }
}

extension Edge: Hashable {    
    func hash(into hasher: inout Hasher) {
        hasher.combine(left.hashValue ^ right.hashValue)
    }
}
