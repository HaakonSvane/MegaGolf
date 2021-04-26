//
//  MGAudio.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

enum AudioType{
    case effect
    case music
}

struct MGAudioUnit {
    var fileName : String
    var type : AudioType
}
