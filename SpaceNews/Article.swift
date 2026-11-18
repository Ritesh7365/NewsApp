// xcode: set sdk=iOS

import Foundation

struct NewsResponse: Codable {
    let count: Int
    let next: String?
    let results: [Article]
}

struct Article: Codable, Identifiable {
    let id: Int
    let title: String
    let url: String
    let imageUrl: String?
    let newsSite: String
    let summary: String
    let publishedAt: String

    // json uses snake_case, swift uses camelCase
    enum CodingKeys: String, CodingKey {
        case id, title, url, summary
        case imageUrl = "image_url"
        case newsSite = "news_site"
        case publishedAt = "published_at"
    }

    var date: Date? {
        let f = ISO8601DateFormatter()
        if let d = f.date(from: publishedAt) {
            return d
        }
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f.date(from: publishedAt)
    }

    // "2 hr. ago"
    var timeAgo: String {
        guard let date else { return "" }
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .short
        return f.localizedString(for: date, relativeTo: Date())
    }
}
