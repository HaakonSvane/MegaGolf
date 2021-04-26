//
//  MGPresenter.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

import GameKit

protocol ManagerDelegate : AnyObject{
    func addViewToCurrentScene(_ view: MGView, isGUI: Bool) -> Void
    func removeViewFromCurrentScene(_ view: MGView) -> Void
    func loadMenus() -> Void
    func loadGame(systemID: Int, levelID: Int, onlineMatch: GKMatch?) -> Void
    func getCurrentSceneEntities() -> [GKEntity]?
    func getCurrentScene() -> MGScene?
    func onNotifySceneValueChange(val: MGSceneValueChange)
    func showGCAccessWindow(_ option: Bool)
    func isGCAuthenticated() -> Bool
    func requestGCLoginView()
    func onNotifyGCAuthResult(success: Bool)
    func requestPresentController(viewController: UIViewController)
    func prepareMatch()->UINavigationController?
    func matchFound(match: GKMatch)
    func disconnectFromMatch()
    func transmitData(data: MGOnlineMessageModel, with mode: GKMatch.SendDataMode)
    func onReceiveTransmittedData(from player: GKPlayer, data: MGOnlineMessageModel)
    func getOnlineMatch()->GKMatch?
    func onAcceptInvite(matchmakerController: GKMatchmakerViewController)
}

class MGPresenter : GameViewController{
    
    private var sceneManager : MGSceneManager?
    private var viewManager : MGViewManager?
    private var GCManager : GameCenterManager?
    private var skView : SKView?
    
    private var firstLoad : Bool = true
    
    private let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            self.skView = view
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = false
            view.showsFields = false
            view.showsDrawCount = true
            view.showsQuadCount = true
        }else{
            fatalError("Failed to find SKView!")
        }
        self.sceneManager = MGSceneManager(presenter: self, sceneSize: skView!.frame.size)
        self.viewManager = MGViewManager(presenter: self, viewSize: skView!.frame.size)
        self.GCManager = GameCenterManager(presenter: self)
        loadMenus()
        //loadGame(systemID: 1, levelID: 3) // System ID 0 refers to the debug level
    }

    
}


extension MGPresenter : ManagerDelegate {
    
    func loadMenus(){
        if GCManager?.match != nil {GCManager?.disconnectMatch()}
        _ = self.sceneManager?.requestStateChange(to: LoadingSceneState.self)
        skView?.presentScene(sceneManager?.currentScene)
        
        // Delay that is presented for the first load. This is to ensure that the Game Center authentification result is logged before entering the main menu.
        var initialDelay = 0.0
        self.dispatchGroup.enter()
        DispatchQueue.global(qos: .background).async {
            self.viewManager?.loadMenuViews()
            _ = self.sceneManager?.requestStateChange(to: MenuSceneState.self)
            _ = self.viewManager?.requestStateChange(to: MainMenuViewState.self)

            
            if self.firstLoad{
                self.GCManager?.authenticate()
                initialDelay = 2.0
                self.firstLoad = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay) {
                self.skView?.presentScene((self.sceneManager?.currentScene)!, transition: SKTransition.fade(with: .black, duration: 0.2))
                self.dispatchGroup.leave()
                }
        }
    }
    
    func loadGame(systemID: Int, levelID: Int, onlineMatch: GKMatch? = nil) {
        _ = self.sceneManager?.requestStateChange(to: LoadingSceneState.self)
        self.skView?.presentScene((self.sceneManager?.currentScene)!, transition: SKTransition.push(with: .left, duration: 0.5))
        self.dispatchGroup.enter()
        DispatchQueue.global(qos: .background).async {
            self.sceneManager?.loadLevel(sysID: systemID, lvlID: levelID, onlineMatch: onlineMatch)
            self.viewManager?.loadGameViews()
            _ = self.sceneManager?.requestStateChange(to: GameSceneState.self)
            _ = self.viewManager?.requestStateChange(to: GameViewState.self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.skView?.presentScene((self.sceneManager?.currentScene)!, transition: SKTransition.fade(with: .black, duration: 0.5))
                self.dispatchGroup.leave()
                }
        }
        
    }
    func addViewToCurrentScene(_ view: MGView, isGUI: Bool){
        guard let scn = sceneManager?.currentScene else{
            fatalError("There is no current scene in the scene manager.")
        }
        view.elements.forEach{scn.addEntity($0)}
        if isGUI{
            scn.camera?.addChild(view)
        }else{
            scn.addChild(view)
        }

    }
    
    func removeViewFromCurrentScene(_ view: MGView){
        guard let scn = sceneManager?.currentScene else{
            fatalError("There is no current scene in the scene manager.")
        }
        view.elements.forEach{scn.removeEntity($0)}
        view.run(SKAction.removeFromParent())
    }
    
    func getCurrentSceneEntities() -> [GKEntity]? {
        return sceneManager?.currentScene!.entities ?? nil
    }
    
    func getCurrentScene() -> MGScene? {
        return sceneManager?.currentScene
    }
    
    func onNotifySceneValueChange(val: MGSceneValueChange){
        switch val {
        case .golfShots(let value):
            if let gState = viewManager?.currentState as? GameViewState{
                gState.setShotValue(value: value)
            }
            
        case .gamePar(let value):
            if let gState = viewManager?.currentState as? GameViewState{
                gState.setParValue(value: value)
            }
            
        case .enteredHazard(let hazardType):
            if let gState = viewManager?.currentState as? GameViewState{
                gState.didEnterHazard(type: hazardType)
            }
            
        case .enteredGoal(let shots, let par):
            if let gState = viewManager?.currentState as? GameViewState{
                gState.didEnterGoal(shots: shots, par: par)
            }
            
        case .gameTime(let time):
            if let gState = viewManager?.currentState as? GameViewState{
                gState.onUpdateGameTime(time)
            }
        }
    }
    
    func showGCAccessWindow(_ option: Bool) {
        if GCManager?.accessWindow?.isActive != option {
            GCManager?.accessWindow?.isActive = option
        }
    }
    
    func isGCAuthenticated() -> Bool {
        guard let val = self.GCManager?.isAuthenticated else {
            return false
        }
        return val
    }
    
    func requestGCLoginView(){
        if let cont = GCManager?.gcLoginViewController{
            requestPresentController(viewController: cont)
        }else{
            self.viewManager?.loginComplete(success: false)
        }
    }
    
    func onNotifyGCAuthResult(success: Bool) {
        self.viewManager?.loginComplete(success: success)
    }
    
    func requestPresentController(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: {})
    }
    
    func prepareMatch() -> UINavigationController? {
        return GCManager?.generateMatchmaker()
    }
    
    func matchFound(match: GKMatch) {
        _ = viewManager?.requestStateChange(to: MultiplayerLobbyViewState.self)
        guard let state = viewManager?.currentState as? MultiplayerLobbyViewState else {return}
        state.onReceiveMatch(match: match)
    }
    
    func disconnectFromMatch() {
        GCManager?.disconnectMatch()
    }
    
    func transmitData(data: MGOnlineMessageModel, with mode: GKMatch.SendDataMode) {
        GCManager?.transmitData(data: data, with: mode)
    }
    
    func onReceiveTransmittedData(from player: GKPlayer, data: MGOnlineMessageModel) {
        switch data{
        case .lobbyStatus(let lobbyData):
            guard let state = viewManager?.currentState as? MultiplayerLobbyViewState else {return}
            state.onReceiveData(from: player, data: lobbyData)
        case .gameData(let gameData):
            guard let state = sceneManager?.currentState as? GameSceneState else {return}
            state.onReceiveData(player: player, data: gameData)
        default:
            break
        }
    }
    
    func getOnlineMatch() -> GKMatch? {
        return GCManager?.match
    }
    
    /**
        Is called by the GameCenterManager once the game is launched from an invite.
        - Parameters:
            - matchMakerController: The view controller presented by GameCenter that represents the lobby created by the invitee.
     */
    func onAcceptInvite(matchmakerController: GKMatchmakerViewController) {
        /// TODO: Display a message if the invite failes to be properly handled
        
        // Checking if the game can enter the multiplayerState since this state handles the logic for matchmaking.
        if viewManager?.canEnterState(MultiplayerViewState.self) ?? false {
            _ = self.viewManager?.requestStateChange(to: MultiplayerViewState.self)
            self.requestPresentController(viewController: matchmakerController)
        }else{
            // If it can not, schedule a reset by loading the menus, thereby ensuring that we are in the MainMenuState.
            // We dont know when this function might arrive, so we wait for any possible loading to finish before loading again.
            
            // This is a quick fix to problems that may arrise from the fact that the game may or may not be launched when accepting the invite
            // and that we don't know what state it might be in.
            self.dispatchGroup.notify(queue: .main){
                self.loadMenus()
                self.dispatchGroup.notify(queue: .main){
                    _ = self.viewManager?.requestStateChange(to: MultiplayerViewState.self)
                    self.requestPresentController(viewController: matchmakerController)
                }
            }
        }
    }
}
