//
//  Store.swift
//  SearchGithubRepositoryApp
//
//  Created by Abhishek Chatterjee on 20/10/21.
//

import UIKit

public class Store<T: Codable> {
    
    static func write(_ object: T) throws {
        if let storeItems = try? Store.read(),
           var items = storeItems as? [[String: Bool]],
           let obj = object as? [[String: Bool]] {
            items.append(contentsOf: obj)
            try writeToFile(items as! T)
        } else {
            try writeToFile(object)
        }
    }
    
    static func writeToFile(_ object: T) throws {
        let data = try JSONEncoder().encode(object)
        try data.write(to: documentUrl())
    }
    
    static func read() throws -> T {
        let data = try Data(contentsOf: documentUrl())
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static func delete(_ object: T) throws {
        if var savedKeys = try? Store<[[String: Bool]]>.read() {
            if let index = savedKeys.firstIndex(of: object as! [String : Bool]) {
                savedKeys.remove(at: index)
            }
            let data = try JSONEncoder().encode(savedKeys)
            try data.write(to: documentUrl())
        }
    }
    
    static func documentUrl() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        return url.appendingPathComponent("store_keys")
    }
}

extension Store {
    public static func getSavedItems() -> [String]? {
        let savedItems = try? Store<[[String: Bool]]>.read()
        var keys: [String] = []
        savedItems?.forEach {
            keys.append(contentsOf: $0.keys)
        }
        return keys
    }
}
