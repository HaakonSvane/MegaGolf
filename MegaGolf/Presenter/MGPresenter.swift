//
//  MGPresenter.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

import GameKit

protocol MGManagerDelegate : AnyObject{
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
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
            view.showsFields = false
            view.showsDrawCount = false
            view.showsQuadCount = false
        }else{
            fatalError("Failed to find SKView!")
        }
        // Initializing the managers
        self.sceneManager = MGSceneManager(presenter: self, sceneSize: skView!.frame.size)
        self.viewManager = MGViewManager(presenter: self, viewSize: skView!.frame.size)
        self.GCManager = GameCenterManager(presenter: self)
        
        // Loading the menus (or game if uncommented)
        loadMenus()
        //loadGame(systemID: 1, levelID: 2) // System ID 0 refers to the debug level
    }

    
}


extension MGPresenter : MGManagerDelegate {
    
    func loadMenus(){
        if GCManager?.match != nil {GCManager?.disconnectMatch()}
        _ = self.sceneManager?.requestStateChange(to: LoadingSceneState.self)
        skView?.presentScene(sceneManager?.currentScene)
        
        // Delay that is presented for the first load. This is to ensure that the Game Center authentification result is logged before entering the main menu.
        var initialDelay = 0.0
        // The dispach group is notified of the async calls. This is to ensure that if we where to ever force the menus
        // to load two times, they will happen sequentially and not in parallell (causing crashes due to strange behaviour with the state machines.. Trust me on this...)
        self.dispatchGroup.enter()
        DispatchQueue.global(qos: .background).async {
            self.viewManager?.loadMenuViews()
            _ = self.sceneManager?.requestStateChange(to: MenuSceneState.self)
            _ = self.viewManager?.requestStateChange(to: MainMenuViewState.self)

            
            if self.firstLoad{
                self.GCManager?.authenticate()
                initialDelay = 3.0
                self.firstLoad = false
            }
            // After the views have loaded and the menu scene has been initialized, we enter the main thread and present the newly created scene.
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
    
    /**
        Adds a given view to the current active scene.
        - Parameters:
            - view: The MGView to add to the current scene.
            - isGUI: Boolean flag to indicate that the view should be treated as a GUI (following camera and exempt from world node shader effects).
     */
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
    
    /**
        Removes the given view from the current view. If the views are just manually removed from their parent scene, the references to the scene entities are still in the `MGScene`.
        - Parameters:
            - view: The reference to the view to remove.
     */
    func removeViewFromCurrentScene(_ view: MGView){
        guard let scn = sceneManager?.currentScene else{
            fatalError("There is no current scene in the scene manager.")
        }
        view.elements.forEach{scn.removeEntity($0)}
        view.run(SKAction.removeFromParent())
    }
    
    /**
        Gets all the entities currently in the active scene
        - Returns: A list of all entities in the scene. If no there is no scene, returns `nil`.
     */
    func getCurrentSceneEntities() -> [GKEntity]? {
        return sceneManager?.currentScene!.entities ?? nil
    }
    
    /**
        Gets the current scene from the scene manager
        - Returns: The current scene (nil if none).
     */
    func getCurrentScene() -> MGScene? {
        return sceneManager?.currentScene
    }
    
    /**
        Notifies the presenter that a scene value change has occured. The method processes the value change and reacts accordingly.
        - Parameters:
            - val: An `MGSceneValueChange` instance containing the type of value change.
     */
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
    
    /**
        Sets or hides the Game Center access window (small circular window with a reference to local player profile).
        - Parameters:
            - option: Boolean value on whether or not to show the access window.
     */
    func showGCAccessWindow(_ option: Bool) {
        if GCManager?.accessWindow?.isActive != option {
            GCManager?.accessWindow?.isActive = option
        }
    }
    /**
     Gets the authentication status of the local player.
        - Returns: Boolean value on whether or not the local player is authenticated.
     */
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
