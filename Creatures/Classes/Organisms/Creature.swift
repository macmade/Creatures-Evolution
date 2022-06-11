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

public class Creature: SKSpriteNode, Updatable
{
    private static let moveActionKey  = "Move"
    private static let flashActionKey = "Flash"
    
    public private( set ) var genes: [ Gene ] = [
        Herbivore(      active: true ),
        Scavenger(      active: false ),
        Carnivore(      active: false ),
        Cannibal(       active: false ),
        Vampire(        active: false ),
        Mitosis(        active: true ),
        Sex(            active: false ),
        VampireSense(   active: false ),
        CarnivoreSense( active: false ),
        FoodSense(      active: false ),
    ]
    
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
    
    public init( energy: Int )
    {
        super.init( texture: SKTexture( imageNamed: "Herbivore" ), color: NSColor.clear, size: NSSize( width: 15, height: 15 ) )
        
        let physicsBody                = SKPhysicsBody( circleOfRadius: self.size.height / 2 )
        physicsBody.affectedByGravity  = false
        physicsBody.isDynamic          = true
        physicsBody.contactTestBitMask = physicsBody.collisionBitMask
        physicsBody.restitution        = 0.5
        
        self.physicsBody = physicsBody
        self.energy      = energy
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
    {}
    
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
        for gene in self.genes
        {
            if gene.isActive
            {
                gene.onCollision( creature: self, node: node )
            }
        }
        
        self.removeAction( forKey: Creature.moveActionKey )
        self.move()
    }
    
    private func energyChanged()
    {
        for gene in self.genes
        {
            if gene.isActive
            {
                gene.onEnergyChanged( creature: self )
            }
        }
        
        if self.energy == -1
        {
            self.die()
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
    
    private func die()
    {
        self.physicsBody = nil
        
        self.removeAction( forKey: Creature.moveActionKey )
        
        let meat      = Meat( energy: self.isBaby ? 1 : 2 )
        meat.position = self.position
        meat.alpha    = 0
            
        self.scene?.addChild( meat )
        meat.run( SKAction.fadeIn( withDuration: 1 ) )
        self.run( SKAction.fadeOut( withDuration: 0.5 ) )
        {
            self.scene?.removeChildren( in: [ self ] )
        }
    }
    
    private func flash( _ flash: Bool )
    {
        self.alpha = 1
        
        if flash && self.action( forKey: Creature.flashActionKey ) == nil
        {
            let fadeOut = SKAction.fadeOut( withDuration: 0.5 )
            let fadeIn  = SKAction.fadeIn(  withDuration: 0.5 )
            let flash   = SKAction.sequence( [ fadeOut, fadeIn ] )
            let group   = SKAction.repeatForever( flash )
            
            self.run( group, withKey: Creature.flashActionKey )
        }
        else
        {
            self.removeAction( forKey: Creature.flashActionKey )
        }
    }
    
    private func grow( _ grow: Bool )
    {
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
}
