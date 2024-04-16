import ArgumentParser
import Foundation
import Rainbow
import ShellOut


struct Diff: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Provides list of JIRA issues between two GIT refs"
    )

    @Argument(help: "Git Reference 1") var ref1: String
    @Argument(help: "Git Reference 2") var ref2: String

    mutating func run() async throws {
        guard let user = getUser() else { return }
        guard let repo = getTopLevelDir() else { return }
        let refs = getIssues(repo: repo, ref1: ref1, ref2: ref2)
//        printRefs(refs)
        let issues = await fetchIssues(user: user, numbers: refs)

        guard !issues.isEmpty else {
            print("\nNo issues available.\n".red)
            return
        }
        printChangelogDescription(issues)
    }
}

private func printRefs(_ refs: [String]) {
    for ref in refs {
        print("* [\(ref)](https://adoreme.atlassian.net/browse/\(ref))")
    }
}

private func printChangelogDescription(_ issues: [Issue]) {
    func changelogIssue(_ issue: Issue) {
        let key = issue.key.lightGreen
        let summary = issue.fields.summary.lightWhite.bold
        print("* [\(key)](https://adoreme.atlassian.net/browse/\(key)) \(summary)")
    }

    print("")
    print("CHANGELOG.md".blue.bold.underline, "\n")

    for (idx, issue) in issues.added {
        if idx == 0 { print("\n#### Added") }
        changelogIssue(issue)
    }

    for (idx, issue) in issues.changed {
        if idx == 0 { print("\n#### Changed") }
        changelogIssue(issue)
    }

    for (idx, issue) in issues.defects {
        if idx == 0 { print("\n#### Fixed") }
        changelogIssue(issue)
    }

    print("")
}

private func getIssues(repo: String, ref1: String, ref2: String) -> [String] {
    guard
        let output = try? shellOut(
            to: "git",
            arguments: ["-C", repo, "log", "\(ref1)..\(ref2)", "--no-merges", "--oneline"]
        )
    else {
        return []
    }

    var issues = output.components(separatedBy: "\n")
        .compactMap { try? regex.wholeMatch(in: $0)?.output.1 }
        .map { String($0) }

    issues = Array(Set(issues)).sorted()

    return issues
}

extension Array where Element == Issue {
    var added: EnumeratedSequence<[Element]> {
        (self.filter { $0.type == .added }).enumerated()
    }

    var changed: EnumeratedSequence<[Element]> {
        (self.filter { $0.type == .changed }).enumerated()
    }

    var defects: EnumeratedSequence<[Element]> {
        (self.filter { $0.type == .defect }).enumerated()
    }
}
