//
//  main.swift
//  RIBsTreeMaker
//
//  Created by 今入　庸介 on 2020/02/05.
//

import Foundation
import PathKit

let version = "0.1.0"

func main() {
    let arguments = [String](CommandLine.arguments.dropFirst())
    let command = makeCommand(commandLineArguments: arguments)
    let result = command.run()

    switch result {
    case let .success(message):
        print(message)
        exit(0)
    case let .failure(error):
        print(error.message.red)
        print("\n failure.".red.applyingStyle(.bold))
        exit(Int32(error.code))
    }
}

func makeCommand(commandLineArguments: [String]) -> Command {
    guard let firstArgument = commandLineArguments.first else {
        return HelpCommand()
    }

    let optionArguments = commandLineArguments.dropFirst()

    var optionKey = ""
    var arguments = [String:String]()
    for (index, value) in optionArguments.enumerated() {
        if index % 2 == 0 {
            optionKey = value.replacingOccurrences(of: "--", with: "")
        } else {
            arguments[optionKey] = value
        }
    }

    switch firstArgument {
    case "help":
        return HelpCommand()
    case "version":
        return VersionCommand(version: version)
    default:
        let paths = allSwiftSourcePaths(directoryPath: firstArgument)
        let rootRIBName = arguments["under"] ?? "Root"
        return MainCommand(paths: paths, rootRIBName: rootRIBName)
    }
}

func allSwiftSourcePaths(directoryPath: String) -> [String] {
    let absolutePath = Path(directoryPath).absolute()

    do {
        return try absolutePath.recursiveChildren().filter({ $0.extension == "swift" }).map({ $0.string })
    } catch {
        return []
    }
}

main()
