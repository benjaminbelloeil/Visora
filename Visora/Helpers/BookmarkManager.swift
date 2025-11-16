//
//  BookmarkManager.swift
//  Visora
//
//  Created on November 16, 2025.
//

import Foundation

class BookmarkManager {
    static let shared = BookmarkManager()
    
    private let bookmarksKey = "BookmarkedDestinations"
    
    // Use UserDefaults for now (works in simulator and on device without iCloud entitlements)
    // To enable iCloud: Add iCloud capability in Xcode and uncomment the NSUbiquitousKeyValueStore code
    private let useICloud = false
    private let store = NSUbiquitousKeyValueStore.default
    private let userDefaults = UserDefaults.standard
    
    private init() {
        if useICloud {
            // Listen for changes from iCloud
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(ubiquitousKeyValueStoreDidChange),
                name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                object: store
            )
            
            // Sync initial values
            store.synchronize()
        }
    }
    
    @objc private func ubiquitousKeyValueStoreDidChange(notification: Notification) {
        // Sync happened, post notification for UI updates
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .bookmarksDidChange, object: nil)
        }
    }
    
    // Get all bookmarked destination IDs
    func getBookmarkedDestinations() -> [String] {
        if useICloud {
            if let bookmarks = store.array(forKey: bookmarksKey) as? [String] {
                return bookmarks
            }
        } else {
            if let bookmarks = userDefaults.stringArray(forKey: bookmarksKey) {
                return bookmarks
            }
        }
        return []
    }
    
    // Check if a destination is bookmarked
    func isBookmarked(_ destinationId: String) -> Bool {
        return getBookmarkedDestinations().contains(destinationId)
    }
    
    // Add a bookmark
    func addBookmark(_ destinationId: String) {
        var bookmarks = getBookmarkedDestinations()
        if !bookmarks.contains(destinationId) {
            bookmarks.append(destinationId)
            
            if useICloud {
                store.set(bookmarks, forKey: bookmarksKey)
                store.synchronize()
            } else {
                userDefaults.set(bookmarks, forKey: bookmarksKey)
                userDefaults.synchronize()
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .bookmarksDidChange, object: nil)
            }
        }
    }
    
    // Remove a bookmark
    func removeBookmark(_ destinationId: String) {
        var bookmarks = getBookmarkedDestinations()
        bookmarks.removeAll { $0 == destinationId }
        
        if useICloud {
            store.set(bookmarks, forKey: bookmarksKey)
            store.synchronize()
        } else {
            userDefaults.set(bookmarks, forKey: bookmarksKey)
            userDefaults.synchronize()
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .bookmarksDidChange, object: nil)
        }
    }
    
    // Toggle bookmark status
    func toggleBookmark(_ destinationId: String) -> Bool {
        let isCurrentlyBookmarked = isBookmarked(destinationId)
        if isCurrentlyBookmarked {
            removeBookmark(destinationId)
        } else {
            addBookmark(destinationId)
        }
        return !isCurrentlyBookmarked
    }
    
    // Get bookmark count
    func getBookmarkCount() -> Int {
        return getBookmarkedDestinations().count
    }
}

// Notification name for bookmark changes
extension Notification.Name {
    static let bookmarksDidChange = Notification.Name("bookmarksDidChange")
}
