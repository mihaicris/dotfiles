import ShellOut

func getUser() -> User? {
    do {
        let output = try shellOut(
            to: "security",
            arguments: ["find-generic-password", "-w", "-s", "JIRA_SCRIPTS", "-a", "delta"])
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
