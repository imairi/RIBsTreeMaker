//
//  HelpCommand.swift
//  RIBsTreeMaker
//
//  Created by 今入　庸介 on 2020/02/05.
//

import Foundation

struct HelpCommand: Command {
    func run() -> Result {
        let helpMessage = """
        USAGE: RIBsTreeMaker <analyze target path> [options]

        Options:
          --under <value>      The tree will be displayed only under the RIB.
          --format <value>     Specify the output format. The format that can be specified is as follows:
                               plantUML(Default): The output is in PlantUML format.
                               markdown: The output is in Markdown list format.
          --summary            The RIB's summary is displayed in the node. The summary is retrieved `// SUMMARY: RIB summary` from the Builder file.
          --exclude <value>    The specified RIB and the RIB below it are not displayed. When specifying multiple RIB names, separate each RIB name with `,`.
        """
        return .success(message: helpMessage)
    }
}
