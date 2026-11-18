import Foundation

enum NetworkError: Error {
    case badURL
    case noInternet
    case badResponse(Int)
    case decodingFailed

    var message: String {
        switch self {
        case .badURL:
            return "Something is wrong with the URL."
        case .noInternet:
            return "No internet connection.\nCheck your network and try again."
        case .badResponse(let code):
            return "Server error (\(code)). Please try again later."
        case .decodingFailed:
            return "Couldn't read the data from server."
        }
    }
}

class NewsService {

    private let baseURL = "https://api.spaceflightnewsapi.net/v4/articles/"

    func fetchArticles(search: String = "", offset: Int = 0) async throws -> NewsResponse {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "limit", value: "20"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        if !search.isEmpty {
            components?.queryItems?.append(URLQueryItem(name: "search", value: search))
        }

        guard let url = components?.url else {
            throw NetworkError.badURL
        }

        let result: (Data, URLResponse)
        do {
            result = try await URLSession.shared.data(from: url)
        } catch {
            throw NetworkError.noInternet
        }

        let (data, response) = result

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw NetworkError.badResponse(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(NewsResponse.self, from: data)
        } catch {
            print("decode error:", error)
            throw NetworkError.decodingFailed
        }
    }
}
