import SwiftUI

/// Design system colors for Onyx Terminal
public enum AppColors {
    // MARK: - Primary Colors
    public static let primary = Color.blue
    public static let secondary = Color.gray
    public static let accent = Color.orange
    
    // MARK: - Terminal Colors
    public static let terminalBackground = Color(UIColor.systemBackground)
    public static let terminalForeground = Color(UIColor.label)
    public static let terminalCursor = Color.blue
    
    // MARK: - Status Colors
    public static let success = Color.green
    public static let error = Color.red
    public static let warning = Color.orange
    public static let info = Color.blue
    
    // MARK: - Semantic Colors
    public static let backgroundPrimary = Color(UIColor.systemBackground)
    public static let backgroundSecondary = Color(UIColor.secondarySystemBackground)
    public static let textPrimary = Color(UIColor.label)
    public static let textSecondary = Color(UIColor.secondaryLabel)
}

/// Design system typography
public enum AppTypography {
    // MARK: - Font Sizes
    public static let titleLarge: CGFloat = 34
    public static let title: CGFloat = 28
    public static let headline: CGFloat = 17
    public static let body: CGFloat = 17
    public static let callout: CGFloat = 16
    public static let subheadline: CGFloat = 15
    public static let footnote: CGFloat = 13
    public static let caption: CGFloat = 12
    
    // MARK: - Terminal Font
    public static let terminalFontName = "Menlo"
    public static let terminalFontSize: CGFloat = 14
    
    // MARK: - Font Weights
    public enum Weight {
        case regular
        case medium
        case semibold
        case bold
        
        var uiWeight: UIFont.Weight {
            switch self {
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            }
        }
    }
}

/// Design system spacing
public enum AppSpacing {
    public static let xxxSmall: CGFloat = 2
    public static let xxSmall: CGFloat = 4
    public static let xSmall: CGFloat = 8
    public static let small: CGFloat = 12
    public static let medium: CGFloat = 16
    public static let large: CGFloat = 24
    public static let xLarge: CGFloat = 32
    public static let xxLarge: CGFloat = 48
}

/// Design system corner radius
public enum AppRadius {
    public static let small: CGFloat = 4
    public static let medium: CGFloat = 8
    public static let large: CGFloat = 12
    public static let xLarge: CGFloat = 16
}

/// Design system shadows
public struct AppShadow {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    public static let small = AppShadow(
        color: Color.black.opacity(0.1),
        radius: 4,
        x: 0,
        y: 2
    )
    
    public static let medium = AppShadow(
        color: Color.black.opacity(0.15),
        radius: 8,
        x: 0,
        y: 4
    )
    
    public static let large = AppShadow(
        color: Color.black.opacity(0.2),
        radius: 16,
        x: 0,
        y: 8
    )
}

// MARK: - View Extensions

public extension View {
    /// Apply standard card styling
    func cardStyle() -> some View {
        self
            .background(AppColors.backgroundPrimary)
            .cornerRadius(AppRadius.medium)
            .shadow(
                color: AppShadow.small.color,
                radius: AppShadow.small.radius,
                x: AppShadow.small.x,
                y: AppShadow.small.y
            )
    }
    
    /// Apply primary button styling
    func primaryButtonStyle() -> some View {
        self
            .padding(.horizontal, AppSpacing.medium)
            .padding(.vertical, AppSpacing.small)
            .background(AppColors.primary)
            .foregroundColor(.white)
            .cornerRadius(AppRadius.medium)
    }
    
    /// Apply secondary button styling
    func secondaryButtonStyle() -> some View {
        self
            .padding(.horizontal, AppSpacing.medium)
            .padding(.vertical, AppSpacing.small)
            .background(AppColors.backgroundSecondary)
            .foregroundColor(AppColors.textPrimary)
            .cornerRadius(AppRadius.medium)
    }
}
