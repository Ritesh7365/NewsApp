import SwiftUI

struct ArticleDetailView: View {
    let article: Article

    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                Color.gray.opacity(0.2)
                    .frame(height: 230)
                    .overlay {
                        AsyncImage(url: URL(string: article.imageUrl ?? "")) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .clipped()

                VStack(alignment: .leading, spacing: 12) {
                    Text(article.newsSite.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)

                    Text(article.title)
                        .font(.title2)
                        .bold()

                    if let date = article.date {
                        Text(date.formatted(date: .long, time: .shortened))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    Text(article.summary)
                        .font(.body)

                    Button {
                        if let url = URL(string: article.url) {
                            openURL(url)
                        }
                    } label: {
                        Label("Read full article", systemImage: "safari")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let url = URL(string: article.url) {
                ShareLink(item: url)
            }
        }
    }
}
