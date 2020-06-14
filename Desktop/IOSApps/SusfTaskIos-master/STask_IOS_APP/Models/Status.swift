//
//  Status.swift
//  STask_IOS_APP
//
//  Created by Ahmed ElWa7sh on 6/13/20.
//  Copyright © 2020 Susfweb. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct StatusData: Codable {
    let successful: Bool
    let data: DataClassStatus
    let message: String
}

// MARK: - DataClass
struct DataClassStatus: Codable {
    let taskStatusData: [TaskStatus]
}

// MARK: - TaskStatusDatum
struct TaskStatus: Codable {
    let color, id: String
    let isInit, isDone: Bool
    let name: String
    let isRejected: Bool
}
