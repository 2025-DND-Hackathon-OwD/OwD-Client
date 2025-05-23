//
//  FirebaseManager.swift
//  OwD-iOS
//
//  Created by 이인호 on 5/24/25.
//

import Foundation
import FirebaseStorage

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    func saveImage(data: Data) async throws -> String {
        let path = UUID().uuidString
        let fileReference = storage.child(path)
        
        _ = try await fileReference.putDataAsync(data)
        
        let downloadUrl = try await fileReference.downloadURL()
        
        return downloadUrl.absoluteString
    }
}
