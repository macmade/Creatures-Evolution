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

public class MeatSense: NSObject, Gene
{
    public var isActive: Bool
    
    public var canRegress: Bool
    {
        self.settings.meatSense.canRegress
    }
    
    public var deactivates: [ String ]
    {
        get
        {
            self.settings.meatSense.deactivates
        }
    }
    
    public var name: String
    {
        "Meat Sense"
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
        NSImage( systemSymbolName: "sensor.tag.radiowaves.forward.fill", accessibilityDescription: nil )
    }
    
    @objc public private( set ) dynamic var settings: Settings
    
    public required init( active: Bool, settings: Settings )
    {
        self.isActive = active
        self.settings = settings
    }
    
    public func copy( with zone: NSZone? = nil ) -> Any
    {
        MeatSense( active: self.isActive, settings: self.settings )
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
    
    public func chooseDestination( creature: Creature ) -> Destination?
    {
        if creature.hasActiveGene( Scavenger.self ) == false
        {
            return nil
        }
        
        guard let scene = creature.scene as? Scene else
        {
            return nil
        }
        
        for child in scene.children.shuffled()
        {
            guard let meat = child as? Meat else
            {
                continue
            }
            
            if creature.position.isClose( to: meat.position, maxDistance: 100 )
            {
                return Destination( point: meat.position, priority: creature.energy == 0 ? DestinationPriority.high : DestinationPriority.normal )
            }
        }
        
        return nil
    }
}
