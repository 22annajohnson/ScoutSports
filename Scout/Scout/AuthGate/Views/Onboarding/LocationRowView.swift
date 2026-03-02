//
//  LocationRowView.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import SwiftUI
import CoreLocation

struct LocationStatusRow: View {
    let status: CLAuthorizationStatus

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var icon: String {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return "location.fill"
        case .denied, .restricted:
            return "location.slash.fill"
        case .notDetermined:
            return "location"
        @unknown default:
            return "location"
        }
    }

    private var color: Color {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return .green
        case .denied, .restricted:
            return .orange
        case .notDetermined:
            return .secondary
        @unknown default:
            return .secondary
        }
    }

    private var title: String {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return "Location enabled"
        case .denied:
            return "Location denied"
        case .restricted:
            return "Location restricted"
        case .notDetermined:
            return "Not enabled"
        @unknown default:
            return "Not enabled"
        }
    }

    private var subtitle: String {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return "You’ll see people nearby."
        case .denied, .restricted:
            return "Enable in Settings later to discover nearby players."
        case .notDetermined:
            return "We’ll ask for permission next."
        @unknown default:
            return "We’ll ask for permission next."
        }
    }
}
