//
//  CError.swift
//  Just ALL IN
//
//  Created by 蕭煜勳 on 2024/4/17.
//

import Foundation

enum CError: String, Error {
    case invailedURL = "URL錯誤"
    case invailedToComplete = "錯誤無法提取，請檢查您的網路狀態"
    case invailedResponse = "伺服器無回應"
    case emptyData = "錯誤沒有Data"
    case invailedDecode = "無法decode data"
}
