//
//  ScaledFont.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit

final class ScaledFont {
    static let shared: ScaledFont = ScaledFont(fontPlistName: "AppTheme")
    
    private struct FontDescription: Decodable {
        let fontSize: CGFloat
        let fontName: String
        let textColor: String
    }
    
    private typealias StyleDictionary = [UIFont.TextStyle.RawValue: FontDescription]
    private var styleDictionary: StyleDictionary?
    
    /// Create a `ScaledFont`
    ///
    /// - Parameter fontName: Name of a plist file (without the extension)
    ///   in the main bundle that contains the style dictionary used to
    ///   scale fonts for each text style.
    
    private init(fontPlistName: String) {
        if let url = Bundle.main.url(forResource: fontPlistName, withExtension: "plist"),
            let data = try? Data(contentsOf: url) {
            let decoder = PropertyListDecoder()
            styleDictionary = try? decoder.decode(StyleDictionary.self, from: data)
        }
    }
    
    
    /// Get the scaled font for the given text style using the
    /// style dictionary supplied at initialization.
    ///
    /// - Parameter textStyle: The `UIFontTextStyle` for the
    ///   font.
    /// - Returns: A `UIFont` of the custom font that has been
    ///   scaled for the users currently selected preferred
    ///   text size.
    ///
    /// - Note: If the style dictionary does not have
    ///   a font for this text style the system-default preferred
    ///   font is returned.
    
    public func font(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        guard let fontDescription = styleDictionary?[textStyle.rawValue],
            let font = UIFont(name: fontDescription.fontName, size: fontDescription.fontSize) else {
                return UIFont.preferredFont(forTextStyle: textStyle)
        }
        
        if #available(iOS 11.0, *) {
            let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
            return fontMetrics.scaledFont(for: font)
        } else {
            // Fallback on earlier versions
            return font
        }
    }
    
    public func getTextColor(forTextStyle textStyle: UIFont.TextStyle) -> UIColor {
        guard let fontDescription = styleDictionary?[textStyle.rawValue] else {
            return UIColor.init(hexString: "#333333")
        }
        return UIColor(hexString: fontDescription.textColor)
    }
}
