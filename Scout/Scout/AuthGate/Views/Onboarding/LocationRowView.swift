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
        HStack(spacing: ScoutSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(Color.scoutSurfaceElevated)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.scoutBodyEmphasis)
                    .foregroundStyle(Color.scoutTextPrimary)
                Text(subtitle)
                    .font(.scoutCaption)
                    .foregroundStyle(Color.scoutTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(ScoutSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                .fill(Color.scoutSurfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: ScoutRadius.md, style: .continuous)
                .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
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
            return .scoutSuccess
        case .denied, .restricted:
            return .scoutWarning
        case .notDetermined:
            return .scoutTextSecondary
        @unknown default:
            return .scoutTextSecondary
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
