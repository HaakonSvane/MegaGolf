//
//  MGOnlineMessageModel.swift
//  MegaGolf
//
//  Created by Haakon Svane on 18/04/2021.
//

import SpriteKit

struct MGGameData : Codable {
    let pos: CGPoint
    let vel: CGVector
}

enum MGLobbyData {
    case readyStatus(Bool, Int)
    case isInLobby(Bool)
}

extension MGLobbyData : Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        
        switch rawValue {
        case 0:
            let ready = try container.decode(Bool.self, forKey: .associatedValue1)
            let sysIDVote = try container.decode(Int.self, forKey: .associatedValue2)
            self = .readyStatus(ready, sysIDVote)
        case 1:
            let present = try container.decode(Bool.self, forKey: .associatedValue1)
            self = .isInLobby(present)
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .readyStatus(let ready, let sysIDVote):
            try container.encode(0, forKey: .rawValue)
            try container.encode(ready, forKey: .associatedValue1)
            try container.encode(sysIDVote, forKey: .associatedValue2)
        case .isInLobby(let present):
            try container.encode(1, forKey: .rawValue)
            try container.encode(present, forKey: .associatedValue1)
        }
    }
    
    enum Key: CodingKey {
        case rawValue
        case associatedValue1
        case associatedValue2
    }
        
    enum CodingError: Error {
        case unknownValue
    }
}

struct MGChatData : Codable {
    let text: String
    let time: TimeInterval
}



enum MGOnlineMessageModel {
    case lobbyStatus(data: MGLobbyData)
    case chatData(data: MGChatData)
    case gameData(data: MGGameData)
}

extension MGOnlineMessageModel : Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        
        switch rawValue {
        case 0:
            let data = try container.decode(MGLobbyData.self, forKey: .associatedValue)
            self = .lobbyStatus(data: data)
        case 1:
            let data = try container.decode(MGChatData.self, forKey: .associatedValue)
            self = .chatData(data: data)
        case 2:
            let data = try container.decode(MGGameData.self, forKey: .associatedValue)
            self = .gameData(data: data)
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .lobbyStatus(let data):
            try container.encode(0, forKey: .rawValue)
            try container.encode(data, forKey: .associatedValue)
        case .chatData(let data):
            try container.encode(1, forKey: .rawValue)
            try container.encode(data, forKey: .associatedValue)
        case .gameData(let data):
            try container.encode(2, forKey: .rawValue)
            try container.encode(data, forKey: .associatedValue)
        }
    }
    
    enum Key: CodingKey {
        case rawValue
        case associatedValue
    }
        
    enum CodingError: Error {
        case unknownValue
    }
}
