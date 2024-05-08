//
//  ArticleView.swift
//  PersonalData2
//
//  Created by bogdan on 07.05.2024.
//

import Foundation
import SwiftUI
import SafariServices

struct ArticleView: View {
    var article: Article
    @State private var showingDetail = false

    var body: some View {
        Link(destination: article.url) {
            VStack {
                Image(article.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 280, height: 140)  // Maintains image size
                    .clipped()
                Text(article.title)
                    .font(.title3)  // Adjusted for potentially smaller size
                    .foregroundColor(.black)
                    .padding(.horizontal, 5)  // Reduced padding to save space
                    .multilineTextAlignment(.center)
                Text(article.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 5)  // Consistent reduced padding
                    .lineLimit(4)  // Adjust line limit based on typical content length
            }
            .frame(width: 300, height: 220)  // Adjust height to ensure text fits
            .background(Rectangle().fill(Color.white).cornerRadius(10).shadow(radius: 5))
            .padding(.horizontal, 8)
        }
    }
}

