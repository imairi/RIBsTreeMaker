//
//  TreeMaker.swift
//  RIBsTreeMaker
//
//  Created by Natsuki Idota on 2023/09/19.
//

import Foundation
import Rainbow

protocol TreeMaker {
    var paths: [String] { get }

    func make() throws
}

extension TreeMaker {
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
