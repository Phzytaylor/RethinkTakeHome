//
//  ResourceRequest.swift
//  RethinkTakeHome
//
//  Created by Taylor Simpson on 5/10/23.
//

import Foundation

// NetworkService is a protocol that defines a single async function for fetching data from a URL
protocol NetworkService {
    func fetch(_ url: URL) async throws -> (Data, URLResponse)
}

// RealNetworkService is a struct that conforms to the NetworkService protocol
// It uses URLSession.shared to fetch the data from the provided URL
struct RealNetworkService: NetworkService {
    func fetch(_ url: URL) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(from: url)
    }
}

// MockNetworkService is a class that conforms to the NetworkService protocol
// It uses a dictionary of URL to (Data, URLResponse) pairs to mock network responses
class MockNetworkService: NetworkService {
    private let responses: [URL: (Data, URLResponse)]

    // Initialize the MockNetworkService with a dictionary of mock responses
    init(responses: [URL: (Data, URLResponse)]) {
        self.responses = responses
    }

    // Fetches the data from the mock responses dictionary, throws an error if there is no response for the given URL
    func fetch(_ url: URL) async throws -> (Data, URLResponse) {
        if let response = responses[url] {
            return response
        } else {
            throw ResourceRequestError.noData
        }
    }
}

// ResourceRequest is a generic struct for making network requests for resources of a specific type
// ResourceType must conform to the Codable protocol
struct ResourceRequest<ResourceType> where ResourceType: Codable {
    let baseURL = "https://jsonplaceholder.typicode.com"
    var resourceURL: URL
    var networkService: NetworkService
    var query: String?
    var queryValue: String?

    // Initialize the ResourceRequest with a resource path, optional query parameters, and a NetworkService (defaults to RealNetworkService)
    init(resourcePath: String, query: String? = nil, queryValue: String? = nil, networkService: NetworkService = RealNetworkService()) {
        guard let resourceURL = URL(string: baseURL) else {
            fatalError("Failed to convert baseURL to a URL")
        }
        
        self.resourceURL = resourceURL.appendingPathComponent(resourcePath)
        self.query = query
        self.queryValue = queryValue
        if let query = query, let queryValue = queryValue {
            self.resourceURL.append(queryItems: [.init(name: query, value: queryValue)])
        }
        self.networkService = networkService
    }

    // Async function to fetch all resources of the specified type from the resource URL
    // Decodes the fetched data into an array of the specified resource type
    func getAll() async throws -> [ResourceType] {
        let (data, _) = try await networkService.fetch(resourceURL)
        return try JSONDecoder().decode([ResourceType].self, from: data)
    }
}

