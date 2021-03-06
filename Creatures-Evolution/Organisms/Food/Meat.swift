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

public class Meat: Food
{
    public init( energy: Double, settings: Settings )
    {
        super.init( energy: energy, settings: settings, texture: "Meat-\( Int.random( in: 1 ... 3 ) )" )
    }
    
    public required init?( coder: NSCoder )
    {
        nil
    }
    
    public override var decayEnergy: Double
    {
        Double( self.settings.meat.decayEnergy )
    }
    
    public override var canDecay: Bool
    {
        self.settings.meat.canDecay
    }
    
    public override var decayAfter: Int
    {
        self.settings.meat.decayAfter
    }
    
    public override var decayAfterRange: Int
    {
        self.settings.meat.decayAfterRange
    }
    
    public override var canDisappear: Bool
    {
        self.settings.meat.canDisappear
    }
    
    public override var disappearAfter: Int
    {
        self.settings.meat.disappearAfter
    }
    
    public override var disappearAfterRange: Int
    {
        self.settings.meat.disappearAfterRange
    }
}
