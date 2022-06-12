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

public class PlantSense: NSObject, Gene
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
            []
        }
    }
    
    public required init( active: Bool )
    {
        self.isActive = active
    }
    
    public func copy( with zone: NSZone? = nil ) -> Any
    {
        PlantSense( active: self.isActive )
    }
    
    public func onEnergyChanged( creature: Creature )
    {}
    
    public func onCollision( creature: Creature, node: SKNode )
    {}
    
    public func chooseDestination( creature: Creature ) -> ( destination: NSPoint, priority: DestinationPriority )?
    {
        if creature.isHerbivore == false && creature.isOmnivore == false
        {
            return nil
        }
        
        guard let scene = creature.scene as? Scene else
        {
            return nil
        }
        
        for child in scene.children
        {
            guard let plant = child as? Food else
            {
                continue
            }
            
            if creature.position.isClose( to: plant.position, maxDistance: 100 )
            {
                return ( destination: plant.position, priority: creature.energy == 0 ? DestinationPriority.high : DestinationPriority.normal )
            }
        }
        
        return nil
    }
}