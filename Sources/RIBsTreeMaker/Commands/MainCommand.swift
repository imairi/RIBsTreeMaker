//
//  MainCommand.swift
//  RIBsTreeMaker
//
//  Created by 今入　庸介 on 2020/02/05.
//

import Foundation
import SourceKittenFramework

struct MainCommand {
    private let structures: [Structure]?
    
    init(paths: [String]) {
        do {
            structures = try paths.map({ File(path: $0) }).compactMap({ $0 }).map({ try Structure(file: $0) })
        }
        catch {
            print("Cannot create structure. Check the target path.")
            structures = nil
        }
    }
}

// MARK: - Command
extension MainCommand: Command {
    func run() -> Result {
        guard let structures = structures else {
            return .failure(error: .notFoundStructure)
        }
        print("Analyze \(structures.count) swift files.")
        
        let edges = makeEdges(from: structures)
        
        showRIBsTree(edges: edges, targetName: "Confirmation", count: 1)
        
        return .success(message: "success")
    }
}

// MARK: - Private Methods
private extension MainCommand {
    func makeEdges(from structures: [Structure]) -> Set<Edge> {
        var edges = Set<Edge>()
        var leftNodes = Set<Node>()
        
        for structure in structures {
            guard let substructures = structure.dictionary["key.substructure"] as? [[String: SourceKitRepresentable]] else {
                continue
            }
            
            for substructure in substructures {
                guard let kindValue = substructure["key.kind"] as? String else {
                    continue
                }
                
                guard let kind = SwiftDeclarationKind(rawValue: kindValue) else {
                    continue
                }
                
                guard [.class, .protocol].contains(kind) else {
                    continue
                }
                
                guard let nameValue = substructure["key.name"] as? String else {
                    continue
                }
                
                let leftNode = Node(name: nameValue)
                leftNodes.insert(leftNode)
                
                if let inheritedTypes = substructure["key.inheritedtypes"] as? [[String: SourceKitRepresentable]] {
                    for inheritedType in inheritedTypes {
                        guard let inheritedTypeName = inheritedType["key.name"] as? String else {
                            continue
                        }
                        
                        let rightNode = Node(name: inheritedTypeName)
                        
                        if leftNode == rightNode {
                            continue
                        }
                        
                        
                        let edge = Edge(left: leftNode, right: rightNode)
                        edges.insert(edge)
                    }
                }
            }
        }
        return edges
    }
    
    func showRIBsTree(edges: Set<Edge>, targetName: String, count: Int) {
        var indent = ""
        for _ in 0..<count {
            indent += "*"
        }
        print(indent + " " + targetName)
        for edge in edges {
            if let interactable = extractInteractable(from: edge.leftName) {
                if interactable == targetName {
                    if let listener = extractListener(from: edge.rightName) {
                        showRIBsTree(edges: edges, targetName: listener, count: count + 1)
                    }
                }
            }
        }
    }
    
    func extractInteractable(from name: String) -> String? {
        if name.contains("Interactable") {
            return name.replacingOccurrences(of: "Interactable", with: "")
        } else {
            return nil
        }
    }
    
    func extractListener(from name: String) -> String? {
        if name.contains("Listener") {
            return name.replacingOccurrences(of: "Listener", with: "")
        } else {
            return nil
        }
    }
}
