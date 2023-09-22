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
    private let paths: [String]

    init(paths: [String], rootRIBName: String, shouldShowSummary: Bool) {
        print("")
        print("Analyze \(paths.count) swift files.".applyingStyle(.bold))
        print("")
        print("Make RIBs tree under \(rootRIBName) RIB.".applyingStyle(.underline))
        print("")
        self.rootRIBName = rootRIBName
        self.shouldShowSummary = shouldShowSummary
        self.paths = paths
    }
}

// MARK: - Command
extension MainCommand: Command {
    func run() -> Result {
        do {
            let structures = try makeStructures()
            let edges = makeEdges(from: structures).sorted()
            showHeader()
            showMindmapStyle()
            try showRIBsTree(edges: edges, targetName: rootRIBName, count: 1)
            showFooter()
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

    func showRIBsTree(edges: [Edge], targetName: String, count: Int) throws {
        var summary = ""
        var indent = ""
        for _ in 0..<count {
            indent += "*"
        }
        let viewControllablers = extractViewController(from: edges)
        let hasViewController = viewControllablers.contains(targetName)
        let suffix = hasViewController ? "" : "<<noView>>"
        if shouldShowSummary, let retrievedSummaryComment = try retrieveSummaryComment(targetName: targetName) {
            summary = " / \(retrievedSummaryComment)"
        }
        print(indent + " " + targetName + summary + suffix)

        for edge in edges {
            if let interactable = extractInteractable(from: edge.leftName) {
                if interactable == targetName {
                    if let listener = extractListener(from: edge.rightName) {
                        try showRIBsTree(edges: edges, targetName: listener, count: count + 1)
                    }
                }
            }
        }
    }
    
    func showMindmapStyle() {
        let style = """
        <style>
        mindmapDiagram {
          . * {
            BackGroundColor #FFF
            LineColor #192f60
            Shadowing 0.0
            RoundCorner 20
            LineThickness 2.0
          }
          .noView * {
            BackGroundColor #FFF
            LineColor #d20b52
            TextColor #d20b52
          }
        }
        </style>
        """
        
        print(style)
    }
    
    func showHeader() {
        print("@startmindmap")
    }
    
    func showFooter() {
        print("@endmindmap")
    }

    func retrieveSummaryComment(targetName: String) throws -> String? {
        let regexPattern = "// SUMMARY: .+"
        let summaryComment = "// SUMMARY: "
        let lineSeparator = "\n"
        let suffixOfBuilderFile = "Builder.swift"
        let targetFile = "/\(targetName)\(suffixOfBuilderFile)"
        guard let builder = paths.filter({ $0.contains(targetFile) }).first else {
            return nil
        }

        do {
            let contents = try String(contentsOfFile: builder, encoding: .utf8)
            let regex = try NSRegularExpression(pattern: regexPattern)
            let results = regex.matches(in: contents, range: NSRange(0..<contents.count))
            guard let result = results.first else {
                return nil
            }
            if result.numberOfRanges == 0 {
                return nil
            }
            let start = contents.index(contents.startIndex, offsetBy: result.range(at: 0).location)
            let end = contents.index(start, offsetBy: result.range(at: 0).length)
            return String(contents[start..<end]).replacingOccurrences(of: summaryComment, with: "").replacingOccurrences(of: lineSeparator, with: "")
        }
        catch {
            print("Cannot retrieve summary comment. Check the target path or the Builder file.".red)
            throw Error.failedToRetrieveSummary
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
    
    func extractViewController(from edges: [Edge]) -> Set<String> {
        let results = edges.compactMap { edge -> String? in
            if edge.leftName.contains("ViewController") {
                return edge.leftName.replacingOccurrences(of: "ViewController", with: "")
            } else {
                return nil
            }
        }
        return Set<String>(results)
    }
}
