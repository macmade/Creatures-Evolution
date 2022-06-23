/*******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Jean-David Gadina - www.xs-labs.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Cocoa
import SpriteKit

public class DistanceHelper
{
    private init()
    {}
    
    public class func nearbyObjects< T: SKNode >( creature: Creature, maxDistance: Double, predicate: ( ( T ) -> Bool )? = nil ) -> [ ( distance: Double, node: T ) ]
    {
        guard let scene = creature.scene else
        {
            return []
        }
        
        return scene.children.compactMap
        {
            $0 as? T
        }
        .filter
        {
            predicate?( $0 ) ?? true
        }
        .reduce( into: [ ( distance: Double, node: T ) ]() )
        {
            $0.append( ( creature.position.distance( with: $1.position ), $1 ) )
        }
        .filter
        {
            $0.distance <= maxDistance
        }
        .sorted
        {
            $0.distance < $1.distance
        }
    }
    
    public class func nearestObject< T: SKNode >( creature: Creature, maxDistance: Double, predicate: ( ( T ) -> Bool )? = nil ) -> T?
    {
        let nearby: [ ( distance: Double, node: T ) ] = self.nearbyObjects( creature: creature, maxDistance: maxDistance, predicate: predicate )
        
        return nearby.first?.node
    }
    
    public class func opposite( of p1: NSPoint, from p2: NSPoint ) -> NSPoint
    {
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        
        return NSPoint( x: p2.x - dx, y: p2.y - dy )
    }
}
