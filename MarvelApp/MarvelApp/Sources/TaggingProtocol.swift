//
//  Tagging.swift
//  MarvelApp
//
//  Created by C94280a on 28/01/22.
//

import Foundation
import Firebase

protocol TaggingProtocol {
    func screenView(screenName: String, screenClass: String)
    func selectContent(replacedName: String)
    func tagUserId(userId: String)
    func tagPropertyId(value: String, forName: String)
}

class TaggingFirebase: TaggingProtocol {
    
    func screenView(screenName: String, screenClass: String) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: screenName,
                                        AnalyticsParameterScreenClass: screenClass])
    }

    func selectContent(replacedName: String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(replacedName)",
            AnalyticsParameterItemName: replacedName,
            AnalyticsParameterContentType: "cont",
        ])
    }

    func tagUserId(userId: String) {
        Analytics.setUserID(userId)
    }
    
    func tagPropertyId(value: String, forName: String) {
        Analytics.setUserProperty(value, forName: forName)
    }
    
}
