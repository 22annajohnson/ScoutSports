//
//  SwipeCardIdentitySection.swift
//  Scout
//
//  Created by Codex on 4/21/26.
//

import SwiftUI

struct SwipeCardIdentitySection: View {
    let name: String
    let age: Int?
    let summaryLines: [String]
    let intent: String
    let score: Int

    var body: some View {
        GlassCard(padding: ScoutSpacing.xl) {
            VStack(alignment: .leading, spacing: ScoutSpacing.xl) {
                header
                summary
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var header: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: ScoutSpacing.lg) {
                identityCopy

                Spacer(minLength: ScoutSpacing.md)

                scoreCapsule
            }

            VStack(alignment: .leading, spacing: ScoutSpacing.lg) {
                identityCopy
                scoreCapsule
            }
        }
    }

    private var identityCopy: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.lg) {
            intentChip

            HStack(alignment: .firstTextBaseline, spacing: ScoutSpacing.sm) {
                Text(name)
                    .font(.scoutDisplayCompact)
                    .foregroundStyle(Color.scoutTextPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                if let age {
                    Text("\(age)")
                        .font(.scoutNumberL)
                        .foregroundStyle(Color.scoutTextSecondary)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var intentChip: some View {
        HStack(spacing: ScoutSpacing.sm) {
            Circle()
                .fill(Color.scoutAccentEnd)
                .frame(width: 9, height: 9)

            Text(intent)
                .font(.scoutCallout)
                .foregroundStyle(Color.scoutAccentEnd)
                .lineLimit(1)
                .minimumScaleFactor(0.84)
        }
        .padding(.horizontal, ScoutSpacing.lg)
        .padding(.vertical, ScoutSpacing.sm)
        .background(
            Capsule()
                .fill(Color.scoutAccentEnd.opacity(0.13))
                .background(.ultraThinMaterial, in: Capsule())
        )
        .overlay(
            Capsule()
                .stroke(Color.scoutAccentEnd.opacity(0.28), lineWidth: ScoutStroke.hairline)
        )
    }

    private var scoreCapsule: some View {
        VStack(spacing: ScoutSpacing.xs) {
            Text("OVERALL")
                .font(.scoutMicro)
                .tracking(5)
                .foregroundStyle(Color.scoutTextSecondary)
                .lineLimit(1)

            Text("\(score)")
                .font(.scoutNumberL)
                .foregroundStyle(Color.scoutTextPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
        }
        .frame(width: 132)
        .frame(minHeight: 104)
        .background(
            RoundedRectangle(cornerRadius: ScoutRadius.xl, style: .continuous)
                .fill(Color.scoutSurfaceElevated.opacity(0.74))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: ScoutRadius.xl, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: ScoutRadius.xl, style: .continuous)
                .stroke(Color.scoutGlassStroke, lineWidth: ScoutStroke.hairline)
        )
    }

    private var summary: some View {
        VStack(alignment: .leading, spacing: ScoutSpacing.md) {
            ForEach(Array(summaryLines.prefix(3).enumerated()), id: \.offset) { _, line in
                Text(line)
                    .font(.scoutTitleCompact)
                    .foregroundStyle(Color.scoutTextPrimary.opacity(0.86))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Swipe Card Identity") {
    ZStack {
        PlayerBackgroundView(imageURL: randomMockCardViewModel().heroImageURL, color: .scoutAccentStart)
            .ignoresSafeArea()

        SwipeCardIdentitySection(
            name: "Sophie",
            age: 27,
            summaryLines: [
                "Aggressive at the net.",
                "Loves fast doubles.",
                "Usually free Tue/Thu nights."
            ],
            intent: "Looking for competitive games",
            score: 88
        )
        .padding()
    }
}
