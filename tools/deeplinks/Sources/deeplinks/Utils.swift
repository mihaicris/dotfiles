import Foundation

@discardableResult
func shell(_ command: String) -> String {
   let task = Process()
   let pipe = Pipe()

   task.standardOutput = pipe
   task.standardError = pipe
   task.arguments = ["-c", command]
   task.launchPath = "/bin/zsh"
   task.launch()

   let data = pipe.fileHandleForReading.readDataToEndOfFile()
   let output = String(data: data, encoding: .utf8)!

   return output
}

func sendLink(_ url: String?) {
    guard let url = url else {
        print("Could not create the url.")
        return
    }

    shell("xcrun simctl openurl booted \"\(url)\"")
    shell("$HOME/Library/Android/sdk/platform-tools/adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d \"\(url)\"")

    print("\nResolved URL:\n\(url)\n")
}
