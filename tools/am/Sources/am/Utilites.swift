import ShellOut
import RegexBuilder
import Foundation

func getUser() -> User? {
    do {
        let output = try shellOut(
            to: "security",
            arguments: ["find-generic-password", "-w", "-s", "JIRA_SCRIPTS", "-a", "mihai.cristescu@adoreme.com"])
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

func fetchIssues(user: User, numbers: [String]) async -> [Issue] {
    return await withTaskGroup(of: Issue?.self) { group in
        var issues = [Issue?]()
        issues.reserveCapacity(numbers.count)

        for ref in numbers {
            group.addTask {
                return await fetchIssue(user: user, number: ref)
            }
        }

        for await issue in group {
            issues.append(issue)
        }

        return issues
            .compactMap { $0 }
            .sorted(by: { $0.key < $1.key })
    }
}

func fetchIssue(user: User, number: String) async -> Issue? {
    guard
        let output = try? shellOut(
            to: "curl",
            arguments: [
                "-s",
                "-u", "\(user.name):\(user.password)",
                "https://adoreme.atlassian.net/rest/api/2/issue/\(number)?fields=summary,issuetype,parent",
            ]),
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


let regex = Regex {
    OneOrMore(.any)
    "["
    Capture {
        ChoiceOf {
            "AMA"
            "PN"
            "ZONE"
        }
        "-"
        OneOrMore(.digit)
    }
    "]"
    OneOrMore(.any)
}
