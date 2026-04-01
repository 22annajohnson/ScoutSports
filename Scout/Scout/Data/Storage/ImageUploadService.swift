
//
//  ImageUploadService.swift
//  Scout
//
//  Created by Anna on 3/2/26.
//

import Foundation
import Supabase

#if canImport(UIKit)
import UIKit
#endif

struct UploadedImage {
    let id: UUID
    let path: String
}

protocol ImageUploadProviding {
    #if canImport(UIKit)
    func uploadActionShot(image: UIImage, compressionQuality: CGFloat) async throws -> String
    func uploadHeadshot(image: UIImage, compressionQuality: CGFloat) async throws -> String
    func uploadGalleryPhoto(photoID: UUID, image: UIImage, compressionQuality: CGFloat) async throws -> UploadedImage
    #endif
}

#if canImport(UIKit)
extension ImageUploadProviding {
    func uploadActionShot(image: UIImage) async throws -> String {
        try await uploadActionShot(image: image, compressionQuality: 0.85)
    }

    func uploadHeadshot(image: UIImage) async throws -> String {
        try await uploadHeadshot(image: image, compressionQuality: 0.85)
    }

    func uploadGalleryPhoto(photoID: UUID = UUID(), image: UIImage) async throws -> UploadedImage {
        try await uploadGalleryPhoto(photoID: photoID, image: image, compressionQuality: 0.85)
    }
}
#endif

/// Handles uploading profile images to Supabase Storage.
///
/// V1 notes:
/// - Bucket is public (`profile-photos`). We store *paths* in Postgres and build public URLs when needed.
/// - Action/headshot uploads use deterministic paths and `upsert: true`.
/// - Gallery uploads use a generated photo id and `upsert: false`.
final class ImageUploadService: ImageUploadProviding {

    enum PhotoType: String {
        case action
        case headshot
        case gallery
    }

    enum UploadError: Error, LocalizedError {
        case invalidImageData
        case notAuthenticated

        var errorDescription: String? {
            switch self {
            case .invalidImageData:
                return "Invalid image data."
            case .notAuthenticated:
                return "You must be signed in to upload photos."
            }
        }
    }

    private let supabase: SupabaseClient
    private let projectURL: URL
    private let bucket: String

    init(supabase: SupabaseClient, projectURL: URL, bucket: String = "profile-photos") {
        self.supabase = supabase
        self.projectURL = projectURL
        self.bucket = bucket
    }

    private func normalizedUserFolder() throws -> String {
        let userID = try currentUserID()
        return "users/\(userID.uuidString.lowercased())"
    }

    private func currentUserID() throws -> UUID {
        guard let userID = supabase.auth.currentUser?.id else {
            throw UploadError.notAuthenticated
        }
        return userID
    }

    // MARK: - Public upload APIs (Data)

    /// Uploads/overwrites the user's action shot.
    /// - Returns: Storage object path to persist in `profile_photos.path`.
    func uploadActionShot(jpegData: Data) async throws -> String {
        let userFolder = try normalizedUserFolder()
        let path = "\(userFolder)/action.jpg"
        try await upload(
            path: path,
            data: jpegData,
            contentType: "image/jpeg",
            upsert: true
        )
        return path
    }

    /// Uploads/overwrites the user's headshot.
    /// - Returns: Storage object path to persist in `profile_photos.path`.
    func uploadHeadshot(jpegData: Data) async throws -> String {
        let userFolder = try normalizedUserFolder()
        let path = "\(userFolder)/headshot.jpg"
        try await upload(
            path: path,
            data: jpegData,
            contentType: "image/jpeg",
            upsert: true
        )
        return path
    }

    /// Uploads a new gallery photo.
    /// - Returns: id + path you can insert into `profile_photos`.
    func uploadGalleryPhoto(photoID: UUID = UUID(), jpegData: Data) async throws -> UploadedImage {
        let userFolder = try normalizedUserFolder()
        let normalizedPhotoID = photoID.uuidString.lowercased()
        let path = "\(userFolder)/gallery/\(normalizedPhotoID).jpg"
        try await upload(
            path: path,
            data: jpegData,
            contentType: "image/jpeg",
            upsert: false
        )
        return UploadedImage(id: photoID, path: path)
    }

    // MARK: - Convenience APIs (UIImage)

    #if canImport(UIKit)
    /// Convenience: converts UIImage to JPEG data and uploads as action shot.
    func uploadActionShot(image: UIImage, compressionQuality: CGFloat = 0.85) async throws -> String {
        guard let data = image.jpegData(compressionQuality: compressionQuality) else {
            throw UploadError.invalidImageData
        }
        return try await uploadActionShot(jpegData: data)
    }

    /// Convenience: converts UIImage to JPEG data and uploads as headshot.
    func uploadHeadshot(image: UIImage, compressionQuality: CGFloat = 0.85) async throws -> String {
        guard let data = image.jpegData(compressionQuality: compressionQuality) else {
            throw UploadError.invalidImageData
        }
        return try await uploadHeadshot(jpegData: data)
    }

    /// Convenience: converts UIImage to JPEG data and uploads as gallery photo.
    func uploadGalleryPhoto(photoID: UUID = UUID(), image: UIImage, compressionQuality: CGFloat = 0.85) async throws -> UploadedImage {
        guard let data = image.jpegData(compressionQuality: compressionQuality) else {
            throw UploadError.invalidImageData
        }
        return try await uploadGalleryPhoto(photoID: photoID, jpegData: data)
    }
    #endif

    // MARK: - URL helpers

    /// Builds a public URL for a stored object path in the configured bucket.
    /// Use this for image loading since the bucket is public.
    func publicURL(forPath path: String) -> URL {
        // Prefer SDK helper when available.
        // supabase-swift has historically exposed either `getPublicURL(path:)` or `publicURL(path:)`.
        // If this fails to compile due to SDK differences, keep the fallback builder below.
        #if swift(>=5.9)
        if let url = try? supabase.storage.from(bucket).getPublicURL(path: path) {
            return url
        }
        #endif

        // Fallback: https://<project>.supabase.co/storage/v1/object/public/<bucket>/<path>
        return projectURL
            .appendingPathComponent("storage/v1/object/public")
            .appendingPathComponent(bucket)
            .appendingPathComponent(path)
    }

    // MARK: - Internals

    private func upload(path: String, data: Data, contentType: String, upsert: Bool) async throws {
        let options = FileOptions(
            cacheControl: "3600",
            contentType: contentType,
            upsert: upsert
        )

        // SDK call (supabase-swift)
        _ = try await supabase
            .storage
            .from(bucket)
            .upload(
                path,
                data: data,
                options: options
            )
    }
}
