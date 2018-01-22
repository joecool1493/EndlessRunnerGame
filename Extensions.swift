//
//  Extensions.swift
//  TheEndlessRunner
//
//  Created by Joey Newfield on 1/22/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import CoreGraphics

//Adds two CGPoint values and returns a new CGPoint.
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

//Increments a CGPoint with the value of another CGPoint
public func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}


//Multiplies the x and y of a CGPoint and returns a new CGPoint.
public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

//Multiplies the x and y fields of a CGPoint.
public func *= (point: inout CGPoint, scalar: CGFloat) {
    point = point * scalar
}

public extension CGFloat {
    
    public func degreesToRadians() -> CGFloat {
        return 3.1459 * self / 180.0
    }
    
    public func radiansToDegrees() -> CGFloat {
        return self * 180.0 / 3.1459
    }
}

