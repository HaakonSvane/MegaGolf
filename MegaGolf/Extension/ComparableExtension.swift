//
//  ComparableExtension.swift
//  MegaGolf
//
//  Created by Haakon Svane on 24/03/2021.
//

/**
    The contents of this source file aims at extending the functionallity of the Comparable protocol which is defined in the Swift standard library
 */


extension Comparable {
    /**
        For any comparable type, the function clamps the value to within its closed range. If the number is outside the closed range, the result is whichever number in the range that is closest to it.
        - Parameters:
            - limits: A `ClosedRange` object that the value is to be clamped around.
     
        - Returns: A clamped number within the range that is closest to the original value.
     */
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
