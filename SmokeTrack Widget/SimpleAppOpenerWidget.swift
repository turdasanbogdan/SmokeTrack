//
//  SimpleAppOpenerWidget.swift
//  PersonalData2
//
//  Created by bogdan on 08.05.2024.
//
import Foundation
import WidgetKit
import SwiftUI


import WidgetKit
import SwiftUI

struct SimpleAppOpenerWidget: Widget {
    let kind: String = "SimpleAppOpenerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in

                WidgetEntryView(entry: entry)
 
        }
        .configurationDisplayName("Open App Widget")
        .description("Tap to open the app.")
        .supportedFamilies([.systemSmall, .accessoryInline, .accessoryCircular])
    }
}
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), family: context.family)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), family: context.family)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        print("Creating timeline for context family: \(context.family)")
        let entries = [SimpleEntry(date: Date(), family: context.family)]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let family: WidgetFamily
}

struct WidgetEntryView : View {
    var entry: SimpleEntry

    var body: some View {
        Link(destination: URL(string: "SmokeTrack://")!) {
            Image("ic-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
        }
    }
}

struct AccessoryWidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        Link(destination: URL(string: "SmokeTrack://")!) {
            Image("ic-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .cornerRadius(10)
                .padding()
        }
    }
}


struct WidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: SimpleEntry(date: Date(), family: .systemSmall))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        AccessoryWidgetEntryView(entry: SimpleEntry(date: Date(), family: .accessoryInline))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
        AccessoryWidgetEntryView(entry: SimpleEntry(date: Date(), family: .accessoryCircular))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
