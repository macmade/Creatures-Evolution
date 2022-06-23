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

public class Combat: Gene
{
    public override var canRegress: Bool
    {
        self.settings.combat.canRegress
    }
    
    public override var deactivates: [ String ]
    {
        self.settings.combat.deactivates
    }
    
    public override var name: String
    {
        "Combat"
    }
    
    public override var details: String?
    {
        String( format: "%.02f", self.multiplier )
    }
    
    public override var icon: NSImage?
    {
        NSImage( systemSymbolName: "shield.fill", accessibilityDescription: nil )
    }
    
    public override var canIncreaseOrDecreaseValue: Bool
    {
        true
    }
    
    public private( set ) var multiplier: Double
    
    public override init( active: Bool, settings: Settings )
    {
        self.multiplier = settings.combat.defaultMultiplier
        
        super.init( active: active, settings: settings )
    }
    
    public override func copy( with zone: NSZone? = nil ) -> Any
    {
        let copy        = Combat( active: self.isActive, settings: self.settings )
        copy.multiplier = self.multiplier
        
        return copy
    }
    
    public override func mutate() -> Bool
    {
        if self.isActive == false
        {
            self.isActive = true
            
            return true
        }
        
        if self.canRegress && Bool.random()
        {
            self.isActive = false
            
            return true
        }
        
        if self.settings.combat.minimumMutationChange > self.settings.combat.maximumMultiplier
        {
            return false
        }
        
        let change = Double.random( in: self.settings.combat.minimumMutationChange ... self.settings.combat.maximumMutationChange )
        
        if Bool.random()
        {
            self.multiplier += change
        }
        else
        {
            self.multiplier -= change
        }
        
        if self.multiplier < self.settings.combat.minimumMultiplier
        {
            self.multiplier = self.settings.combat.minimumMultiplier
        }
        
        if self.multiplier > self.settings.combat.maximumMultiplier
        {
            self.multiplier = self.settings.combat.maximumMultiplier
        }
        
        return true
    }
    
    public override func increaseValue()
    {
        self.willChangeValue( for: \.details )
        
        let multiplier  = self.multiplier + 0.1
        self.multiplier = multiplier > self.settings.combat.maximumMultiplier ? self.settings.combat.maximumMultiplier : multiplier
        
        self.didChangeValue( for: \.details )
    }
    
    public override func decreaseValue()
    {
        self.willChangeValue( for: \.details )
        
        let multiplier  = self.multiplier - 0.1
        self.multiplier = multiplier < self.settings.combat.minimumMultiplier ? self.settings.combat.minimumMultiplier : multiplier
        
        self.didChangeValue( for: \.details )
    }
}
