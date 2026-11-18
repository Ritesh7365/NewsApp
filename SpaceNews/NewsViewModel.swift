import Foundation
import Observation

enum LoadState {
    case loading
    case loaded
    case failed(String)
}

@Observable
class NewsViewModel {
    var articles: [Article] = []
    var state: LoadState = .loading
    var searchText = ""
    var isLoadingMore = false

    private var hasMore = true
    private let service = NewsService()

    @MainActor
    func load() async {
        if articles.isEmpty {
            state = .loading
        }

        do {
            let response = try await service.fetchArticles(search: searchText)
            articles = response.results
            hasMore = response.next != nil
            state = .loaded
        } catch let error as NetworkError {
            if Task.isCancelled { return }
            state = .failed(error.message)
        } catch {
            state = .failed("Something went wrong.")
        }
    }

    // loads next page when user scrolls to the last article
    @MainActor
    func loadMoreIfNeeded(current article: Article) async {
        guard article.id == articles.last?.id, hasMore, !isLoadingMore else { return }

        isLoadingMore = true
        do {
            let response = try await service.fetchArticles(search: searchText, offset: articles.count)
            articles.append(contentsOf: response.results)
            hasMore = response.next != nil
        } catch {
            print("load more failed:", error)
        }
        isLoadingMore = false
    }
}
