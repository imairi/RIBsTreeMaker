//
//  PlantUMLFormatTreeMaker.swift
//  RIBsTreeMaker
//
//  Created by Natsuki Idota on 2023/09/19.
//

struct PlantUMLFormatTreeMaker: TreeMaker {
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
        showHeader()
        showMindmapStyle()
        try showRIBsTree(edges: edges, targetName: rootRIBName, count: 1)
        showFooter()
    }
}

// MARK: - Private Methods
private extension PlantUMLFormatTreeMaker {
    func showRIBsTree(edges: [Edge], targetName: String, count: Int) throws {
        var summary = ""
        var indent = ""

        for _ in 0..<count {
            indent += "*"
        }

        let viewControllablers = extractViewController(from: edges)
        let hasViewController = viewControllablers.contains(targetName)
        let suffix = hasViewController ? "<<hasView>>" : ""
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
          BackgroundColor translate
          LineColor #d20b52
          FontColor #d20b52
          LineThickness 2.0

          node {
            BackgroundColor #fff
            RoundCorner 30
          }

          arrow {
            LineColor #192f60
          }

          .hasView {
            LineColor #192f60
            FontColor #192f60
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
}
