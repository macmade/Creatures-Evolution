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

public class Herbivore: DietGene
{
    public override var canRegress: Bool
    {
        self.settings.herbivore.canRegress
    }
    
    public override var activates: [ String ]
    {
        self.settings.herbivore.activates
    }
    
    public override var deactivates: [ String ]
    {
        self.settings.herbivore.deactivates
    }
    
    public override var name: String
    {
        "Herbivore"
    }
    
    public override var icon: NSImage?
    {
        NSImage( systemSymbolName: "fork.knife", accessibilityDescription: nil )
    }
    
    public override func copy( with zone: NSZone? = nil ) -> Any
    {
        Herbivore( active: self.isActive, settings: self.settings )
    }
    
    public override func onCollision( creature: Creature, node: SKNode )
    {
        if let plant = node as? Plant, plant.isBeingRemoved == false
        {
            if let sense: PlantSense = creature.getGene(), sense.isActive
            {
                if plant.isDecayed && creature.settings.plantSense.canDetectDecayed
                {
                    return
                }
            }
            
            plant.remove()
            
            creature.energy += plant.energy
            self.meals      += 1
        }
    }
}
