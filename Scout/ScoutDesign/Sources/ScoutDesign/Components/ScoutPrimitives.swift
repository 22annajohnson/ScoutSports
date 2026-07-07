import SwiftUI

public typealias ScoutCard = GlassCard
public typealias ScoutBadge = GlassChip
public typealias ScoutGlassPanel = GlassCard
public typealias ScoutSectionHeader = ScoutPageHeader

public enum ScoutButtonVariant {
    case primary
    case secondary
}

public struct ScoutButton<Label: View>: View {
    private let variant: ScoutButtonVariant
    private let action: () -> Void
    private let label: Label

    public init(
        variant: ScoutButtonVariant = .primary,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.variant = variant
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button(action: action) {
            label
        }
        .buttonStyle(buttonStyle)
    }

    private var buttonStyle: some ButtonStyle {
        switch variant {
        case .primary:
            return AnyButtonStyle(ScoutPrimaryButtonStyle())
        case .secondary:
            return AnyButtonStyle(ScoutSecondaryGlassButtonStyle())
        }
    }
}

public struct ScoutIconButton: View {
    private let systemImage: String
    private let accessibilityLabel: String
    private let action: () -> Void

    public init(
        systemImage: String,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.scoutTextPrimary)
                .frame(width: 42, height: 42)
                .background(Color.scoutGlassFill.opacity(0.82), in: Circle())
                .background(.ultraThinMaterial, in: Circle())
                .overlay(
                    Circle()
                        .stroke(Color.scoutGlassStroke, lineWidth: ScoutLayout.Stroke.hairline)
                )
        }
        .accessibilityLabel(accessibilityLabel)
        .buttonStyle(ScoutIconButtonStyle())
    }
}

public struct ScoutAvatar: View {
    private let image: Image?
    private let initials: String
    private let size: CGFloat

    public init(image: Image? = nil, initials: String, size: CGFloat = 44) {
        self.image = image
        self.initials = initials
        self.size = size
    }

    public var body: some View {
        ZStack {
            Circle()
                .fill(ScoutTheme.accentGradient)

            if let image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Text(initials)
                    .font(.scoutCallout)
                    .foregroundStyle(Color.scoutTextOnAccent)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.scoutOnImageStroke, lineWidth: ScoutLayout.Stroke.hairline)
        )
        .shadow(color: Color.scoutShadowSoft, radius: 10, y: 5)
    }
}

public struct ScoutStatPill: View {
    private let title: String
    private let value: String
    private let systemImage: String?

    public init(title: String, value: String, systemImage: String? = nil) {
        self.title = title
        self.value = value
        self.systemImage = systemImage
    }

    public var body: some View {
        HStack(spacing: ScoutLayout.Spacing.xs) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .bold))
            }

            Text(title.uppercased())
                .font(.scoutMicro)
                .foregroundStyle(Color.scoutTextSecondary)

            Text(value)
                .font(.scoutPill)
                .foregroundStyle(Color.scoutTextPrimary)
        }
        .padding(.horizontal, ScoutLayout.Spacing.md)
        .padding(.vertical, ScoutLayout.Spacing.sm)
        .background(Color.scoutGlassFill.opacity(0.9), in: Capsule())
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(
            Capsule()
                .stroke(Color.scoutGlassStroke, lineWidth: ScoutLayout.Stroke.hairline)
        )
    }
}

public struct ScoutGradientSurface<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .background(ScoutTheme.screenBackground.ignoresSafeArea())
    }
}

private struct ScoutIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scoutInteractiveScale(isPressed: configuration.isPressed, pressedScale: 0.96)
            .brightness(configuration.isPressed ? -0.03 : 0)
            .animation(ScoutMotion.press, value: configuration.isPressed)
    }
}

private struct AnyButtonStyle: ButtonStyle {
    private let makeBody: (Configuration) -> AnyView

    init<Style: ButtonStyle>(_ style: Style) {
        self.makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        makeBody(configuration)
    }
}
