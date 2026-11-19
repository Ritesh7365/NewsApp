import SwiftUI

struct NewsListView: View {

    @State private var viewModel = NewsViewModel()

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("🚀 Space News")
                .searchable(text: $viewModel.searchText, prompt: "Search news")
                .onSubmit(of: .search) {
                    Task { await viewModel.load() }
                }
                .onChange(of: viewModel.searchText) { _, newValue in
                    if newValue.isEmpty {
                        Task { await viewModel.load() }
                    }
                }
                .task {
                    if viewModel.articles.isEmpty {
                        await viewModel.load()
                    }
                }
        }
    }

    @ViewBuilder
    var content: some View {
        if case .failed(let message) = viewModel.state, viewModel.articles.isEmpty {
            ErrorView(message: message) {
                Task { await viewModel.load() }
            }
        } else if case .loading = viewModel.state, viewModel.articles.isEmpty {
            ProgressView("Loading news...")
        } else if viewModel.articles.isEmpty {
            ContentUnavailableView.search(text: viewModel.searchText)
        } else {
            List {
                ForEach(viewModel.articles) { article in
                    NavigationLink {
                        ArticleDetailView(article: article)
                    } label: {
                        ArticleRow(article: article)
                    }
                    .onAppear {
                        Task { await viewModel.loadMoreIfNeeded(current: article) }
                    }
                }

                if viewModel.isLoadingMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.load()
            }
        }
    }
}

#Preview {
    NewsListView()
}
