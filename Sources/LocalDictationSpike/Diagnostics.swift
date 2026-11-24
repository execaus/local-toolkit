import AppKit
import Foundation

enum Diagnostics {
    static let url: URL = {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("LocalDictation", isDirectory: true)
        try? FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
        return base.appendingPathComponent("diagnostics.log")
    }()

    static func record(_ event: String) {
        let url = self.url
        if (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0) ?? 0 > 1_000_000 {
            try? Data().write(to: url)
        }
        let line = "\(ISO8601DateFormatter().string(from: Date())) \(event)\n"
        guard let data = line.data(using: .utf8) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            FileManager.default.createFile(atPath: url.path, contents: nil)
        }
        guard let handle = try? FileHandle(forWritingTo: url) else { return }
        defer { try? handle.close() }
        _ = try? handle.seekToEnd()
        try? handle.write(contentsOf: data)
    }

    static func recordLaunch() {
        if let previous = try? String(contentsOf: url, encoding: .utf8) {
            let lastLaunch = previous.range(of: " launch ", options: .backwards)?.lowerBound
            let lastTermination = previous.range(of: " terminate\n", options: .backwards)?.lowerBound
            if let lastLaunch, lastTermination.map({ lastLaunch > $0 }) ?? true {
                record("previous-session-ended-without-termination-marker")
            }
        }
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "development"
        record("launch version=\(version) pid=\(ProcessInfo.processInfo.processIdentifier)")
    }

    static func open() {
        NSWorkspace.shared.open(url)
    }
}
