//
//  ShopModel.swift
//

import UIKit
import Foundation

//MARK:- ShopModel structure
struct ShopModel: Codable {
    var title: String?
    var backgroundImage: String?
    var promoMessage: String?
    var topDescription: String?
    var bottomDescription: String?
    var content: [ContentModel]?
}

struct ContentModel: Codable {
    var target: String?
    var title: String?
}
