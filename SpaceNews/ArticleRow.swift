import SwiftUI

struct ArticleRow: View {
    let article: Article

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Color.gray.opacity(0.2)
                .frame(width: 90, height: 90)
                .overlay {
                    AsyncImage(url: URL(string: article.imageUrl ?? "")) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Image(systemName: "photo")
                            .foregroundStyle(.gray)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 6) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)

                Text("\(article.newsSite) • \(article.timeAgo)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
