//
//  CGPoint+math.swift
//  Mini2
//
//  Created by Brandon Nicolas Marlim on 6/30/23.
//

import SpriteKit

extension CGPoint {
    public static func - (lhs : CGPoint, rhs : CGPoint ) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    public static func + (lhs : CGPoint, rhs : CGPoint ) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

}
