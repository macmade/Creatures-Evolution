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

public class Digestion: DoubleValueGene
{
    private var storedEnergy: [ ( time: TimeInterval, amount: Double ) ] = []
    
    public override var canRegress: Bool
    {
        self.settings.digestion.canRegress
    }
    
    public override var activates: [ String ]
    {
        self.settings.digestion.activates
    }
    
    public override var deactivates: [ String ]
    {
        self.settings.digestion.deactivates
    }
    
    public override var requires: [ String ]
    {
        self.settings.digestion.requires
    }
    
    public override var name: String
    {
        "Digestion"
    }
    
    public override var icon: NSImage?
    {
        NSImage( systemSymbolName: "mouth.fill", accessibilityDescription: nil )
    }
    
    public override var defaultValue:          Double { self.settings.digestion.defaultMultiplier }
    public override var defaultValueRange:     Double { self.settings.digestion.defaultMultiplierRange }
    public override var minimumValue:          Double { self.settings.digestion.minimumMultiplier }
    public override var maximumValue:          Double { self.settings.digestion.maximumMultiplier }
    public override var minimumMutationChange: Double { self.settings.digestion.minimumMutationChange }
    public override var maximumMutationChange: Double { self.settings.digestion.maximumMutationChange }
    
    public override func copy( with zone: NSZone? = nil ) -> Any
    {
        Digestion( active: self.isActive, settings: self.settings, value: self.value )
    }
    
    public override func onUpdate( creature: Creature )
    {
        guard let scene = creature.scene as? Scene else
        {
            return
        }
        
        let now      = scene.elapsedTime
        let digested = self.storedEnergy.filter { $0.time <= now }
        
        self.storedEnergy.removeAll { $0.time <= now }
        
        if digested.count > 0
        {
            creature.energy += digested.reduce( 0.0 ) { $0 + $1.amount }
        }
    }
    
    public override func onFoodConsumption( creature: Creature, energy: Double ) -> Double
    {
        guard let scene = creature.scene as? Scene else
        {
            return energy
        }
        
        let extra = ( energy * self.value ) - energy
        let time  = Double( self.settings.digestion.timeNeeded ) + Double.random( in: 0 ... Double( self.settings.digestion.timeNeededRange ) )
        
        if time == 0
        {
            return energy + extra
        }
        
        let digest    = self.settings.digestion.onlyForExtraEnergy ? extra  : extra + energy
        let immediate = self.settings.digestion.onlyForExtraEnergy ? energy : 0
        
        if digest != 0
        {
            self.storedEnergy.append( ( time: scene.elapsedTime + time, amount: digest ) )
        }
        
        return immediate
    }
    
    public override func energyOnDeath( creature: Creature ) -> Double
    {
        self.storedEnergy.reduce( 0.0 ) { $0 + $1.amount }
    }
}
