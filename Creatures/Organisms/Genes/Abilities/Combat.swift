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

public class Combat: DoubleValueGene
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
    
    public override var icon: NSImage?
    {
        NSImage( systemSymbolName: "shield.fill", accessibilityDescription: nil )
    }
    
    public override var defaultValue:          Double { self.settings.combat.defaultMultiplier }
    public override var minimumValue:          Double { self.settings.combat.minimumMultiplier }
    public override var maximumValue:          Double { self.settings.combat.maximumMultiplier }
    public override var minimumMutationChange: Double { self.settings.combat.minimumMutationChange }
    public override var maximumMutationChange: Double { self.settings.combat.maximumMutationChange }
    
    public override func copy( with zone: NSZone? = nil ) -> Any
    {
        Combat( active: self.isActive, settings: self.settings, value: self.value )
    }
}
