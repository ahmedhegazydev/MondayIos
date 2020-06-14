//
//  UrlValidation.swift
//  STask_IOS_APP
//
//  Created by Ahmed ElWa7sh on 6/13/20.
//  Copyright © 2020 Susfweb. All rights reserved.
//

import Foundation
import UIKit


extension String {

    private func matches(pattern: String) -> Bool {
        let regex = try! NSRegularExpression(
            pattern: pattern,
            options: [.caseInsensitive])
        return regex.firstMatch(
            in: self,
            options: [],
            range: NSRange(location: 0, length: utf16.count)) != nil
    }

    func isValidURL() -> Bool {
        guard let url = URL(string: self) else { return false }
        if !UIApplication.shared.canOpenURL(url) {
            return false
        }

        let urlPattern = "^(http|https|ftp)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\\:[0-9]+)*(/($|[a-zA-Z0-9\\.\\,\\?\\'\\\\\\+&amp;%\\$#\\=~_\\-]+))*$"
        return self.matches(pattern: urlPattern)
    }
}
