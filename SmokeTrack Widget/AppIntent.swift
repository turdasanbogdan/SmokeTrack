//
//  AppIntent.swift
//  SmokeTrack Widget
//
//  Created by bogdan on 08.05.2024.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")


    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}
