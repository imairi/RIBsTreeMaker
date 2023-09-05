//
//  File.swift
//
//
//  Created by Natsuki Idota on 2023/09/05.
//

struct Summary: CustomStringConvertible {
    let ribName: Node
    let value: String

    var description: String {
        return "\(ribName): \(value)"
    }
}

extension Summary: Equatable {
    static func == (left: Summary, right: Summary) -> Bool {
        return left.ribName == right.ribName && left.value == right.value
    }
}

extension Summary: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ribName.hashValue ^ value.hashValue)
    }
}
