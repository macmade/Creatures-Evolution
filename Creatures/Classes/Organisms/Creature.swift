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

public class Creature: SpriteNode, Updatable
{
    private static let moveActionKey = "Move"
    
    private var nextEnergyDecrease: Date?
    
    public private( set ) var genes: [ Gene ]
    
    public var energy = 1
    {
        didSet
        {
            self.energyChanged()
        }
    }
    
    public var isBaby = true
    {
        willSet( value )
        {
            self.grow( value == false )
        }
    }
    
    public convenience init( energy: Int )
    {
        let genes: [ Gene ] = [
            Herbivore(      active: true ),
            Scavenger(      active: false ),
            Omnivore(       active: false ),
            Carnivore(      active: false ),
            Cannibal(       active: false ),
            Vampire(        active: false ),
            Mitosis(        active: true ),
            Sex(            active: false ),
            VampireSense(   active: false ),
            CarnivoreSense( active: false ),
            FoodSense(      active: false ),
        ]
        
        self.init( energy: energy, genes: genes )
    }
    
    public init( energy: Int, genes: [ Gene ] )
    {
        self.genes = genes
        
        super.init( texture: nil, color: NSColor.clear, size: NSSize( width: 15, height: 15 ) )
        
        let physicsBody                = SKPhysicsBody( circleOfRadius: self.size.height / 2 )
        physicsBody.affectedByGravity  = false
        physicsBody.isDynamic          = true
        physicsBody.contactTestBitMask = physicsBody.collisionBitMask
        physicsBody.restitution        = 0.5
        
        self.physicsBody = physicsBody
        self.energy      = energy
        
        self.updateTexture()
    }
    
    public required init?( coder: NSCoder )
    {
        nil
    }
    
    public var isHerbivore: Bool
    {
        self.isGeneActive( Herbivore.self )
    }
    
    public var isScavenger: Bool
    {
        self.isGeneActive( Scavenger.self )
    }
    
    public var isOmnivore: Bool
    {
        self.isGeneActive( Omnivore.self )
    }
    
    public var isCarnivore: Bool
    {
        self.isGeneActive( Carnivore.self )
    }
    
    public var isCannibal: Bool
    {
        self.isGeneActive( Cannibal.self )
    }
    
    public var isVampire: Bool
    {
        self.isGeneActive( Vampire.self )
    }
    
    public var canReplicate: Bool
    {
        self.isGeneActive( Mitosis.self )
    }
    
    public var canHaveSex: Bool
    {
        self.isGeneActive( Sex.self )
    }
    
    public var canDetectFood: Bool
    {
        self.isGeneActive( FoodSense.self )
    }
    
    public var canDetectCarnivore: Bool
    {
        self.isGeneActive( CarnivoreSense.self )
    }
    
    public var canDetectVampire: Bool
    {
        self.isGeneActive( VampireSense.self )
    }
    
    public func isSmallerThan( creature: Creature ) -> Bool
    {
        self.isBaby && creature.isBaby == false
    }
    
    public func isBiggerThan( creature: Creature ) -> Bool
    {
        self.isBaby == false && creature.isBaby
    }
    
    public func isGeneActive( _ kind: AnyClass ) -> Bool
    {
        for gene in self.genes
        {
            if gene.isKind( of: kind )
            {
                return gene.isActive
            }
        }
        
        return false
    }
    
    public func update()
    {
        if self.isBeingRemoved
        {
            return
        }
        
        guard let scene = self.scene as? Scene else
        {
            return
        }
        
        if let nextEnergyDecrease = self.nextEnergyDecrease
        {
            if nextEnergyDecrease.timeIntervalSinceNow < 0
            {
                self.nextEnergyDecrease = nil
                self.energy            -= 1
            }
        }
        else
        {
            self.nextEnergyDecrease = Date( timeIntervalSinceNow: scene.settings.energyDecreaseInterval + Double.random( in: 0 ... scene.settings.energyDecreaseIntervalRange ) )
        }
    }
    
    public func move()
    {
        guard let scene = self.scene else
        {
            return
        }
        
        var destination = self.chooseDestination()
        
        while scene.frame.contains( destination.point ) == false
        {
            destination = self.chooseDestination()
        }
        
        let moveX      = SKAction.moveTo( x: destination.point.x, duration: 0.025 * Double( destination.distance ) )
        let moveY      = SKAction.moveTo( y: destination.point.y, duration: 0.025 * Double( destination.distance ) )
        let move       = SKAction.group( [ moveX, moveY ] )
        let completion = SKAction.run
        {
            self.move()
        }
        
        self.run( SKAction.sequence( [ move, completion ] ), withKey: Creature.moveActionKey )
    }
    
    public func chooseDestination() -> ( point: NSPoint, distance: Int )
    {
        let distance  = Int.random( in: 10 ... 100 )
        let distanceX = distance - Int.random( in: 0 ... distance )
        let distanceY = distance - distanceX
        let positionX = self.position.x + Double( Bool.random() ? distanceX : -distanceX )
        let positionY = self.position.y + Double( Bool.random() ? distanceY : -distanceY )
        
        return ( point: NSPoint( x: positionX, y: positionY ), distance: distance )
    }
    
    public func collide( with node: SKNode )
    {
        if self.isBeingRemoved
        {
            return
        }
        
        for gene in self.genes
        {
            if gene.isActive
            {
                gene.onCollision( creature: self, node: node )
            }
        }
        
        if let food = node as? Food, food.isBeingRemoved
        {
            return
        }
        
        if let creature = node as? Creature, creature.isBeingRemoved
        {
            return
        }
        
        self.removeAction( forKey: Creature.moveActionKey )
        self.move()
    }
    
    private func energyChanged()
    {
        if self.isBeingRemoved
        {
            return
        }
        
        for gene in self.genes
        {
            if gene.isActive
            {
                gene.onEnergyChanged( creature: self )
            }
        }
        
        if self.energy == -1
        {
            self.die( dropFood: true )
        }
        else if self.energy == 0
        {
            self.flash( true )
        }
        else
        {
            self.flash( false )
        }
        
        guard let scene = self.scene as? Scene else
        {
            return
        }
        
        if self.isBaby && self.energy >= scene.settings.energyNeededToGrow
        {
            self.isBaby  = false
            self.energy -= scene.settings.growthEnergyCost
        }
    }
    
    public func die( dropFood: Bool )
    {
        self.removeAction( forKey: Creature.moveActionKey )
        
        if dropFood
        {
            let meat      = Meat( energy: self.isBaby ? 1 : 2 )
            meat.position = self.position
            meat.alpha    = 0
            
            self.scene?.addChild( meat )
            meat.run( SKAction.fadeIn( withDuration: 1 ) )
        }
        
        self.remove()
    }
    
    public func fight( other: Creature ) -> Bool
    {
        if self.isBeingRemoved
        {
            return false
        }
        
        guard let scene = self.scene as? Scene else
        {
            return false
        }
        
        let chance: Int =
        {
            if self.isSmallerThan( creature: other )
            {
                return scene.settings.combatChanceIfSmaller
            }
            else if self.isBiggerThan( creature: other )
            {
                return scene.settings.combatChanceIfBigger
            }
            
            return scene.settings.combatChanceIfSameSize
        }()
        
        return Int.random( in: 0 ... 100 ) <= chance
    }
    
    private func grow( _ grow: Bool )
    {
        if self.isBeingRemoved
        {
            return
        }
        
        if grow && self.isBaby == false
        {
            return
        }
        
        if grow == false && self.isBaby
        {
            return
        }
        
        if grow
        {
            self.run( SKAction.scale( to: NSSize( width: 30, height: 30 ), duration: 1 ) )
        }
        else
        {
            self.run( SKAction.scale( to: NSSize( width: 15, height: 15 ), duration: 0.5 ) )
        }
    }
    
    private func updateTexture()
    {
        if self.isVampire
        {
            self.texture = SKTexture( imageNamed: "Vampire" )
        }
        else if self.isCarnivore
        {
            self.texture = SKTexture( imageNamed: "Carnivore" )
        }
        else if self.isOmnivore
        {
            self.texture = SKTexture( imageNamed: "Omnivore" )
        }
        else if self.isScavenger
        {
            self.texture = SKTexture( imageNamed: "Scavenger" )
        }
        else if self.isHerbivore
        {
            self.texture = SKTexture( imageNamed: "Herbivore" )
        }
        else
        {
            self.texture = SKTexture( imageNamed: "Basic" )
        }
    }
}
