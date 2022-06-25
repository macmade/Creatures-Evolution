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
    
    public override var activates: [ String ]
    {
        self.settings.sex.activates
    }
    
    public override var deactivates: [ String ]
    {
        self.settings.sex.deactivates
    }
    
    public override var requires: [ String ]
    {
        self.settings.sex.requires
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
    
    private var sexNode:  SKSpriteNode?
    
    public private( set ) var lastUsed: TimeInterval?
    public private( set ) var isMale:   Bool
    public private( set ) var isFemale: Bool
    
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
                node.texture = ImageTexture.texture( named: "Sex-MF" )
            }
            else if self.isMale
            {
                node.texture = ImageTexture.texture( named: "Sex-M" )
            }
            else if self.isFemale
            {
                node.texture = ImageTexture.texture( named: "Sex-F" )
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
        
        if ReproductionHelper.canMate( creature: creature, with: other ) == false
        {
            return
        }
        
        if Double.random( in: 0 ... 100 ) > Double( self.settings.sex.chance )
        {
            return
        }
        
        let children: Int =
        {
            if scene.settings.creatures.populationLimitStrategy == .preventBirth
            {
                let count     = scene.children.compactMap( { $0 as? Creature } ).count
                let available = scene.settings.creatures.maxNumber - count
                
                return min( Int.random( in: 1 ... self.settings.sex.maxNumberOfChildren ), available )
            }
            
            return Int.random( in: 1 ... self.settings.sex.maxNumberOfChildren )
        }()
        
        if children <= 0
        {
            return
        }
        
        if self.isFemale
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
            
            for _ in 0 ..< children
            {
                let genes       = EvolutionHelper.genes( from: creature, and: other )
                let mutation    = EvolutionHelper.mutate( genes: genes, mutationChance: self.settings.sex.mutationChance )
                let copy        = Creature( energy: 1, genes: mutation.genes, parents: [ creature ], settings: self.settings )
                copy.position   = creature.position
                copy.generation = max( creature.generation, other.generation ) + 1
                
                creature.scene?.addChild( copy )
                copy.move()
                NotificationCenter.default.post( name: Constants.creatureBornNotification, object: copy )
                EventLog.shared.born( creature: copy, from: [ creature, other ] )
                
                if let event = mutation.event
                {
                    EventLog.shared.add( event: Event( message: event, time: scene.elapsedTime, node: copy ) )
                }
                
                creature.childrenCount += 1
                other.childrenCount    += 1
            }
            
            creature.emit( effect: "Heart", duration: 2 )
            other.emit(    effect: "Heart", duration: 2 )
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
