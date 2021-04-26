//
//  FiniteStack.swift
//  MegaGolf
//
//  Created by Haakon Svane on 30/03/2021.
//

import Foundation


// Swift modulo is not "pure" in a mathematical sense. This is a custom written one.

fileprivate func mod(_ a: Int, _ n: Int) -> Int {
    precondition(n > 0, "modulus must be positive")
    let r = a % n
    return r >= 0 ? r : r + n
}

/**
    A circular stack of `n` items. Follows the LIFO principle and overwrites the oldest entry if the stack is full.
 */
struct FiniteStack<T> : CustomStringConvertible, Sequence {
    
    func makeIterator() -> Array<T?>.Iterator {
          return elements.makeIterator()
        }
    
    var description: String {
        return elements.description
    }
    
    let size: Int
    private var elements: [T?]
    private var headIndex: Int?
    
    init(numItems: UInt8){
        self.size = Int(numItems)
        elements = [T?](repeating: nil, count: self.size)
        headIndex = nil
    }
    
    mutating func push(_ element: T) {
        if let ind = headIndex{
            headIndex = ind + 1
        }
        else{
            headIndex = 0
        }
        headIndex! = mod(headIndex!, self.size)
        
        elements[headIndex!] = element
    }

    mutating func pop() -> T? {
        guard let ind = headIndex else {return nil}
        let val = elements[ind]
        elements[ind] = nil
        headIndex = mod(ind-1, self.size)
        return val
    }

    func peek() -> T? {
        guard let ind = headIndex else {return nil}
        return elements[ind]
    }

}

