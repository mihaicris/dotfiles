import ArgumentParser
import Foundation
import Rainbow
import RegexBuilder
import ShellOut

@main
struct ReleaseDiff: AsyncParsableCommand {
    @Argument(help: "Git Reference 1") var ref1: String
    @Argument(help: "Git Reference 2") var ref2: String

    mutating func run() async throws {
        guard let user = getUser() else { return }
        guard let repo = getTopLevelDir() else { return }
        let refs = getIssues(repo: repo, ref1: ref1, ref2: ref2)
        let issues = await fetchIssues(user: user, refs: refs)

        printJiraDescription(issues)
        printChangelogDescription(issues)
    }
}

private func printJiraDescription(_ issues: [Issue]) {
    print("")
    print("JIRA Release".lightRed, "\n")
    print("Tickets included in this release:")

    for (idx, issue) in issues.added {
        if idx == 0 { print("\nh2. Added") }
        jiraIssue(issue)
    }

    for (idx, issue) in issues.changed {
        if idx == 0 { print("\nh2. Changed") }
        jiraIssue(issue)
    }

    for (idx, issue) in issues.defects {
        if idx == 0 { print("\nh2. Fixed") }
        jiraIssue(issue)
    }

    print("")
}

private func jiraIssue(_ issue: Issue) {
    let key = issue.key.lightGreen
    let summary = issue.fields.summary
    print("* [\(key)] \(summary)")
}


private func printChangelogDescription(_ issues: [Issue]) {
    print("")
    print("CHANGELOG.md".lightRed, "\n")
    print("## Version")

    for (idx, issue) in issues.added {
        if idx == 0 { print("\n### Added") }
        changelogIssue(issue)
    }

    for (idx, issue) in issues.changed {
        if idx == 0 { print("\n### Changed") }
        changelogIssue(issue)
    }

    for (idx, issue) in issues.defects {
        if idx == 0 { print("\n### Fixed") }
        changelogIssue(issue)
    }

    print("")
}

private func changelogIssue(_ issue: Issue) {
    let key = issue.key.lightGreen
    let summary = issue.fields.summary
    print("* [\(key)](https://jira.adoreme.com/browse/\(key)) \(summary)")
}

func fetchIssues(user: User, refs: [String]) async -> [Issue] {
    return await withTaskGroup(of: Issue?.self) { group in
        var issues = [Issue?]()
        issues.reserveCapacity(refs.count)

        for ref in refs {
            group.addTask {
                return await fetchIssue(user: user, ref: ref)
            }
        }

        var count = 1
        for await issue in group {
            issues.append(issue)

            count += 1
        }

        return issues
            .compactMap { $0 }
            .sorted(by: { $0.key < $1.key })
    }
}

func getUser() -> User? {
    do {
        let output = try shellOut(to: "security", arguments: ["find-generic-password", "-w", "-s", "JIRA_SCRIPTS", "-a", "delta"])
        return User(password: output)
    } catch {
        print(error)
        return nil
    }
}

func getTopLevelDir() -> String? {
    do {
        return try shellOut(to: "git", arguments: ["rev-parse", "--show-toplevel"])
    } catch {
        print(error)
        return nil
    }
}

func getIssues(repo: String, ref1: String, ref2: String) -> [String] {
    guard let output = try? shellOut(
        to: "git",
        arguments: ["-C", repo, "log", "\(ref1)..\(ref2)", "--no-merges", "--oneline"]
    ) else {
        return []
    }

    var issues = output.components(separatedBy: "\n")
        .compactMap { try? regex.wholeMatch(in: $0)?.output.1 }
        .map { String($0) }

    issues = Array(Set(issues)).sorted()

    return issues
}

func fetchIssue(user: User, ref: String) async -> Issue? {
    guard let output = try? shellOut(
        to: "curl",
        arguments: ["-s",
                    "-u", "\(user.name):\(user.password)",
                    "https://jira.adoreme.com/rest/api/2/issue/\(ref)?fields=summary,issuetype,parent"]),
        let data = output.data(using: .utf8)
    else { return nil }

    do {
        var issue = try JSONDecoder().decode(Issue.self, from: data)
        issue.fields.summary = String(issue.fields.summary.trimmingPrefix("[iOS] "))
        return issue
    } catch {
        return nil
    }
}

private let regex = Regex {
    OneOrMore(.any)
    "["
    Capture {
        ChoiceOf { "AMA"; "PN" }
        "-"
        OneOrMore(.digit)

    }
    "]"
    OneOrMore(.any)
}

extension Array where Element == Issue {
    var added: EnumeratedSequence<Array<Element>> {
        (self.filter { $0.type == .added}).enumerated()
    }

    var changed: EnumeratedSequence<Array<Element>> {
        (self.filter { $0.type == .changed}).enumerated()
    }

    var defects: EnumeratedSequence<Array<Element>> {
        (self.filter { $0.type == .defect}).enumerated()
    }
}