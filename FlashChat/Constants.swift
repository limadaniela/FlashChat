//
//  Constants.swift
//  FlashChat
//
//  Created by Daniela Lima on 2022-07-23.
//

//Constants file used to create a Struct to reduce the number of times we use String.
//we can always access the string using code, rather than typing it.
//the static keyword turns an instance property into a type property (associated with the Constants data type)

struct Constants {
    static let appName = "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
