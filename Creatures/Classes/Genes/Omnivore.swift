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

public class Omnivore: NSObject, Gene
{
    public var isActive: Bool
    
    public var canRegress: Bool
    {
        true
    }
    
    public var deactivates: [ AnyClass ]
    {
        get
        {
            [ Herbivore.self, Scavenger.self, Carnivore.self, Vampire.self ]
        }
    }
    
    public required init( active: Bool )
    {
        self.isActive = active
    }
    
    public func copy( with zone: NSZone? = nil ) -> Any
    {
        Omnivore( active: self.isActive )
    }
    
    public func onEnergyChanged( creature: Creature )
    {}
    
    public func onCollision( creature: Creature, node: SKNode )
    {
        if let food = node as? Food, food.isBeingRemoved == false
        {
            food.remove()
            
            creature.energy += food.energy
        }
        
        guard let other = node as? Creature else
        {
            return
        }
        
        if other.isBeingRemoved
        {
            return
        }
        
        if other.hasActiveGene( Omnivore.self ) && creature.hasActiveGene( Cannibal.self ) == false
        {
            return
        }
        
        if creature.isRelated( to: other ) && creature.hasActiveGene( Cannibal.self ) == false
        {
            return
        }
        
        if creature.fight( other: other )
        {
            creature.energy += other.energy
            
            other.die( dropFood: true )
        }
    }
    
    public func chooseDestination( creature: Creature ) -> ( destination: NSPoint, priority: DestinationPriority )?
    {
        nil
    }
}
