//
//  User.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import Foundation

class User: Decodable {
    var userId : Int = 0
    var login  : String?
    var nodeId : String?
    var avatarUrl : String?
    var gravatarId : String?
    var url : String?
    var htmlUrl : String?
    var followersUrl : String?
    var followingUrl : String?
    var gistsUrl : String?
    var starredUrl : String?
    var subscriptionsUrl : String?
    var organizationsUrl : String?
    var reposUrl : String?
    var eventsUrl : String?
    var receivedEventsUrl : String?
    var type : String?
    var isAdmin : Bool = false
    
    enum CodingKeys : String, CodingKey {
        case userId = "id"
        case login  = "login"
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url = "url"
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
        case receivedEventsUrl = "received_events_url"
        case type = "type"
        case isAdmin = "site_admin"
    }
}

