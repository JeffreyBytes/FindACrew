//
//  PersonController.swift
//  FindACrew
//
//  Created by Jeffrey Carpenter on 5/7/19.
//  Copyright © 2019 Jeffrey Carpenter. All rights reserved.
//

import Foundation

class PersonController {
    
    let baseUrl = URL(string: "https://swapi.co/api/people/")!
    var people = [Person]()
    enum HTTPMethod: String {
        case get    = "GET"
        case post   = "POST"
        case put    = "PUT"
        case delete = "DELETE"
    }
    
    func searchForPeople(with searchTerm: String, completion: @escaping () -> Void) {
        
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        let searchTermQueryItem = URLQueryItem(name: "search", value: searchTerm)
        urlComponents?.queryItems = [searchTermQueryItem]
        
        guard let requestURL = urlComponents?.url else {
            NSLog("requestURL is nil")
            completion()
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching data: \(error.localizedDescription)")
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let personSearch = try jsonDecoder.decode(PersonSearch.self, from: data)
                self.people = personSearch.results
            } catch {
                NSLog("Unable to decode data into object of type [Person]: \(error.localizedDescription)")
            }
            
            completion()
        }.resume()
    }
}
