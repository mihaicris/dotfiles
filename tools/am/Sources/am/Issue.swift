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
        func getType(for name: String) -> IssueType {
            switch name {
            case "Bug": return .defect
            case "Discovery": return .added
            case "Epic": return .added
            case "Idea": return .added
            case "Learning": return .added
            case "Operation": return .changed
            case "Question": return .changed
            case "Spike": return .added
            case "Story": return .added
            case "Support": return .changed
            case "Task": return .changed
            case "Test": return .added
            case "Troubleshooting": return .defect
            case "Sub-task":
                guard let parentName = fields.parent?.fields.issuetype.name else { return .added }
                return getType(for: parentName)
            default: return .added
            }
        }

        guard let issuetypeName = fields.issuetype?.name else { return .added }
        return getType(for: issuetypeName)

    }
}
