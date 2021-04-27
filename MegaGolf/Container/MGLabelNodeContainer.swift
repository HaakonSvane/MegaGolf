//
//  MGLabelNodeContainer.swift
//  MegaGolf
//
//  Created by Haakon Svane on 19/03/2021.
//

import SpriteKit

class MGLabelNodeContainer : SKNode, Sequence{
    
    private var labels : [MGLabelNode]
    
    init(numLabels: Int){
        labels = []
        super.init()
        
        for _ in  0 ..< numLabels{
            self.addLabel(text: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeIterator() -> Array<MGLabelNode>.Iterator {
          return labels.makeIterator()
    }
    
    func addLabel(text: String?, name: String? = nil){
        let lab = MGLabelNode(text: text)
        lab.name = name ?? String(labels.count+1)
        labels.append(lab)
        self.addChild(lab)
    }
    func getLabel(locator: MGContainerLocator) -> MGLabelNode? {
        switch locator{
        case .atIndex(let index):
            return labels[index]
        case .forName(let name):
            return (self.childNode(withName: name) as? MGLabelNode)
        case .all:
            print("Can not retrieve all nodes as a single node. Use the other locators for this function")
            return nil
        }
    }
    func setText(text: String, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            labels[index].text = text
        case .forName(let name):
            (self.childNode(withName: name) as? MGLabelNode)?.text = text
        case .all:
            labels.forEach{$0.text = text}
        }
    }
    
    func setSize(size: CGFloat, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            labels[index].fontSize = size
        case .forName(let name):
            (self.childNode(withName: name) as? MGLabelNode)?.fontSize = size
        case .all:
            labels.forEach{$0.fontSize = size}
        }
    }
    
    func setColor(color: UIColor, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            labels[index].fontColor = color
        case .forName(let name):
            (self.childNode(withName: name) as? MGLabelNode)?.fontColor = color
        case .all:
            labels.forEach{$0.fontColor = color}
        }
    }
    
    func shadow(option: Bool, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            labels[index].showShadow = option
        case .forName(let name):
            (self.childNode(withName: name) as? MGLabelNode)?.showShadow = option
        case .all:
            labels.forEach{$0.showShadow = option}
        }
    }
    
    func setHorizontalAlignment(alignment: SKLabelHorizontalAlignmentMode, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            labels[index].horizontalAlignment = alignment
        case .forName(let name):
            (self.childNode(withName: name) as? MGLabelNode)?.horizontalAlignment = alignment
        case .all:
            labels.forEach{$0.horizontalAlignment = alignment}
        }
    }
    
    func setVerticalAlignment(alignment: SKLabelVerticalAlignmentMode, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            labels[index].verticalAlignment = alignment
        case .forName(let name):
            (self.childNode(withName: name) as? MGLabelNode)?.verticalAlignment = alignment
        case .all:
            labels.forEach{$0.verticalAlignment = alignment}
        }
    }
    
    func setPreferredMaxLayoutWidth(width: CGFloat, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            labels[index].preferredMaxLayoutWidth = width
        case .forName(let name):
            (self.childNode(withName: name) as? MGLabelNode)?.preferredMaxLayoutWidth = width
        case .all:
            labels.forEach{$0.preferredMaxLayoutWidth = width}
        }
    }
    
    func setNumberOfLines(lines: Int, locator: MGContainerLocator){
        switch locator{
        case .atIndex(let index):
            labels[index].numberOfLines = lines
        case .forName(let name):
            (self.childNode(withName: name) as? MGLabelNode)?.numberOfLines = lines
        case .all:
            labels.forEach{$0.numberOfLines = lines}
        }
    }

}

