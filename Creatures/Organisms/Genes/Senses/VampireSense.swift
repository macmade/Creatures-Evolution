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

public class VampireSense: IntValueGene
{
    public override var canRegress: Bool
    {
        self.settings.vampireSense.canRegress
    }
    
    public override var activates: [ String ]
    {
        self.settings.vampireSense.activates
    }
    
    public override var deactivates: [ String ]
    {
        self.settings.vampireSense.deactivates
    }
    
    public override var requires: [ String ]
    {
        self.settings.vampireSense.requires
    }
    
    public override var name: String
    {
        "Vampire Sense"
    }
    
    public override var icon: NSImage?
    {
        NSImage( systemSymbolName: "sensor.tag.radiowaves.forward.fill", accessibilityDescription: nil )
    }
    
    public override var defaultValue:          Int { self.settings.vampireSense.defaultDistance }
    public override var defaultValueRange:     Int { self.settings.vampireSense.defaultDistanceRange }
    public override var minimumValue:          Int { self.settings.vampireSense.minimumDistance }
    public override var maximumValue:          Int { self.settings.vampireSense.maximumDistance }
    public override var minimumMutationChange: Int { self.settings.vampireSense.minimumMutationChange }
    public override var maximumMutationChange: Int { self.settings.vampireSense.maximumMutationChange }
    
    public override func copy( with zone: NSZone? = nil ) -> Any
    {
        VampireSense( active: self.isActive, settings: self.settings, value: self.value )
    }
    
    public override func chooseDestination( creature: Creature ) -> Destination?
    {
        let predicate: ( Creature ) -> Bool =
        {
            $0.hasActiveGene( Vampire.self ) && PredationHelper.canBeEaten( creature: creature, by: $0 )
        }
        
        if let nearest: Creature = DistanceHelper.nearestObject( creature: creature, maxDistance: Double( self.value ), predicate: predicate )
        {
            return Destination( point: DistanceHelper.opposite( of: nearest.position, from: creature.position ), priority: .high )
        }
        
        return nil
    }
}
