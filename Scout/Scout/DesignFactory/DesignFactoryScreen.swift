import SwiftUI
import ScoutDesign

struct DesignFactoryScreen: View {
    private let categories = DesignFactoryCategory.allCases

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: ScoutLayout.Spacing.lg) {
                    header

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 156), spacing: ScoutLayout.Spacing.md)],
                        alignment: .leading,
                        spacing: ScoutLayout.Spacing.md
                    ) {
                        ForEach(categories) { category in
                            DesignFactoryCategoryCard(category: category)
                        }
                    }
                }
                .padding(.horizontal, ScoutLayout.Spacing.lg)
                .padding(.vertical, ScoutLayout.Spacing.xl)
            }
            .background(ScoutTheme.screenBackground.ignoresSafeArea())
            .navigationTitle("Design Factory")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.sm) {
                HStack(spacing: ScoutLayout.Spacing.sm) {
                    Image(systemName: "hammer.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color.scoutAccentStart)

                    Text("Internal Tooling")
                        .font(.scoutLabel)
                        .foregroundStyle(Color.scoutTextSecondary)
                }

                Text("Design Factory")
                    .font(.scoutTitle)
                    .foregroundStyle(Color.scoutTextPrimary)

                Text("Inspect ScoutDesign foundations and reusable component states before building production UI.")
                    .font(.scoutBody)
                    .foregroundStyle(Color.scoutTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct DesignFactoryCategoryCard: View {
    let category: DesignFactoryCategory

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: ScoutLayout.Spacing.sm) {
                Image(systemName: category.systemImage)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.scoutAccentStart)

                Text(category.title)
                    .font(.scoutSectionTitle)
                    .foregroundStyle(Color.scoutTextPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Gallery placeholder")
                    .font(.scoutCaption)
                    .foregroundStyle(Color.scoutTextSecondary)
            }
            .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(category.title), gallery placeholder")
    }
}

enum DesignFactoryCategory: String, CaseIterable, Identifiable {
    case tokens
    case typography
    case spacing
    case colors
    case icons
    case cards
    case pills
    case segmentedControls
    case states
    case animations

    var id: String { rawValue }

    var title: String {
        switch self {
        case .tokens:
            return "Tokens"
        case .typography:
            return "Typography"
        case .spacing:
            return "Spacing"
        case .colors:
            return "Colors"
        case .icons:
            return "Icons"
        case .cards:
            return "Cards"
        case .pills:
            return "Pills"
        case .segmentedControls:
            return "Segmented Controls"
        case .states:
            return "States"
        case .animations:
            return "Animations"
        }
    }

    var systemImage: String {
        switch self {
        case .tokens:
            return "seal.fill"
        case .typography:
            return "textformat"
        case .spacing:
            return "arrow.left.and.right"
        case .colors:
            return "paintpalette.fill"
        case .icons:
            return "square.grid.2x2.fill"
        case .cards:
            return "rectangle.stack.fill"
        case .pills:
            return "capsule.fill"
        case .segmentedControls:
            return "switch.2"
        case .states:
            return "exclamationmark.bubble.fill"
        case .animations:
            return "sparkles"
        }
    }
}

#Preview {
    DesignFactoryScreen()
}
