//
//  GameCenterManager.swift
//  MegaGolf
//
//  Created by Haakon Svane on 31/03/2021.
//

import GameKit

class GameCenterManager: NSObject, GKLocalPlayerListener{
    
    private static let DEFAULT_ENCODER = JSONEncoder()
    private static let DEFAULT_DECODER = JSONDecoder()
    
    weak var delegate : MGManagerDelegate?
    weak var gcLoginViewController : UIViewController?
    weak var accessWindow: GKAccessPoint?
    
    private(set) var match: GKMatch?
    
    var isAuthenticated : Bool {
        return GKLocalPlayer.local.isAuthenticated
    }
    

    init(presenter: MGPresenter){
        self.delegate = presenter
        self.match = nil
        self.accessWindow = GKAccessPoint.shared
        self.accessWindow?.location = .topLeading
        self.accessWindow?.showHighlights = true
    }
    
    func authenticate(){
        GKLocalPlayer.local.authenticateHandler = {viewController, error in
            // If the authentication process fails, the handler presents a viewController to sign in/up.
            if let viewController = viewController {
                self.gcLoginViewController = viewController
                self.delegate?.onNotifyGCAuthResult(success: false)
            }else if error != nil{
                self.delegate?.onNotifyGCAuthResult(success: false)
            }else{
                self.delegate?.onNotifyGCAuthResult(success: true)
                GKLocalPlayer.local.register(self)
                
            }
        }
    }
    
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        guard self.isAuthenticated, let viewCont = GKMatchmakerViewController(invite: invite) else {
            print("Could not create a MatchmakerViewController with the invite from \(invite.sender.alias)")
            return
        }
        viewCont.matchmakerDelegate = self
        delegate?.onAcceptInvite(matchmakerController: viewCont)
    }
    
    func generateMatchmaker() -> UINavigationController?{
        guard GKLocalPlayer.local.isAuthenticated else {return nil}
        
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 4
        request.defaultNumberOfPlayers = 4
        request.inviteMessage = GKLocalPlayer.local.alias+" wants to play MegaGolf! Click the Game Center invite to join the game."
        
        guard let vc = GKMatchmakerViewController(matchRequest: request) else {return nil}
        vc.matchmakerDelegate = self
        return vc
    }
    
    
    func disconnectMatch(){
        if let match = self.match{
            match.disconnect()
            match.delegate = nil
            self.match = nil
        }
    }
    
    
    func transmitData(data: MGOnlineMessageModel, with mode: GKMatch.SendDataMode){
        guard let match = self.match else { return }
        do {
            let encodedData = try GameCenterManager.DEFAULT_ENCODER.encode(data)
            try match.sendData(toAllPlayers: encodedData, with: mode)
        } catch EncodingError.invalidValue{
            print("Failed to encode outgoing data.")
        } catch let error as NSError{
            print("Failed to transmit data with the following error:\n\(error.localizedDescription)")
        }
    }
}

extension GameCenterManager : GKMatchDelegate {
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        var isConnected : Bool
        switch state{
        case .connected:
            isConnected = true
        default:
            isConnected = false
        }
        
        let data = MGLobbyData.isInLobby(isConnected)
        delegate?.onReceiveTransmittedData(from: player, data: MGOnlineMessageModel.lobbyStatus(data: data))
    }
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer){
        do {
            let decodedData : MGOnlineMessageModel = try GameCenterManager.DEFAULT_DECODER.decode(MGOnlineMessageModel.self, from: data)
            delegate?.onReceiveTransmittedData(from: player, data: decodedData)
        } catch {
            print("Failed to decode incoming data.")
        }
    }
    func match(_ match: GKMatch, didFailWithError error: Error?) {
        disconnectMatch()
    }

}

extension GameCenterManager : GKMatchmakerViewControllerDelegate {
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true, completion: {})
        disconnectMatch()
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true, completion: {})
        self.match = match
        match.delegate = self
        self.delegate?.matchFound(match: match)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true, completion: {})
        self.disconnectMatch()
    }
}

