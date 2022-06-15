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

public class Plant: SpriteNode, Food, Updatable
{
    public  var energy        = 1
    public  var isAvailable   = true
    private var peremptionDate: Date?
    private var removalDate:    Date?
    
    public required init( energy: Int )
    {
        super.init( texture: SKTexture( imageNamed: "Plant" ), color: NSColor.clear, size: NSSize( width: 20, height: 20 ) )
        
        let physicsBody                = SKPhysicsBody( circleOfRadius: self.size.height / 2 )
        physicsBody.affectedByGravity  = false
        physicsBody.isDynamic          = true
        physicsBody.categoryBitMask    = Constants.foodPhysicsCategory
        
        self.physicsBody = physicsBody
        self.energy      = energy
    }
    
    public required init?( coder: NSCoder )
    {
        nil
    }
    
    public func update()
    {
        guard let scene = self.scene as? Scene else
        {
            return
        }
        
        if let peremptionDate = self.peremptionDate
        {
            if peremptionDate.timeIntervalSinceNow < 0
            {
                self.energy           = scene.settings.plants.decayEnergy
                self.colorBlendFactor = 0
                self.color            = NSColor.red
                
                self.run( SKAction.colorize( withColorBlendFactor: 0.75, duration: 1 ) )
            }
        }
        else if scene.settings.plants.canDecay
        {
            self.peremptionDate = Date( timeIntervalSinceNow: scene.settings.plants.decayAfter + Double.random( in: 0 ... scene.settings.plants.decayAfterRange ) )
        }
        
        if let removaleDate = self.removalDate
        {
            if removaleDate.timeIntervalSinceNow < 0
            {
                self.remove()
            }
        }
        else if scene.settings.plants.canDisappear
        {
            self.removalDate = Date( timeIntervalSinceNow: scene.settings.plants.disappearAfter + Double.random( in: 0 ... scene.settings.plants.disappearAfterRange ) )
        }
    }
}
