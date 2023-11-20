//
//  MainCommand.swift
//  RIBsTreeMaker
//
//  Created by 今入　庸介 on 2020/02/05.
//

import Foundation
import SourceKittenFramework
import Rainbow

struct MainCommand {
    private let rootRIBName: String
    private let shouldShowSummary: Bool
    private let formatType: FormatType
    private let excludedRIBs: [String]
    private let paths: [String]

    init(paths: [String], rootRIBName: String, shouldShowSummary: Bool, formatType: FormatType, excludedRIBs: [String]) {
        print("")
        print("Analyze \(paths.count) swift files.".applyingStyle(.bold))
        print("")
        print("Make RIBs tree under \(rootRIBName) RIB.".applyingStyle(.underline))
        print("")
        self.rootRIBName = rootRIBName
        self.shouldShowSummary = shouldShowSummary
        self.formatType = formatType
        self.excludedRIBs = excludedRIBs
        self.paths = paths
    }
}

// MARK: - Command
extension MainCommand: Command {
    func run() -> Result {
        do {
            let structures = try makeStructures()
            let edges = makeEdges(from: structures).sorted()
            switch formatType {
            case .plantUML:
                let treeMaker = PlantUMLFormatTreeMaker(edges: edges, rootRIBName: rootRIBName, shouldShowSummary: shouldShowSummary, excludedRIBs: excludedRIBs, paths: paths)
                try treeMaker.make()
            case .markdown:
                let treeMaker = MarkdownFormatTreeMaker(edges: edges, rootRIBName: rootRIBName, shouldShowSummary: shouldShowSummary, excludedRIBs: excludedRIBs, paths: paths)
                try treeMaker.make()
            }
            return .success(message: "\nSuccessfully completed.".green.applyingStyle(.bold))
        }
        catch let error as Error {
            return .failure(error: error)
        }
        catch {
            return .failure(error: .unknown)
        }
    }
}

// MARK: - Private Methods
private extension MainCommand {
    func makeStructures() throws -> [Structure] {
        do {
            return try paths.map({ File(path: $0) }).compactMap({ $0 }).map({ try Structure(file: $0) })
        }
        catch {
            print("Cannot create structure. Check the target path.".red)
            throw Error.notFoundStructure
        }
    }

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
}
