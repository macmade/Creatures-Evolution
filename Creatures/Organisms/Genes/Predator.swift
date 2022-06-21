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

public class Predator: NSObject, Gene
{
    public var isActive: Bool
    
    public var canRegress: Bool
    {
        self.settings.predator.canRegress
    }
    
    public var deactivates: [ String ]
    {
        get
        {
            self.settings.predator.deactivates
        }
    }
    
    public var name: String
    {
        "Predator"
    }
    
    public override var description: String
    {
        self.name
    }
    
    public var details: String?
    {
        nil
    }
    
    public var icon: NSImage?
    {
        NSImage( systemSymbolName: "fork.knife", accessibilityDescription: nil )
    }
    
    @objc public private( set ) dynamic var settings: Settings
    
    public required init( active: Bool, settings: Settings )
    {
        self.isActive = active
        self.settings = settings
    }
    
    public func copy( with zone: NSZone? = nil ) -> Any
    {
        Predator( active: self.isActive, settings: self.settings )
    }
    
    public func mutate() -> Bool
    {
        if self.canRegress == false && self.isActive
        {
            return false
        }
        
        self.isActive = self.isActive == false
        
        return true
    }
    
    public func onCollision( creature: Creature, node: SKNode )
    {
        guard let other = node as? Creature else
        {
            return
        }
        
        if other.isBeingRemoved
        {
            return
        }
        
        if other.hasActiveGene( Predator.self ) && creature.hasActiveGene( Cannibal.self ) == false
        {
            return
        }
        
        if creature.isChild( of: other ) && ( creature.hasActiveGene( Cannibal.self ) == false || creature.settings.cannibal.canEatParents == false )
        {
            return
        }
        
        if creature.isParentOf( of: other ) && ( creature.hasActiveGene( Cannibal.self ) == false || creature.settings.cannibal.canEatChildren == false )
        {
            return
        }
        
        if creature.isSibling( of: other ) && ( creature.hasActiveGene( Cannibal.self ) == false || creature.settings.cannibal.canEatSiblings == false )
        {
            return
        }
        
        if creature.fight( other: other )
        {
            if other.energy > 0
            {
                let energy = Int.random( in: 0 ..< other.energy )
                
                creature.energy += energy
                other.energy    -= energy
            }
            
            other.die( dropFood: true )
            EventLog.shared.killed( creature: other, by: creature )
        }
    }
}
