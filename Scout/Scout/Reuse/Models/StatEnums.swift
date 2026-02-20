//
//  StatEnums.swift
//  Scout
//
//  Created by Anna on 2/19/26.
//

enum StatType: String, Codable {
    case vibe
    case intensity
    case consistency
    case skill
}

func getStatTypeString(_ starType: StatType) -> String {
    switch starType {
    case .vibe:
        return "Vibe"
    case .intensity:
        return "Intensity"
    case .consistency:
        return "Consistency"
    case .skill:
        return "Skill Level"
    }
}
