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
    let command = makeCommand(arguments: [String](CommandLine.arguments.dropFirst()))
    let result = command.run()

    switch result {
    case let .success(message):
        print(message)
        exit(0)
    case let .failure(error):
        print(error.message)
        exit(Int32(error.code))
    }
}

func makeCommand(arguments: [String]) -> Command {
    guard let firstArgument = arguments.first else {
        let currentPath = Path.current.absolute().description
        let paths = allSwiftSourcePaths(directoryPath: currentPath)
        return MainCommand(paths: paths)
    }

    switch firstArgument {
    case "--help":
        return HelpCommand()
    case "--version":
        return VersionCommand(version: version)
    default:
        let paths = allSwiftSourcePaths(directoryPath: firstArgument)
        return MainCommand(paths: paths)
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
