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

public class Vampire: DietGene
{
    private var nextUse: TimeInterval?
    
    public override var canRegress: Bool
    {
        self.settings.vampire.canRegress
    }
    
    public override var activates: [ String ]
    {
        self.settings.vampire.activates
    }
    
    public override var deactivates: [ String ]
    {
        self.settings.vampire.deactivates
    }
    
    public override var requires: [ String ]
    {
        self.settings.vampire.requires
    }
    
    public override var name: String
    {
        "Vampire"
    }
    
    public override var icon: NSImage?
    {
        NSImage( systemSymbolName: "fork.knife", accessibilityDescription: nil )
    }
    
    public override func copy( with zone: NSZone? = nil ) -> Any
    {
        Vampire( active: self.isActive, settings: self.settings )
    }
    
    public override func onCollision( creature: Creature, node: SKNode )
    {
        guard let scene = creature.scene as? Scene else
        {
            return
        }
        
        guard let other = node as? Creature else
        {
            return
        }
        
        if PredationHelper.canEat( creature: creature, prey: other ) == false
        {
            return
        }
        
        if let nextUse = self.nextUse, nextUse > scene.elapsedTime
        {
            return
        }
        
        let success = PredationHelper.attack( creature: creature, target: other, settings: scene.settings.vampire.combat )
        
        EventLog.shared.attack( attacker: creature, target: other, success: success )
        
        if success
        {
            let energy = other.energy <= 0 ? 1 : Double.random( in: 0 ... other.energy )
            
            creature.eat( energy: energy )
            
            other.energy -= energy
            self.meals   += 1
            
            if other.isAlive == false
            {
                EventLog.shared.killed( creature: other, by: creature )
            }
            
            self.nextUse = scene.elapsedTime + Double( settings.vampire.combat.recoveryTimeAttackSuccess )
        }
        else
        {
            self.nextUse = scene.elapsedTime + Double( settings.vampire.combat.recoveryTimeAttackFailure )
        }
    }
}
