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

public class Gene: NSObject, NSCopying
{
    @objc public                dynamic var isActive: Bool
    @objc public private( set ) dynamic var settings: Settings
    
    @objc public var canRegress: Bool
    {
        false
    }
    
    @objc public var deactivates: [ String ]
    {
        []
    }
    
    @objc public var name: String
    {
        ""
    }
    
    @objc public var details: String?
    {
        nil
    }
    
    @objc public var icon: NSImage?
    {
        nil
    }
    
    @objc public var canToggleValue: Bool
    {
        false
    }
    
    @objc public var canIncreaseOrDecreaseValue: Bool
    {
        false
    }
    
    public override var description: String
    {
        let name = self.name
        
        return name.isEmpty ? super.description : name
    }
    
    public init( active: Bool, settings: Settings )
    {
        self.isActive = active
        self.settings = settings
    }
    
    public func copy( with zone: NSZone? = nil ) -> Any
    {
        fatalError( "Not implemented" )
    }
    
    public func mutate() -> Bool
    {
        if self.canRegress == false && self.isActive
        {
            return false
        }
        
        self.isActive = self.isActive == false
        
        return true
    }
    
    public func onUpdate( creature: Creature )
    {}
    
    public func onEnergyChanged( creature: Creature )
    {}
    
    public func onCollision( creature: Creature, node: SKNode )
    {}
    
    public func chooseDestination( creature: Creature ) -> Destination?
    {
        nil
    }
    
    @objc public func toggleValue()
    {}
    
    @objc public func increaseValue()
    {}
    
    @objc public func decreaseValue()
    {}
}
