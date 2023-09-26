//
//  WhismicalFormatTreeMaker.swift
//  RIBsTreeMaker
//
//  Created by Natsuki Idota on 2023/09/19.
//

struct WhismicalFormatTreeMaker: TreeMaker {
    let edges: [Edge]
    let rootRIBName: String
    let shouldShowSummary: Bool
    let paths: [String]

    init(edges: [Edge], rootRIBName: String, shouldShowSummary: Bool, paths: [String]) {
        self.edges = edges
        self.rootRIBName = rootRIBName
        self.shouldShowSummary = shouldShowSummary
        self.paths = paths
    }

    func make() throws {
        try showRIBsTree(edges: edges, targetName: rootRIBName, count: 1)
    }
}

// MARK: - Private Methods
private extension WhismicalFormatTreeMaker {
    func showRIBsTree(edges: [Edge], targetName: String, count: Int) throws {
        var summary = ""
        var prefix = ""

        if count > 2 {
            for _ in 2..<count {
                prefix += "  "
            }
        }

        if count >= 2 {
            prefix += "- "
        }

        let viewControllablers = extractViewController(from: edges)
        let hasViewController = viewControllablers.contains(targetName)
        let noView = hasViewController ? "" : "(NoView)"
        if shouldShowSummary, let retrievedSummaryComment = try retrieveSummaryComment(targetName: targetName) {
            summary = " / \(retrievedSummaryComment)"
        }
        print(prefix + targetName + noView + summary)

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
}
