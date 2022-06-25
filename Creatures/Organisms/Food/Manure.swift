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

public class Manure: Food
{
    private var plantTime: TimeInterval?
    
    public init( energy: Int, settings: Settings )
    {
        super.init( energy: energy, settings: settings, texture: "Manure", size: NSSize( width: 20, height: 20 ) )
    }
    
    public required init?( coder: NSCoder )
    {
        nil
    }
    
    public override var canDisappear: Bool
    {
        self.settings.manure.canDisappear
    }
    
    public override var disappearAfter: Int
    {
        self.settings.manure.disappearAfter
    }
    
    public override var disappearAfterRange: Int
    {
        self.settings.manure.disappearAfterRange
    }
    
    public override func initialize()
    {
        self.emit( effect: "Fly" )
    }
    
    public override func update( elapsedTime: TimeInterval )
    {
        super.update( elapsedTime: elapsedTime )
        
        if let plantTime = self.plantTime, let scene = self.scene
        {
            if plantTime <= elapsedTime, self.isAlive
            {
                let plant      = Plant( energy: self.energy, settings: self.settings )
                plant.position = self.position
                plant.alpha    = 0
                
                scene.addChild( plant )
                plant.run( SKAction.fadeIn( withDuration: 1 ) )
                
                self.willChangeValue( for: \.isAlive )
                self.remove()
                self.didChangeValue( for: \.isAlive )
            }
        }
        else if self.settings.manure.canBecomePlant
        {
            self.plantTime = elapsedTime + Double( self.settings.manure.becomePlantAfter ) + Double.random( in: 0 ... Double( self.settings.manure.becomePlantAfterRange ) )
        }
    }
}
