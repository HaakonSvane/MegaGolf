//
//  MGUISliderButtonEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 21/03/2021.
//

import GameKit

struct MGUISliderSettings{
    let minValue: CGFloat
    let maxValue: CGFloat
    let length: CGFloat
    let defaultValue: CGFloat
}

class MGUISliderButtonEntity : GKEntity {
    init(atlasName: String, sliderSettings: MGUISliderSettings, onValueChange: @escaping (CGFloat) -> Void){
        super.init()
        
        let nodeComp = NodeComponent()
        let spriteComp = SpriteComponent(atlasName: atlasName, initTextureName: "sliderButton1")
        let touchComp = TouchableCompoment()
        let shapeComp = ShapeComponent()
        let scaleComp = ScaleComponent(x: 1/2, y: 1/2)
        let hapticComp = HapticComponent(impact: .light)
        let dataComp = DataStoreComponent()
        
        self.addComponent(nodeComp)
        self.addComponent(spriteComp)
        self.addComponent(touchComp)
        self.addComponent(shapeComp)
        self.addComponent(scaleComp)
        self.addComponent(hapticComp)
        self.addComponent(dataComp)
        
        dataComp.data["sliderMin"] = sliderSettings.minValue
        dataComp.data["sliderMax"] = sliderSettings.maxValue
        dataComp.data["sliderLength"] = sliderSettings.length
        
        shapeComp.shapes.addShape(shapeType: .rectangle(CGSize(width: sliderSettings.length, height: 10)),
                                  fillColor: GLOBALCOLOR.SLIDERON ?? GLOBALCOLOR.DEFAULT,
                                  name: "onArea")
        
        shapeComp.shapes.addShape(shapeType: .rectangle(CGSize(width: sliderSettings.length, height: 10)),
                                  fillColor: GLOBALCOLOR.SLIDEROFF ?? GLOBALCOLOR.DEFAULT,
                                  name: "offArea")
        
        let range = sliderSettings.maxValue - sliderSettings.minValue
        let frac = (sliderSettings.defaultValue-sliderSettings.minValue)/range
        
        self.getSpriteNode()!.position.x = sliderSettings.length*(frac-1/2)
        
        shapeComp.shapes.zPosition = -1
        shapeComp.shapes.get(name: "offArea")!.xScale = 1-frac
        shapeComp.shapes.get(name: "offArea")!.position.x = sliderSettings.length/2*frac
        
        touchComp.onTouchDown = {touches, event in
            self.getNode()?.run(SKAction.run{
                self.component(ofType: SpriteComponent.self)?.setTexture(textureName: "sliderButton2")
                self.component(ofType: HapticComponent.self)?.run()
            })
        }
        
        touchComp.onTouchUp = {touches, event in
            self.getNode()?.run(SKAction.run{
                self.component(ofType: SpriteComponent.self)?.setTexture(textureName: "sliderButton1")
                self.component(ofType: AudioComponent.self)?.play()
                self.component(ofType: HapticComponent.self)?.run()
            })
        }
        
        touchComp.onTouchMove = {touches, event in
            if let touch = touches.first{
                let d = self.component(ofType: DataStoreComponent.self)!.data
                let min: CGFloat = d["sliderMin"] as! CGFloat
                let max: CGFloat = d["sliderMax"] as! CGFloat
                let length: CGFloat = (d["sliderLength"] as! CGFloat)
                let tX = touch.location(in: self.getNode()!).x
                
                let tXC = tX.clamped(to: -length/2...length/2)
                let scFrac = 1-(tXC/length+1/2)
                self.getNode()?.run(SKAction.run{
                    self.component(ofType: SpriteComponent.self)?.spriteNode.position.x = tXC
                    self.component(ofType: ShapeComponent.self)?.shapes.get(name: "offArea")!.xScale = scFrac
                    self.component(ofType: ShapeComponent.self)?.shapes.get(name: "offArea")!.position.x = length/2*(1-scFrac)
                })
                onValueChange((1-scFrac)*(max-min)+min)

            }
        }
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
