import Foundation

public func cn(_ parts: String?...) -> String {
    parts
        .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
        .joined(separator: " ")
}

public func className(_ parts: String?...) -> String {
    cn(parts)
}

public func cn(_ parts: [String?]) -> String {
    parts
        .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
        .joined(separator: " ")
}
