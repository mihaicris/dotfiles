import Foundation

struct Issue: Decodable, Sendable {
    let key: String
    var fields: Fields

    struct Fields: Decodable {
        var summary: String
        let issuetype: TypeValue?
        let parent: Parent?

        struct TypeValue: Decodable {
            let name: String
        }

        struct Parent: Decodable {
            let key: String
            let fields: ParentFields

            struct ParentFields: Decodable {
                let issuetype: TypeValue
            }
        }
    }

    enum IssueType {
        case added
        case changed
        case defect
    }

    var type: IssueType {
        if fields.issuetype?.name == "Story" { return .added }
        if fields.issuetype?.name == "Task" { return .changed }
        if fields.issuetype?.name == "Bug" { return .defect }
        if fields.issuetype?.name == "Support" { return .changed }

        if fields.issuetype?.name == "Sub-task" {
            if let issuetype = fields.parent?.fields.issuetype.name {
                if issuetype == "Story" { return .added }
                if issuetype == "Task" { return .changed }
                if issuetype == "Bug" { return .defect }
                if issuetype == "Support" { return .changed }
            }
        }

        return .added
    }
}
