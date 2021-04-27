//
//  LevelSelectViewState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

fileprivate typealias anim = MGAnimation

import GameKit

class LevelSelectViewState : MGViewState{
    
    private var currentLevelID : Int
    private var currentSystemID : Int
    private var selectingSystem: Bool
    
    init(viewSize: CGSize){
        // Set these to saved state later
        currentLevelID = 1
        currentSystemID = 1
        selectingSystem = true
        super.init(viewType: LevelSelectView.self, viewSize: viewSize)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is MainMenuViewState.Type
    }
    
    override func willExit(to nextState: GKState) {
        let man = (stateMachine as! MGViewStateMachine).manager
        switch nextState {
        case is MainMenuViewState:
            (man?.delegate?.getCurrentScene()?.camera as? MGCameraNode)?.stopFollowing()
            super.willExit(to: nextState)
        default:
            super.willExit(to: nextState)
        }
    }
    override func didEnter(from previousState: GKState?){
        
        // Hide the buttons
        associatedView?.isHidden = true
        
        // Add the buttons to the scene
        super.didEnter(from: previousState)
        
        // Move all buttons away from the screen
        associatedView!.elements.forEach{
            $0.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "fastDown", orderType: .parallel)
        }
        
        // Unhide them
        associatedView!.isHidden = false
        
        // Move them back into the screen smoothly
        associatedView!.elements.forEach{
            $0.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "smoothUp", orderType: .parallel)
        }
        
        currentSystemID = 1
        currentLevelID = 1
        selectingSystem = true
        resetToDefaultCameraPosition()
        updateButtonLayout()
    }
    private func resetToDefaultCameraPosition(){
        let man = (stateMachine as! MGViewStateMachine).manager
        let scn = (man?.delegate?.getCurrentScene() as? MGMenuScene)
        scn?.unfocusOnLevelEntity(sysID: currentSystemID,
                                  lvlID: currentLevelID,
                                  scaleBackTo: 10,
                                  moveToPos: CGPoint(x: (currentSystemID-1)*10000, y: -400))
    }
    
    private func cameraFollowCurrentLevelEntity(){
        let man = (stateMachine as! MGViewStateMachine).manager
        let scn = (man?.delegate?.getCurrentScene() as? MGMenuScene)
        scn?.focusOnLevelEntity(sysID: currentSystemID, lvlID: currentLevelID)
    }
    
    private func updateButtonLayout(){
        let numSystems = MenuSceneLevelsFactory.numSystems
        
        guard let numLevels = MenuSceneLevelsFactory.getNumLevelsInSystem(withID: currentSystemID) else {
            return
        }
    
        let id = selectingSystem ? currentSystemID : currentLevelID
        let maxID = selectingSystem ? numSystems : numLevels
        
        associatedView?.elements.first(where: {$0.getNode()!.name == "leftButton"})?.getNode()!.isHidden = false
        associatedView?.elements.first(where: {$0.getNode()!.name == "rightButton"})?.getNode()!.isHidden = false
        
        if id == 1 {
            associatedView?.elements.first(where: {$0.getNode()!.name == "leftButton"})?.getNode()!.isHidden = true
        }
        if id == maxID {
            associatedView?.elements.first(where: {$0.getNode()!.name == "rightButton"})?.getNode()!.isHidden = true
        }
    }
    
    func selectClick(){
        let man = (stateMachine as! MGViewStateMachine).manager
        if selectingSystem {
            associatedView?.elements.first(where: {$0.getNode()?.name == "selectButton"})?
                .component(ofType: LabelComponent.self)?.labels.setText(text: "PLAY", locator: .all)
            selectingSystem = false
            currentLevelID = 1
            cameraFollowCurrentLevelEntity()
            updateButtonLayout()
        }else{
            man?.delegate?.loadGame(systemID: currentSystemID, levelID: currentLevelID, onlineMatch: nil)
        }
    }
    
    func backClick(){
        let man = (stateMachine as! MGViewStateMachine).manager
        if selectingSystem {
            man?.enterPreviousState()
        }else{
            associatedView?.elements.first(where: {$0.getNode()?.name == "selectButton"})?
                .component(ofType: LabelComponent.self)?.labels.setText(text: "SELECT", locator: .all)
            self.selectingSystem = true
            resetToDefaultCameraPosition()
            updateButtonLayout()
        }

    }
    
    func leftClick(){
        let numSystems = MenuSceneLevelsFactory.numSystems
        let man = (stateMachine as! MGViewStateMachine).manager
        
        if selectingSystem {
            currentSystemID = (currentSystemID - 1).clamped(to: 1...numSystems)
            resetToDefaultCameraPosition()
            updateButtonLayout()
        }else{
            guard let numLevels = MenuSceneLevelsFactory.getNumLevelsInSystem(withID: currentSystemID) else {
                return
            }
            (man?.delegate?.getCurrentScene() as? MGMenuScene)?.unfocusOnLevelEntity(sysID: currentSystemID, lvlID: currentLevelID)
            currentLevelID = (currentLevelID - 1).clamped(to: 1...numLevels)
            cameraFollowCurrentLevelEntity()
            updateButtonLayout()
        }
    }
    
    func rightClick(){
        let numSystems = MenuSceneLevelsFactory.numSystems
        let man = (stateMachine as! MGViewStateMachine).manager
        
        if selectingSystem {
            currentSystemID = (currentSystemID + 1).clamped(to: 1...numSystems)
            resetToDefaultCameraPosition()
            updateButtonLayout()
        }else{
            guard let numLevels = MenuSceneLevelsFactory.getNumLevelsInSystem(withID: currentSystemID) else {
                return
            }
            (man?.delegate?.getCurrentScene() as? MGMenuScene)?.unfocusOnLevelEntity(sysID: currentSystemID, lvlID: currentLevelID)
            currentLevelID = (currentLevelID + 1).clamped(to: 1...numLevels)
            cameraFollowCurrentLevelEntity()
            updateButtonLayout()
        }
    }
}
