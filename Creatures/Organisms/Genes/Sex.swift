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

public class Sex: Gene
{
    public override var canRegress: Bool
    {
        self.settings.sex.canRegress
    }
    
    public override var deactivates: [ String ]
    {
        self.settings.sex.deactivates
    }
    
    public override var name: String
    {
        "Sex"
    }
    
    public override var details: String?
    {
        if self.isMale && self.isFemale
        {
            return "Hermaphrodite"
        }
        
        return self.isMale ? "Male" : "Female"
    }
    
    public override var icon: NSImage?
    {
        NSImage( systemSymbolName: "heart.fill", accessibilityDescription: nil )
    }
    
    public override var canToggleValue: Bool
    {
        true
    }
    
    private var lastUsed: TimeInterval?
    private var sexNode:  SKSpriteNode?
    private var isMale:   Bool
    private var isFemale: Bool
    
    public override init( active: Bool, settings: Settings )
    {
        let sex = Int.random( in: 0 ... 2 )
        
        self.isMale   = sex == 0 || sex == 2
        self.isFemale = sex == 1 || sex == 2
        
        super.init( active: active, settings: settings )
    }
    
    public override func copy( with zone: NSZone? = nil ) -> Any
    {
        Sex( active: self.isActive, settings: self.settings )
    }
    
    public override func onUpdate( creature: Creature )
    {
        if self.sexNode == nil
        {
            let node = SKSpriteNode( texture: nil, color: NSColor.clear, size: NSSize( width: 8, height: 8 ) )
            
            if self.isMale && self.isFemale
            {
                node.texture = SKTexture( imageNamed: "Sex-MF" )
            }
            else if self.isMale
            {
                node.texture = SKTexture( imageNamed: "Sex-M" )
            }
            else if self.isFemale
            {
                node.texture = SKTexture( imageNamed: "Sex-F" )
            }
            
            node.position = NSPoint( x: -2, y: -21 )
            self.sexNode  = node
            
            creature.addChild( node )
        }
    }
    
    public override func onCollision( creature: Creature, node: SKNode )
    {
        guard let scene = creature.scene as? Scene else
        {
            return
        }
        
        guard let other = node as? Creature else
        {
            return
        }
        
        guard let sex1 = creature.getGene( Sex.self ) as? Sex, let sex2 = other.getGene( Sex.self ) as? Sex else
        {
            return
        }
        
        guard sex1.isActive, sex2.isActive else
        {
            return
        }
        
        if creature.isBaby || other.isBaby
        {
            return
        }
        
        if creature.energy < self.settings.sex.energyNeeded || other.energy < self.settings.sex.energyNeeded
        {
            return
        }
        
        if creature.energy < self.settings.sex.energyCost || other.energy < self.settings.sex.energyCost
        {
            return
        }
        
        if let lastUsed = self.lastUsed, lastUsed + self.settings.mitosis.recoveryTime > scene.elapsedTime
        {
            return
        }
        
        if Double.random( in: 0 ... 100 ) > self.settings.sex.chance
        {
            return
        }
        
        if sex1.isFemale && sex2.isMale
        {
            self.lastUsed    = scene.elapsedTime
            creature.energy -= self.settings.sex.energyCost
            other.energy    -= self.settings.sex.energyCost
            
            if creature.energy < self.settings.creatures.energyNeededToGrow
            {
                creature.isBaby = true
            }
            
            if other.energy < self.settings.creatures.energyNeededToGrow
            {
                other.isBaby = true
            }
            
            for _ in 0 ..< self.settings.sex.possibleNumberOfChildren
            {
                let mutation = EvolutionHelper.mutate( genes: creature.genes, mutationChance: self.settings.sex.mutationChance )
                let copy      = Creature( energy: 1, genes: mutation.genes, parents: [ creature ], settings: self.settings )
                copy.position = creature.position
                
                creature.scene?.addChild( copy )
                copy.move()
                NotificationCenter.default.post( name: Constants.creatureBornNotification, object: copy )
                EventLog.shared.born( creature: copy, from: [ creature, other ] )
                
                if let event = mutation.event
                {
                    EventLog.shared.add( event: Event( message: event, time: scene.elapsedTime, node: copy ) )
                }
            }
        }
    }
    
    public override func toggleValue()
    {
        self.willChangeValue( for: \.details )
        
        if self.isMale && self.isFemale
        {
            self.isMale   = true
            self.isFemale = false
        }
        else if self.isMale
        {
            self.isMale   = false
            self.isFemale = true
        }
        else if self.isFemale
        {
            self.isMale   = true
            self.isFemale = true
        }
        
        self.sexNode?.removeFromParent()
        
        self.sexNode = nil
        
        self.didChangeValue( for: \.details )
    }
}
