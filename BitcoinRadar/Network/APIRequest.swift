import Foundation

struct APIRequest<Response: Decodable> {
    let path: String
    let method: HTTPMethod
    let query: [String: String]
    let headers: [String: String]
    let body: Data?

    init(
        path: String,
        method: HTTPMethod = .get,
        query: [String: String] = [:],
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.query = query
        self.headers = headers
        self.body = body
    }
}

extension APIRequest {
    static func jsonRequest<Body: Encodable>(
        path: String,
        method: HTTPMethod,
        query: [String: String] = [:],
        headers: [String: String] = [:],
        body: Body
    ) throws -> APIRequest<Response> {
        let data = try JSONEncoder().encode(body)
        var allHeaders = headers
        if allHeaders["Content-Type"] == nil {
            allHeaders["Content-Type"] = "application/json"
        }

        return APIRequest(
            path: path,
            method: method,
            query: query,
            headers: allHeaders,
            body: data
        )
    }
}
