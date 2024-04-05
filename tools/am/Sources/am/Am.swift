import ArgumentParser

@main
struct Am: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Suite of utilities for Adore Me development",
        subcommands: [Diff.self, Daily.self],
        defaultSubcommand: Diff.self
    )
}
