import Foundation

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case transport(Error)
    case noResponse
    case invalidStatusCode(Int, Data?)
    case decoding(Error)
}
