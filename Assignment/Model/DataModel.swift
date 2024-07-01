//
//  DataModel.swift
//  Assignment
//
//  Created by Andrew Hudsun on 07/07/24.
//

import Foundation

struct DataModel:Codable {
    var id:String?
    var author:String?
    var width:Int?
    var height:Int?
    var url:String?
    var download_url:String?
    var isSelected:Bool?
}
