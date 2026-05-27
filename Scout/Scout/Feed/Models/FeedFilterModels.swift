//
//  FeedFilterModels.swift
//  Scout
//
//  Created by Codex on 4/30/26.
//

import Foundation

enum FeedSportFilter: String, CaseIterable, Identifiable {
    case all
    case pickleball
    case tennis
    case padel

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all:
            return "All sports"
        case .pickleball:
            return "Pickleball"
        case .tennis:
            return "Tennis"
        case .padel:
            return "Padel"
        }
    }
}

enum FeedLocationFilter: String, CaseIterable, Identifiable {
    case all
    case portland
    case eastSide
    case downtown
    case waterfront

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all:
            return "All places"
        case .portland:
            return "Portland"
        case .eastSide:
            return "East Side"
        case .downtown:
            return "Downtown"
        case .waterfront:
            return "Waterfront"
        }
    }
}

enum FeedCircleFilter: String, CaseIterable, Identifiable {
    case everyone
    case innerCircle

    var id: String { rawValue }

    var title: String {
        switch self {
        case .everyone:
            return "For You"
        case .innerCircle:
            return "Inner Circle"
        }
    }
}

enum FeedRelationshipContext: Equatable {
    case innerCircle
    case localScene
    case sponsored
}

struct FeedFilterState: Equatable {
    var circle: FeedCircleFilter = .everyone
    var sport: FeedSportFilter = .pickleball
    var location: FeedLocationFilter = .portland
    var category: FeedPostCategory = .all
}

