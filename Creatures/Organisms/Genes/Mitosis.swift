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

public class Mitosis: NSObject, Gene
{
    public var isActive: Bool
    
    public var canRegress: Bool
    {
        self.settings.mitosis.canRegress
    }
    
    public var deactivates: [ String ]
    {
        get
        {
            self.settings.mitosis.deactivates
        }
    }
    
    public var name: String
    {
        "Mitosis"
    }
    
    public override var description: String
    {
        self.name
    }
    
    public var details: String?
    {
        nil
    }
    
    public var icon: NSImage?
    {
        NSImage( systemSymbolName: "heart.fill", accessibilityDescription: nil )
    }
    
    private var lastUsed: TimeInterval?
    
    @objc public private( set ) dynamic var settings: Settings
    
    public required init( active: Bool, settings: Settings )
    {
        self.isActive = active
        self.settings = settings
    }
    
    public func copy( with zone: NSZone? = nil ) -> Any
    {
        Mitosis( active: self.isActive, settings: self.settings )
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
    
    public func onEnergyChanged( creature: Creature )
    {
        guard let scene = creature.scene as? Scene else
        {
            return
        }
        
        if creature.isBaby
        {
            return
        }
        
        if creature.energy < self.settings.mitosis.energyNeeded
        {
            return
        }
        
        if creature.energy < self.settings.mitosis.energyCost
        {
            return
        }
        
        if let lastUsed = self.lastUsed, lastUsed + self.settings.mitosis.recoveryTime > scene.elapsedTime 
        {
            return
        }
        
        if Double.random( in: 0 ... 100 ) > self.settings.mitosis.chance
        {
            return
        }
        
        self.lastUsed    = scene.elapsedTime
        creature.energy -= self.settings.mitosis.energyCost
        
        if creature.energy < self.settings.creatures.energyNeededToGrow
        {
            creature.isBaby = true
        }
        
        let mutation  = EvolutionHelper.mutate( genes: creature.genes, mutationChance: self.settings.mitosis.mutationChance )
        let copy      = Creature( energy: 1, genes: mutation.genes, parents: [ creature ], settings: self.settings )
        copy.position = creature.position
        
        creature.scene?.addChild( copy )
        copy.move()
        NotificationCenter.default.post( name: Constants.creatureBornNotification, object: copy )
        EventLog.shared.born( creature: copy, from: [ creature ] )
        
        if let event = mutation.event
        {
            EventLog.shared.add( event: Event( message: event, time: scene.elapsedTime, node: copy ) )
        }
    }
    
    public func onCollision( creature: Creature, node: SKNode )
    {}
    
    public func chooseDestination( creature: Creature ) -> Destination?
    {
        nil
    }
}
