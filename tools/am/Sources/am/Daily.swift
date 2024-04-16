import ArgumentParser
import Foundation
import Rainbow
import ShellOut

struct Daily: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Provides list tickets worked on for a daily stand up"
    )

    mutating func run() async throws {
        guard let user = getUser() else { return }
        guard let repo = getTopLevelDir() else { return }
        let numbers = getTickets(repo: repo)
        let issues = await fetchIssues(user: user, numbers: numbers)
        print("")
        if issues.isEmpty {
            print("No issues for this daily.".blue.bold.underline)
            print("")
            return
        }
        print("Issues for this daily:".blue.bold.underline)
        print("")
        for issue in issues {
            let key = issue.key.lightGreen
            let summary = issue.fields.summary.lightWhite.bold
            print("https://adoreme.atlassian.net/browse/\(key)  \(summary)")
        }
        print("")
    }

    var isTotaySpecialDay: Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: currentDate)
        return [1, 2, 7].contains(today)
    }

    private func getTickets(repo: String) -> [String] {
        let sinceTime = isTotaySpecialDay ? "friday 10:00" : "yesterday 10:00"
        guard
            let output = try? shellOut(
                to: "git",
                arguments: [
                    "-C",
                    repo,
                    "--no-pager",
                    "log",
                    "--all",
                    "--no-merges",
                    "--oneline",
                    "--since='\(sinceTime)'",
                    "--until='today 10:00'",
                    "--author='Mihai Cristescu'",
                ]
            )
        else {
            return []
        }
        let issues = output.components(separatedBy: "\n")
            .compactMap { try? regex.wholeMatch(in: $0)?.output.1 }
            .map { String($0) }

        return Array(Set(issues)).sorted()
    }

}
