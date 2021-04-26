//
//  SKShapeNodeContainer.swift
//  MegaGolf
//
//  Created by Haakon Svane on 21/03/2021.
//

import SpriteKit

enum SKShapeType {
    case circle(CGFloat)
    case rectangle(CGSize)
}
enum SKShapeStrokeType {
    case line
    case dashed
}

class SKShapeNodeContainer : SKNode, Sequence {
    private var numShapes: Int = 0
    private var shapes : [SKShapeNode]
    
    override init(){
        shapes = []
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeIterator() -> Array<SKShapeNode>.Iterator {
          return shapes.makeIterator()
    }
    
    func addShape(shapeType: SKShapeType, fillColor: UIColor = GLOBALCOLOR.DEFAULT, strokeColor: UIColor = .clear, name: String? = nil){
        let shape : SKShapeNode
        switch shapeType {
        case .circle(let radius):
            shape = SKShapeNode(circleOfRadius: radius)
        case .rectangle(let size):
            shape = SKShapeNode(rectOf: size)
        }
        
        shape.fillColor = fillColor
        shape.strokeColor = strokeColor
        shape.name = name ?? "shape\(numShapes+1)"
        shapes.append(shape)
        self.addChild(shape)
        numShapes += 1
    }
    
    func setFill(color: UIColor, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            shapes[index].fillColor = color
        case .forName(let name):
            (self.childNode(withName: name) as? SKShapeNode)?.fillColor = color
        case .all:
            shapes.forEach{$0.fillColor = color}
        }
    }
    
    func setStroke(color: UIColor, locator: MGContainerLocator, lineType: SKShapeStrokeType = .line){
        let shader: SKShader?
        switch lineType {
        case .dashed:
            shader = SKShader(fileNamed: "DashedStroke")
        default:
            shader = nil
        }
        switch locator{
        case .atIndex(let index):
            shapes[index].strokeColor = color
            if let shad = shader{shapes[index].strokeShader = shad}
        case .forName(let name):
            if let shad = shader{(self.childNode(withName: name) as? SKShapeNode)?.strokeShader = shad}
            (self.childNode(withName: name) as? SKShapeNode)?.strokeColor = color
        case .all:
            shapes.forEach{$0.strokeColor = color}
            if let shad = shader{shapes.forEach{$0.strokeShader = shad}}
        }
    }
    
    func visible(option: Bool, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            shapes[index].isHidden = !option
        case .forName(let name):
            (self.childNode(withName: name) as? SKShapeNode)?.isHidden = !option
        case .all:
            shapes.forEach{$0.isHidden = !option}
        }
    }
    
    func zRotation(amount: CGFloat, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            shapes[index].zRotation = amount
        case .forName(let name):
            (self.childNode(withName: name) as? SKShapeNode)?.zRotation = amount
        case .all:
            shapes.forEach{$0.zRotation = amount}
        }
    }
    
    func xScale(amount: CGFloat, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            shapes[index].xScale = amount
        case .forName(let name):
            (self.childNode(withName: name) as? SKShapeNode)?.xScale = amount
        case .all:
            shapes.forEach{$0.xScale = amount}
        }
    }
    
    func yScale(amount: CGFloat, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            shapes[index].yScale = amount
        case .forName(let name):
            (self.childNode(withName: name) as? SKShapeNode)?.yScale = amount
        case .all:
            shapes.forEach{$0.yScale = amount}
        }
    }
    
    func setScale(amount: CGFloat, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            shapes[index].setScale(amount)
        case .forName(let name):
            (self.childNode(withName: name) as? SKShapeNode)?.setScale(amount)
        case .all:
            shapes.forEach{$0.setScale(amount)}
        }
    }
    
    func setStrokeWidth(to amount: CGFloat, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            shapes[index].lineWidth = amount
        case .forName(let name):
            (self.childNode(withName: name) as? SKShapeNode)?.lineWidth = amount
        case .all:
            shapes.forEach{$0.lineWidth = amount}
        }
    }
    
    func setPosition(to pos: CGPoint, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            shapes[index].position = pos
        case .forName(let name):
            (self.childNode(withName: name) as? SKShapeNode)?.position = pos
        case .all:
            shapes.forEach{$0.position = pos}
        }
    }
    
    func setFillShader(shaderName: String, locator: MGContainerLocator, uniforms : [SKUniform] = []){
        let shad = SKShader(fileNamed: shaderName)
        uniforms.forEach{shad.addUniform($0)}
        switch locator{
        case .atIndex(let index):
            shapes[index].fillShader = shad
        case .forName(let name):
            (self.childNode(withName: name) as? SKShapeNode)?.fillShader = shad
        case .all:
            shapes.forEach{$0.fillShader = shad}
        }
    }
    
    func updateFillShaderUniform(uniformNamed: String, floatValue: Float, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            shapes[index].fillShader?.uniformNamed(uniformNamed)!.floatValue = floatValue
        case .forName(let name):
            (self.childNode(withName: name) as? SKShapeNode)?.fillShader?.uniformNamed(uniformNamed)!.floatValue = floatValue
        case .all:
            shapes.forEach{$0.fillShader?.uniformNamed(uniformNamed)!.floatValue = floatValue}
        }
    }
    
    func updateFillShaderUniform(uniformNamed: String, vector2FloatValue: SIMD2<Float>, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            shapes[index].fillShader?.uniformNamed(uniformNamed)!.vectorFloat2Value = vector2FloatValue
        case .forName(let name):
            (self.childNode(withName: name) as? SKShapeNode)?.fillShader?.uniformNamed(uniformNamed)!.vectorFloat2Value = vector2FloatValue
        case .all:
            shapes.forEach{$0.fillShader?.uniformNamed(uniformNamed)!.vectorFloat2Value = vector2FloatValue}
        }
    }
    
    func get(name: String) -> SKNode?{
        return self.childNode(withName: name)
    }
    

}
