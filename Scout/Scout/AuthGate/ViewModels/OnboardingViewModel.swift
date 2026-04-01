//
//  OnboardingViewModel.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import CoreLocation
import Foundation
import Observation
import PhotosUI
import SwiftUI


@MainActor
@Observable
final class OnboardingViewModel {

    // MARK: Models

    struct Form: Equatable {
        var name: String = ""
        var ageText: String = ""
        var selectedSport: Sport? = .pickleball

        var trimmedName: String {
            name.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        var age: Int {
            Int(ageText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        }
    }

    struct AlertItem: Identifiable, Equatable {
        let id = UUID()
        let title: String
        let message: String

        static func missing(_ message: String) -> AlertItem {
            AlertItem(title: "Missing info", message: message)
        }

        static func invalid(_ title: String, _ message: String) -> AlertItem {
            AlertItem(title: title, message: message)
        }
    }

    // MARK: Enums

    enum Step: CaseIterable, Hashable {
        case nameAge
        case location
        case sport
        case photos

        var index: Int {
            switch self {
            case .nameAge: return 0
            case .location: return 1
            case .sport: return 2
            case .photos: return 3
            }
        }

        var next: Step? {
            switch self {
            case .nameAge: return .location
            case .location: return .sport
            case .sport: return .photos
            case .photos: return nil
            }
        }

        var previous: Step? {
            switch self {
            case .nameAge: return nil
            case .location: return .nameAge
            case .sport: return .location
            case .photos: return .sport
            }
        }
    }

    enum Sport: String, CaseIterable {
        case pickleball
        case tennis
    }

    enum ValidationError: Equatable {
        case missingName
        case invalidAge

        var alert: AlertItem {
            switch self {
            case .missingName:
                return .missing("Please enter your name.")
            case .invalidAge:
                return .invalid("Invalid age", "Please enter a valid age (13+).")
            }
        }
    }

    // MARK: Published State

    var step: Step = .nameAge
    var form: Form = .init()
    var alert: AlertItem?

    // Photos
    var photoItems: [PhotosPickerItem] = []
    private(set) var photos: [UIImage] = []

    // Location
    private(set) var location = LocationPermissionManager()
    private let profileRepository: ProfileProviding
    private let imageUploadService: ImageUploadProviding

    var isSaving: Bool = false

    init(
        profileRepository: ProfileProviding,
        imageUploadService: ImageUploadProviding
    ) {
        self.profileRepository = profileRepository
        self.imageUploadService = imageUploadService
    }

    // MARK: Derived State

    var canGoBack: Bool { step.previous != nil }

    var isLocationAuthorized: Bool {
        location.status == .authorizedAlways || location.status == .authorizedWhenInUse
    }

    var locationButtonTitle: String {
        switch location.status {
        case .notDetermined:
            return "Allow location"
        case .denied, .restricted:
            return "Location denied"
        case .authorizedAlways, .authorizedWhenInUse:
            return "Location enabled"
        @unknown default:
            return "Allow location"
        }
    }

    var canAdvance: Bool {
        switch step {
        case .nameAge:
            return validateNameAge() == nil
        case .location:
            // allow next even if not granted
            return true
        case .sport:
            return form.selectedSport != nil
        case .photos:
            return true
        }
    }

    // MARK: Navigation / Actions

    func goBack() {
        guard let prev = step.previous else { return }
        withAnimation { step = prev }
    }

    func goNext() {
        if step == .nameAge {
            if let error = validateNameAge() {
                alert = error.alert
                return
            }
        }

        guard let next = step.next else { return }
        withAnimation { step = next }
    }

    func skipLocation() {
        withAnimation { step = .sport }
    }

    func finish() async -> Bool {
        if let error = validateNameAge() {
            alert = error.alert
            return false
        }

        guard let selectedSport = form.selectedSport else {
            alert = .missing("Please choose a sport.")
            return false
        }

        isSaving = true
        defer { isSaving = false }

        do {
            try await profileRepository.updateCurrentUserProfile(
                ProfileUpdateInput(
                    displayName: form.trimmedName,
                    birthdate: birthdate(forAge: form.age),
                    primarySport: selectedSport.rawValue
                )
            )

            try await persistSelectedPhotos()
            return true
        } catch {
            alert = .invalid("Save Failed", error.localizedDescription)
            return false
        }
    }

    func requestLocation() {
        location.requestWhenInUse()
    }

    func selectSport(_ sport: Sport) {
        form.selectedSport = sport
    }

    func handlePhotoItemsChanged(_ newItems: [PhotosPickerItem]) async {
        await loadSelectedPhotos(newItems)
    }

    // MARK: Validation

    private func validateNameAge() -> ValidationError? {
        if form.trimmedName.isEmpty { return .missingName }
        if form.age < 13 { return .invalidAge }
        return nil
    }

    private func birthdate(forAge age: Int) -> Date? {
        guard age >= 13 else { return nil }
        return Calendar(identifier: .gregorian).date(byAdding: .year, value: -age, to: Date())
    }

    // MARK: Photos

    private func loadSelectedPhotos(_ items: [PhotosPickerItem]) async {
        var loaded: [UIImage] = []
        loaded.reserveCapacity(items.count)

        for item in items {
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    loaded.append(image)
                }
            } catch {
                // ignore individual failures
            }
        }

        photos = loaded
    }

    private func persistSelectedPhotos() async throws {
        guard !photos.isEmpty else { return }

        let actionPath = try await imageUploadService.uploadActionShot(image: photos[0])
        try await profileRepository.setCurrentUserSinglePhoto(type: .action, path: actionPath, blurhash: nil)

        if photos.count > 1 {
            let headshotPath = try await imageUploadService.uploadHeadshot(image: photos[1])
            try await profileRepository.setCurrentUserSinglePhoto(type: .headshot, path: headshotPath, blurhash: nil)
        }

        if photos.count > 2 {
            for (index, image) in photos.dropFirst(2).enumerated() {
                let uploaded = try await imageUploadService.uploadGalleryPhoto(image: image)
                try await profileRepository.addCurrentUserGalleryPhoto(
                    id: uploaded.id,
                    path: uploaded.path,
                    position: Int16(index),
                    isPrimary: false,
                    blurhash: nil
                )
            }
        }
    }
}
