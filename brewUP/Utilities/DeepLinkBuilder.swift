//
//  DeepLinkBuilder.swift
//  brewUP
//
//  Created by Will Kuster on 1/16/26.
//
import SwiftUI
import SwiftData

struct DeepLinkBuilder {
    static func createDeepLink(action: String, data: [String: Any]) -> URL? {
        var components = URLComponents()
        components.scheme = "brewup"
        components.host = action
        
        // Convert JSON to base64 for complex data
        if let jsonData = try? JSONSerialization.data(withJSONObject: data),
           let base64String = jsonData.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            components.queryItems = [
                URLQueryItem(name: "data", value: base64String)
            ]
        }
        
        return components.url
    }
    
    static func parseDeepLink(_ url: URL) -> (action: String?, data: [String: Any]?) {
        let action = url.host
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let dataParam = components.queryItems?.first(where: { $0.name == "data" })?.value,
              let decodedData = Data(base64Encoded: dataParam),
              let json = try? JSONSerialization.jsonObject(with: decodedData) as? [String: Any] else {
            return (action, nil)
        }
        
        return (action, json)
    }
}
