//
//  GameViewState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 24/03/2021.
//

import GameKit


class GameViewState : MGViewState{
    var followingBall : Bool
    
    init(viewSize: CGSize){
        followingBall = true
        super.init(viewType: GameView.self, viewSize: viewSize)
        updateButtons()
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GamePausedViewState.Type || stateClass is GameResultViewState.Type
    }
    
    private func updateButtons(){
        associatedView!.elements.first(where: {$0.getNode()!.name == "goalCheckButton"})?.getNode()?.isHidden = !followingBall
        associatedView!.elements.first(where: {$0.getNode()!.name == "ballCheckButton"})?.getNode()?.isHidden = followingBall
    }
    
    func onPauseClick(){
        if !(self.stateMachine?.enter(GamePausedViewState.self) ?? false){
            print("Failed to enter game pause state")
        }
    }
    
    func onGoalCheckClick(){
        let man = (stateMachine as! MGViewStateMachine).manager
        guard let scn = (man?.delegate?.getCurrentScene() as? MGGameScene) else {return}
        scn.followGoal()
        followingBall = false
        updateButtons()
    }
    
    func onBallCheckClick(){
        let man = (stateMachine as! MGViewStateMachine).manager
        guard let scn = (man?.delegate?.getCurrentScene() as? MGGameScene) else {return}
        scn.followBall()
        followingBall = true
        updateButtons()
    }
    
    func onUpdateGameTime(_ time: TimeInterval){
        guard let pane = associatedView?.elements.first(where: {type(of: $0) == MGPaneEntity.self}) else {
            return
        }
        let timeSec = Int(time)
        pane.component(ofType: LabelComponent.self)?.labels.setText(text: "TIME: \(timeSec)", locator: .forName("time"))
    }
    
    
    func setShotValue(value: Int){
        guard let pane = associatedView?.elements.first(where: {type(of: $0) == MGPaneEntity.self}) else {
            return
        }
        pane.component(ofType: LabelComponent.self)?.labels.setText(text: "SHOTS: \(value)", locator: .forName("shots"))
    }
    
    func setParValue(value: Int){
        guard let pane = associatedView?.elements.first(where: {type(of: $0) == MGPaneEntity.self}) else {
            return
        }
        pane.component(ofType: LabelComponent.self)?.labels.setText(text: "PAR: \(value)", locator: .forName("par"))
    }
    
    private static func getGolfScoreToString(shots: Int, par: Int) -> String{
        let diff = shots - par
        if diff == 0 {
            return "BLACK HOLE IN ONE!"
        }
        var returnString = ""
        switch diff{
        case -4:
            returnString = "CONDOR"
        case -3:
            returnString = "ALBATROSS"
        case -2:
            returnString = "EAGLE"
        case -1:
            returnString = "BIRDIE"
        case -0:
            returnString = "PAR"
        case 1:
            returnString = "BOGEY"
        case 2:
            returnString = "DOUBLE BOGEY"
        case 3:
            returnString = "TRIPLE BOGEY"
        default:
            returnString = ""
        }
        let numSign = (diff < 0 ) ? "-" : "+"
        if returnString.count == 0 {
            returnString = numSign+"\(abs(diff))"
        }else{
            returnString += "  ("+numSign+"\(abs(diff)))"
        }
        return returnString
    }
    
    private func enterResultState(){
        if !(self.stateMachine?.enter(GameResultViewState.self) ?? false){
            print("Failed to enter game result view state.")
        }
    }
    
    func didEnterHazard(type: MGHazardType){
        guard let text = associatedView?.elements.first(where: {$0.getNode()?.name == "infoText"}) else {
            return
        }
        let infoString: String
        switch type {
        case .outOfBounds:
            infoString = "DEEP SPACE"
        case .water:
            infoString = "WATER HAZARD"
        }
        let animComp = text.component(ofType: ActionAnimationComponent.self)
        animComp?.runAnimation(withName: "hide", orderType: .parallel)
        text.component(ofType: LabelComponent.self)?.labels.setText(text: infoString, locator: .all)
        animComp?.runAnimation(withName: "unhide", orderType: .parallel)
        animComp?.runAnimation(withName: "popScaleAndFade", orderType: .sequence(delayBetween: 0))
    }
    
    func didEnterGoal(shots: Int, par: Int){
        guard let text = associatedView?.elements.first(where: {$0.getNode()?.name == "infoText"}) else {
            return
        }
        
        let scoreText = GameViewState.getGolfScoreToString(shots: shots, par: par)
        
        let animComp = text.component(ofType: ActionAnimationComponent.self)
        animComp?.runAnimation(withName: "hide", orderType: .parallel)
        text.component(ofType: LabelComponent.self)?.labels.setText(text: scoreText, locator: .all)
        animComp?.runAnimation(withName: "unhide", orderType: .parallel)
        animComp?.runAnimation(withName: "popScaleAndFade", orderType: .sequence(delayBetween: 0), onCompletion: self.enterResultState)
    }
    
}
