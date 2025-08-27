import Foundation

class NetworkService {
    
    let baseURL = "https://api.example.com"
    
    func fetchData(path: String) async throws -> Data {
        let url = URL(string: baseURL + path)! 
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        return data
    }
    
    func decodeData<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func getPosts() async -> [Post]? {
        do {
            let data = try await fetchData(path: "/posts")
            let posts: [Post] = try decodeData(data: data)
            return posts
        } catch {
            print("Error fetching posts: \(error)")
            return nil
        }
    }
}

struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case dataLoadingError
    case decodingError
}
