//
//  WebCacheCleaner.swift
//  Image Feed
//
//  Created by Denis on 19.03.2023.
//

import Foundation
import WebKit

class WebCacheCleaner {
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()){
            records in
            records.forEach {
                record in WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
