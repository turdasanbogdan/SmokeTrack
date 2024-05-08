//
//  LearnView.swift
//  PersonalData2
//
//  Created by bogdan on 07.05.2024.
//

import Foundation
import SwiftUI

struct LearnView: View {
    @State private var searchText = ""

    // Sample articles for display
    let sampleArticles = [
        Article(image: "ic-article-placeholder", title: "Quitting smoking: 10 ways to resist tobacco cravings", description: "Tobacco cravings can wear you down when you're trying to quit. Use these tips to reduce and resist cravings.", url: URL(string: "https://www.mayoclinic.org/healthy-lifestyle/quit-smoking/in-depth/nicotine-craving/art-20045454")!),
        Article(image: "ic-article-placeholder", title: "More than 100 reasons to quit tobacco", description: "Tobacco causes 8 million deaths every year. When evidence was released this year that smokers were more likely to develop severe disease with COVID-19 compared to non-smokers, it triggered millions of smokers to want to quit tobacco. ", url: URL(string: "https://www.paho.org/en/more-100-reasons-quit-tobacco")!),
        Article(image: "ic-article-placeholder", title: "Nutrition Tips", description: "Dietary advice for a balanced diet.", url: URL(string: "https://example.com")!),
        Article(image: "ic-article-placeholder", title: "Mental Health", description: "Strategies to improve mental health.", url: URL(string: "https://example.com")!)
    ]
    
    let sampleArticlesHealth = [
        Article(image: "ic-article-placeholder", title: "Tips From Former Smokers", description: "The individuals below are participating in the Tips From Former Smokers® campaign. All of them are living with or caring for someone with smoking-related diseases and disabilities.", url: URL(string: "https://www.cdc.gov/tobacco/campaign/tips/stories/index.html")!),
        Article(image: "ic-article-placeholder", title: "What Are The Best Herbal Remedies to Help You Quit Smoking? ", description: "According to the CDC, out of every 100 adults in the United States, 14 of them smoke cigarettes and 68% of these people say that they want to quit smoking.", url: URL(string: "https://www.therippleco.co.uk/blogs/lifestyle/what-are-the-best-herbal-remedies-to-help-you-quit-smoking")!),
        Article(image: "ic-article-placeholder", title: "Nutrition Tips", description: "Dietary advice for a balanced diet.", url: URL(string: "https://example.com")!),
        Article(image: "ic-article-placeholder", title: "Mental Health", description: "Strategies to improve mental health.", url: URL(string: "https://example.com")!)
    ]

    // Computed property to filter articles based on search text
    var filteredArticles: [Article] {
        if searchText.isEmpty {
            return sampleArticles
        } else {
            return sampleArticles.filter { article in
                article.title.localizedCaseInsensitiveContains(searchText) || article.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var filteredArticlesHealth: [Article] {
        if searchText.isEmpty {
            return sampleArticlesHealth
        } else {
            return sampleArticlesHealth.filter { article in
                article.title.localizedCaseInsensitiveContains(searchText) || article.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }


    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Learn More")
                .font(.largeTitle)
                .padding(.leading)
            
            searchView  // This stays at the top, outside the ScrollView

            ScrollView {
                VStack(alignment: .leading) {
                    
                    sectionTitleView(title: "Tailored for you", subtitle: "Articles we recommend you based on your data")
                    articlesView
                    
                    sectionTitleView(title: "Learn more about your health", subtitle: "Understand the impact that smoking can have on your health")
                    articlesViewHealth
                    
                    Spacer()
                }
            }
        }
    }
    
    private func sectionTitleView(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .padding(.leading)

            Text(subtitle)
                .font(.caption)
                .foregroundColor(.gray)
                .padding([.leading, .bottom])
        }
    }


    // Search view component
    private var searchView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search...", text: $searchText)
            if !searchText.isEmpty {
                Button("Cancel") {
                    searchText = ""
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.2))
        .cornerRadius(10)
        .padding()
    }

    // View for displaying articles or no results message
    private var articlesView: some View {
        Group {
            if filteredArticles.isEmpty {
                Text("No articles available")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(filteredArticles) { article in
                            ArticleView(article: article)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private var articlesViewHealth: some View {
        Group {
            if filteredArticlesHealth.isEmpty {
                Text("No articles available")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(filteredArticlesHealth) { article in
                            ArticleView(article: article)
                        }
                    }
                    .padding()
                    .padding(.bottom, 50)
                }
            }
        }
    }

}
