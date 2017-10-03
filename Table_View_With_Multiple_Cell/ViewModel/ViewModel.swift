//
//  ViewModel.swift
//  Table_View_With_Multiple_Cell
//
//  Created by hieunt52 on 10/2/17.
//  Copyright © 2017 hieunt52. All rights reserved.
//

import Foundation
import UIKit

enum ProfileViewModelItemType {
    case nameAndPicture
    case about
    case email
    case friend
    case attribute
}

protocol ProfileViewModelItem {
    var type: ProfileViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
}

// Protocol extension can also allow you to make the optional protocol methods without using the @objc protocols
// Just create a protocol extension and place the default method implementation in this extension.
extension ProfileViewModelItem {
    var rowCount: Int {
        return 1
    }
}

// As I said before, we don’t need to provide the row count, because in this case, we need the default value of 1.
// MARK 1. ProfileViewModelNameItem
class ProfileViewModelNameItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .nameAndPicture
    }
    
    var sectionTitle: String {
        return "Main Info"
    }
}

// MARK 2. ProfileViewModelNameAndPictureItem
class ProfileViewModelNameAndPictureItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .nameAndPicture
    }
    
    var sectionTitle: String {
        return "Main Info"
    }
    
    var pictureUrl: String
    var userName: String
    
    init(pictureUrl: String, userName: String) {
        self.pictureUrl = pictureUrl
        self.userName = userName
    }
}

// MARK 3. ProfileViewModelAboutItem
class ProfileViewModelAboutItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .about
    }
    
    var sectionTitle: String {
        return "About"
    }
    
    var about: String
    
    init(about: String) {
        self.about = about
    }
}

// MARK 4: ProfileViewModelEmailItem
class ProfileViewModelEmailItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .email
    }
    
    var sectionTitle: String {
        return "Email"
    }
    
    var email: String
    
    init(email: String) {
        self.email = email
    }
}

// MARK 5: ProfileViewModelAttributeItem
class ProfileViewModelAttributeItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .attribute
    }
    
    var sectionTitle: String {
        return "Attribute"
    }
    
    var attributes: [Attribute]
    
    var rowCount: Int {
        return attributes.count
    }
    
    init(attributes: [Attribute]) {
        self.attributes = attributes
    }
}

// MARK 6: ProfileViewModeFriendsItem
class ProfileViewModelFriendsItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .friend
    }
    
    var sectionTitle: String {
        return "Friends"
    }
    
    var friends: [Friend]
    
    var rowCount: Int {
        return friends.count
    }
    
    init(friends: [Friend]) {
        self.friends = friends
    }
}

// key ideas behind the MVVM structure: your ViewModel knows nothing about the View, but it provides all the data, that View may need.
class ProfileViewModel: NSObject {
    var items = [ProfileViewModelItem]()
    override init() {
        super.init()
        guard let data = dataFromFile("ServerData"), let profile = Profile(data: data) else {
            Logger.log(message: "Data is nil", event: .e)
            return
        }
        if let name = profile.fullName, let pictureUrl = profile.pictureUrl {
            let nameAndPictureItem = ProfileViewModelNameAndPictureItem(pictureUrl: pictureUrl, userName: name)
            items.append(nameAndPictureItem)
        }
        if let about = profile.about {
            let profileItem = ProfileViewModelAboutItem(about: about)
            items.append(profileItem)
        }
        if let email = profile.email {
            let emailItem = ProfileViewModelEmailItem(email: email)
            items.append(emailItem)
        }
        
        let attributes = profile.profileAttributes
        if !attributes.isEmpty {
            let attributesItem = ProfileViewModelAttributeItem(attributes: attributes)
            items.append(attributesItem)
        }
        
        let friends = profile.friends
        if !friends.isEmpty {
            let friendsItem = ProfileViewModelFriendsItem(friends: friends)
            items.append(friendsItem)
        }
    }
}

extension ProfileViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.section].type {
        case .nameAndPicture:
            if let cell = tableView.dequeueReusableCell(withIdentifier: NamePictureCell.identifier, for: indexPath) as? NamePictureCell {
                cell.item = items[indexPath.section]
                return cell
            }
        case .about:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.identifier, for: indexPath) as? AboutCell {
                cell.item = items[indexPath.section]
                return cell
            }
        case .email:
            if let cell = tableView.dequeueReusableCell(withIdentifier: EmailCell.identifier, for: indexPath) as? EmailCell {
                cell.item = items[indexPath.section]
                return cell
            }
        case .friend:
            if let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as? FriendCell {
                if let item = items[indexPath.section] as? ProfileViewModelFriendsItem {
                    cell.item = item.friends[indexPath.row]
                    return cell
                }
            }
        case .attribute:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AttributeCell.identifier, for: indexPath) as? AttributeCell {
                if let items = items[indexPath.section] as? ProfileViewModelAttributeItem {
                    cell.item = items.attributes[indexPath.row]
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
}

















