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

public class Abnegation: IntValueGene
{
    public override var canRegress: Bool
    {
        self.settings.abnegation.canRegress
    }
    
    public override var activates: [ String ]
    {
        self.settings.abnegation.activates
    }
    
    public override var deactivates: [ String ]
    {
        self.settings.abnegation.deactivates
    }
    
    public override var name: String
    {
        "Abnegation"
    }
    
    public override var icon: NSImage?
    {
        NSImage( systemSymbolName: "person.fill.xmark", accessibilityDescription: nil )
    }
    
    public override var defaultValue:          Int { 1 }
    public override var defaultValueRange:     Int { 0 }
    public override var minimumValue:          Int { 1 }
    public override var maximumValue:          Int { Int.max }
    public override var minimumMutationChange: Int { 1 }
    public override var maximumMutationChange: Int { 1 }
    
    public override func copy( with zone: NSZone? = nil ) -> Any
    {
        Abnegation( active: self.isActive, settings: self.settings, value: self.value )
    }
    
    public override func onCollision( creature: Creature, node: SKNode )
    {
        guard let other = node as? Creature, other.energy == 0 else
        {
            return
        }
        
        if self.settings.abnegation.requiresSameClass
        {
            let diet1 = creature.genes.compactMap { $0 as? DietGene }.filter { $0.isActive }.first
            let diet2 = other.genes.compactMap    { $0 as? DietGene }.filter { $0.isActive }.first
            
            if let diet1 = diet1, let diet2 = diet2
            {
                if type( of: diet1 ) != type( of: diet2 )
                {
                    return
                }
            }
        }
        
        let energy = min( creature.energy, self.value )
        
        if energy > 0
        {
            creature.energy -= energy
            other.energy    += energy
            
            EventLog.shared.energyTransfer( amount: energy, from: creature, to: other )
        }
    }
}
