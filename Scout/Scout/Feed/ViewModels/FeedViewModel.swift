//
//  FeedViewModel.swift
//  Scout
//
//  Created by Codex on 4/29/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class FeedViewModel {
    enum ViewState: Equatable {
        case loading
        case loaded
        case empty
        case error(message: String)
    }

    private let feedProvider: FeedProviding
    private(set) var viewState: ViewState = .loading
    private(set) var posts: [FeedPreviewPost] = []
    private(set) var filterState = FeedFilterState()
    private var hasLoaded = false

    init(feedProvider: FeedProviding) {
        self.feedProvider = feedProvider
    }

    var visiblePosts: [FeedPreviewPost] {
        let featuredIDs = Set(innerCirclePosts.map(\.id))
        return filteredPosts.filter { !featuredIDs.contains($0.id) }
    }

    var availableCategories: [FeedPostCategory] {
        let presentCategories = Set(baseFilteredPosts.map(\.category))
        return FeedPostCategory.allCases.filter { $0 == .all || presentCategories.contains($0) }
    }

    var availableSports: [FeedSportFilter] {
        let presentSports = Set(posts.map(\.sport))
        return FeedSportFilter.allCases.filter { $0 == .all || presentSports.contains($0) }
    }

    var availableLocations: [FeedLocationFilter] {
        let sportScopedPosts = posts.filter { filterState.sport == .all || $0.sport == filterState.sport }
        let presentLocations = Set(sportScopedPosts.map(\.location))
        return FeedLocationFilter.allCases.filter { $0 == .all || presentLocations.contains($0) }
    }

    var selectedCategory: FeedPostCategory {
        filterState.category
    }

    var innerCircleProfiles: [FeedProfileSnippet] {
        FeedPreviewPost.innerCircleProfiles
    }

    var returnSignals: [FeedReturnSignal] {
        [
            FeedReturnSignal(
                id: "friends",
                eyebrow: "Inner Circle",
                value: innerCircleHeadlineValue,
                detail: innerCircleDetail
            ),
            FeedReturnSignal(
                id: "courts",
                eyebrow: "Nearby",
                value: nearbyPulseValue,
                detail: nearbyPulseDetail
            ),
            FeedReturnSignal(
                id: "momentum",
                eyebrow: "Momentum",
                value: momentumValue,
                detail: momentumDetail
            )
        ]
    }

    var innerCirclePosts: [FeedPreviewPost] {
        Array(
            filteredPosts
                .filter { $0.relationshipContext == .innerCircle }
                .sorted(by: rankPosts)
                .prefix(3)
        )
    }

    var hasInnerCircleSection: Bool {
        filterState.circle == .everyone && !innerCirclePosts.isEmpty
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true

        do {
            posts = try await feedProvider.fetchFeedPosts()
            viewState = posts.isEmpty ? .empty : .loaded
        } catch {
            viewState = .error(message: "We couldn't load your feed right now.")
        }
    }

    func selectCategory(_ category: FeedPostCategory) {
        filterState.category = category
    }

    func selectSport(_ sport: FeedSportFilter) {
        filterState.sport = sport
        if filterState.location != .all && !availableLocations.contains(filterState.location) {
            filterState.location = .all
        }
    }

    func selectLocation(_ location: FeedLocationFilter) {
        filterState.location = location
    }

    func selectCircle(_ circle: FeedCircleFilter) {
        filterState.circle = circle
    }

    private var baseFilteredPosts: [FeedPreviewPost] {
        posts.filter(matchesFilterBase(_:))
    }

    private var filteredPosts: [FeedPreviewPost] {
        baseFilteredPosts.filter(matchesCategory(_:))
    }

    private func matchesFilterBase(_ post: FeedPreviewPost) -> Bool {
        let matchesSport = filterState.sport == .all || post.sport == filterState.sport
        let matchesLocation = filterState.location == .all || post.location == filterState.location
        let matchesCircle = filterState.circle == .everyone || post.relationshipContext == .innerCircle
        return matchesSport && matchesLocation && matchesCircle
    }

    private func matchesCategory(_ post: FeedPreviewPost) -> Bool {
        filterState.category == .all || post.category == filterState.category
    }

    private func rankPosts(lhs: FeedPreviewPost, rhs: FeedPreviewPost) -> Bool {
        if lhs.returnStrength == rhs.returnStrength {
            return lhs.title < rhs.title
        }

        return lhs.returnStrength > rhs.returnStrength
    }

    private var innerCircleHeadlineValue: String {
        let uniqueProfiles = Set(innerCirclePosts.flatMap(\.relatedProfiles).map(\.name))
        return "\(uniqueProfiles.count) friends active"
    }

    private var innerCircleDetail: String {
        let names = innerCirclePosts
            .flatMap(\.relatedProfiles)
            .map(\.name)
        let uniqueNames = Array(NSOrderedSet(array: names)) as? [String] ?? []
        let leadNames = uniqueNames.prefix(2).joined(separator: " + ")
        if let topVenue = innerCirclePosts.first?.venueName, !topVenue.isEmpty {
            return "\(leadNames) are driving action around \(topVenue)."
        }

        return "\(leadNames) are generating fresh activity in your circle."
    }

    private var nearbyPulseValue: String {
        let nearbyCount = filteredPosts.filter { $0.relationshipContext == .localScene || $0.relationshipContext == .sponsored }.count
        return "\(max(nearbyCount, 1)) live signals"
    }

    private var nearbyPulseDetail: String {
        if let hotspot = filteredPosts
            .filter({ $0.relationshipContext == .localScene })
            .sorted(by: rankPosts)
            .first,
           let venueName = hotspot.venueName {
            return "\(venueName) is bubbling for \(filterState.sport.title.lowercased()) near \(filterState.location.title)."
        }

        return "\(filterState.location.title) is active for \(filterState.sport.title.lowercased()) right now."
    }

    private var momentumValue: String {
        let score = filteredPosts.map(\.returnStrength).reduce(0, +) / max(filteredPosts.count, 1)
        return "+\(max(score / 20, 2))"
    }

    private var momentumDetail: String {
        switch filterState.circle {
        case .everyone:
            let categoryCount = Set(filteredPosts.map(\.category)).count
            return "\(categoryCount) post types are surfacing with fresh local movement."
        case .innerCircle:
            let topPost = innerCirclePosts.first?.title ?? "Your circle"
            return "\(topPost) is setting the tone for your feed."
        }
    }
}
