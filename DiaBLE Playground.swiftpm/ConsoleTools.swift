import Foundation
import Combine
import SwiftUI


#if os(macOS)


// https://github.com/milanvarady/Applite/tree/main/Applite/Utilities/Shell
//
// © Milán Várady 2023
//


/// Returned by functions that run shell commands, ``shell(_:)-51uzj`` and ``ShellOutputStream``
public struct ShellResult {
    let output: String
    let didFail: Bool
}


fileprivate let shellPath = "/bin/zsh"

/// Runs a shell commands
///
/// - Parameters:
///   - command: Command to run
///
/// - Returns: A ``ShellResult`` containing the output and exit status of command
@discardableResult
func shell(_ command: String) -> ShellResult {
    let task = Process()
    let pipe = Pipe()
    let logger = Logger()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-l", "-c", command]
    task.executableURL = URL(fileURLWithPath: shellPath)
    task.standardInput = nil

    do {
        try task.run()
    } catch {
        logger.error("Shell run error. Failed to run shell(\(command)).")
        return ShellResult(output: "", didFail: true)
    }

    task.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()

    if let output = String(data: data, encoding: .utf8) {
        return ShellResult(output: output, didFail: task.terminationStatus != 0)
    } else {
        logger.error("Shell data error. Failed to get shell(\(command)) output. Most likely due to a UTF-8 decoding failure.")
        return ShellResult(output: "Error: Invalid UTF-8 data", didFail: true)
    }
}

/// Async version of shell command
@discardableResult
func shell(_ command: String) async -> ShellResult {
    return dummyShell(command)
}

// This is needed so we can overload the shell function with an async version
fileprivate func dummyShell(_ command: String) -> ShellResult {
    return shell(command)
}


/// Streams the output of a shell command in real time
public class ShellOutputStream {
    public let outputPublisher = PassthroughSubject<String, Never>()

    private var output: String = ""
    private var task: Process?
    private var fileHandle: FileHandle?

    /// Runs shell command
    ///
    /// - Parameters:
    ///  - command: Shell command to run
    ///  - environmentVariables: (optional) Environment varables to include in the command
    ///
    /// - Returns: A ``ShellResult`` containing the output and exit status of command
    public func run(_ command: String, environmentVariables: String = "") async -> ShellResult {
        self.task = Process()
        self.task?.launchPath = "/bin/zsh"
        self.task?.arguments = ["-l", "-c", "\(!environmentVariables.isEmpty ? environmentVariables : "") script -q /dev/null \(command)"]

        let pipe = Pipe()
        self.task?.standardOutput = pipe
        self.fileHandle = pipe.fileHandleForReading

        // Read in output changes
        self.fileHandle?.readabilityHandler = { [weak self] handle in
            guard let self = self else { return }
            let data = handle.availableData

            if data.count > 0 {
                let text = String(data: data, encoding: .utf8) ?? ""

                // Send new changes
                Task { @MainActor in
                    self.outputPublisher.send(text)
                }

                self.output += text
            } else if !(self.task?.isRunning ?? false) {
                self.fileHandle?.readabilityHandler = nil
            }
        }

        self.task?.launch()

        self.task?.waitUntilExit()

        return ShellResult(output: self.output, didFail: self.task?.terminationStatus ?? -1 != 0)
    }
}


#endif  // os(macOS)
