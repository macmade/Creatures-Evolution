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

public class Creature: SpriteNode
{
    public  static let growActionKey = "Grow"
    public  static let moveActionKey = "Move"
    private static var index         = UInt64( 0 )
    
          public private( set ) dynamic var genes:         [ Gene ]
    @objc public private( set ) dynamic var settings:      Settings
    @objc public                dynamic var childrenCount: Int          = 0
    
    private var nextEnergyDecrease: TimeInterval?
    
    @objc public dynamic var customName: String?
    {
        didSet
        {
            self.updateCustomName()
        }
    }
    
    @objc public dynamic var energy = 1
    {
        didSet
        {
            self.energyChanged()
        }
    }
    
    @objc public dynamic var isBaby = true
    {
        willSet( value )
        {
            self.grow( value == false )
        }
    }
    
    @objc public dynamic var isAlive: Bool
    {
        get
        {
            self.isBeingRemoved == false && self.scene != nil
        }
    }
    
    private var parents:         [ Weak< Creature > ]?
    private var customNameLabel: LabelNode?
    
    public convenience init( energy: Int, settings: Settings )
    {
        self.init( energy: energy, genes: EvolutionHelper.defaultGenes( settings: settings ), settings: settings )
    }
    
    public convenience init( energy: Int, genes: [ Gene ], settings: Settings )
    {
        self.init( energy: energy, genes: genes, parents: nil, settings: settings )
    }
    
    public init( energy: Int, genes: [ Gene ], parents: [ Creature ]?, settings: Settings )
    {
        self.genes    = genes
        self.settings = settings
        self.parents  = parents?.map{ Weak( value: $0 ) }
        
        super.init( texture: nil, color: NSColor.clear, size: NSSize( width: 40, height: 40 ) )
        
        let physicsBody                = SKPhysicsBody( circleOfRadius: self.size.height / 2 )
        physicsBody.affectedByGravity  = false
        physicsBody.isDynamic          = true
        physicsBody.categoryBitMask    = Constants.organismPhysicsCategory
        physicsBody.contactTestBitMask = physicsBody.collisionBitMask
        physicsBody.restitution        = 0.5
        
        self.physicsBody  = physicsBody
        self.energy       = energy
        self.name         = String( format: "%010X", Creature.index )
        Creature.index   += 1
        
        if settings.creatures.generateRandomNames
        {
            self.customName = NameGenerator.shared.generate( range: 4 ... 8 )
        }
        
        self.updateTexture()
    }
    
    public required init?( coder: NSCoder )
    {
        nil
    }
    
    public func isSmallerThan( creature: Creature ) -> Bool
    {
        self.isBaby && creature.isBaby == false
    }
    
    public func isBiggerThan( creature: Creature ) -> Bool
    {
        self.isBaby == false && creature.isBaby
    }
    
    public func isChild( of creature: Creature ) -> Bool
    {
        for parent in self.parents ?? []
        {
            if parent.value == creature
            {
                return true
            }
        }
        
        return false
    }
    
    public func isParentOf( of creature: Creature ) -> Bool
    {
        return creature.isChild( of: self )
    }
    
    public func isSibling( of creature: Creature ) -> Bool
    {
        for parent1 in self.parents ?? []
        {
            for parent2 in creature.parents ?? []
            {
                if parent1.value == parent2.value
                {
                    return true
                }
            }
        }
        
        return false
    }
    
    public func isRelated( to creature: Creature ) -> Bool
    {
        return self.isChild( of: creature ) || self.isParentOf( of: creature ) || self.isSibling( of: creature )
    }
    
    public func hasActiveGene( _ kind: AnyClass ) -> Bool
    {
        self.getGene( kind )?.isActive ?? false
    }
    
    public func getGene( _ kind: AnyClass ) -> Gene?
    {
        return self.genes.first { $0.isKind( of: kind ) }
    }
    
    public func getGene< T: Gene >() -> T?
    {
        return self.getGene( T.self ) as? T
    }
    
    public override func initialize()
    {
        super.initialize()
        
        if self.isBaby
        {
            self.run( SKAction.scale( to: NSSize( width: 20, height: 20 ), duration: 0 ) )
        }
    }
    
    public override func update( elapsedTime: TimeInterval )
    {
        super.update( elapsedTime: elapsedTime )
        
        if self.settings.world.showCreaturesNames
        {
            self.showCustomName()
        }
        else if self.isHighlighted == false
        {
            self.hideCustomName()
        }
        
        if self.isBeingRemoved
        {
            return
        }
        
        if let nextEnergyDecrease = self.nextEnergyDecrease
        {
            if nextEnergyDecrease <= elapsedTime
            {
                self.nextEnergyDecrease = nil
                self.energy            -= self.settings.creatures.energyDecreaseAmount
            }
        }
        else
        {
            self.nextEnergyDecrease = elapsedTime + Double( self.settings.creatures.energyDecreaseInterval ) + Double.random( in: 0 ... Double( self.settings.creatures.energyDecreaseIntervalRange ) )
        }
        
        self.genes.filter{ $0.isActive }.forEach
        {
            $0.onUpdate( creature: self )
        }
    }
    
    public func move()
    {
        let destination = self.chooseDestination() ?? self.randomDestination()
        let distance    = destination.point.distance( with: self.position )
        let duration    = 0.025 * Double( distance )
        var multiplier  = 1.0
        
        if let speed = self.getGene( Speed.self ) as? Speed, speed.isActive
        {
            multiplier = speed.value
        }
        
        let moveX      = SKAction.moveTo( x: destination.point.x, duration: duration / multiplier )
        let moveY      = SKAction.moveTo( y: destination.point.y, duration: duration / multiplier )
        let move       = SKAction.group( [ moveX, moveY ] )
        let completion = SKAction.run
        {
            [ weak self ] in self?.move()
        }
        
        self.run( SKAction.sequence( [ move, completion ] ), withKey: Creature.moveActionKey )
    }
    
    private func chooseDestination() -> Destination?
    {
        let destinations: [ Destination ] = self.genes.filter{ $0.isActive }.compactMap
        {
            $0.chooseDestination( creature: self )
        }
        
        let high   = destinations.filter { $0.priority == .high }
        let normal = destinations.filter { $0.priority == .normal }
        
        if high.isEmpty
        {
            return normal.randomElement()
        }
        
        return high.randomElement()
    }
    
    private func randomDestination() -> Destination
    {
        guard let scene = self.scene else
        {
            return Destination( point: self.position, priority: .normal )
        }
        
        var point = NSPoint( x: Double.infinity, y: Double.infinity )
        
        while scene.frame.contains( point ) == false
        {
            let distance  = Int.random( in: 10 ... 100 )
            let distanceX = distance - Int.random( in: 0 ... distance )
            let distanceY = distance - distanceX
            let positionX = self.position.x + Double( Bool.random() ? distanceX : -distanceX )
            let positionY = self.position.y + Double( Bool.random() ? distanceY : -distanceY )
            
            point = NSPoint( x: positionX, y: positionY )
        }
        
        return Destination( point: point, priority: .normal )
    }
    
    public func collide( with node: SKNode )
    {
        if self.isBeingRemoved
        {
            return
        }
        
        self.genes.filter { $0.isActive }.forEach
        {
            $0.onCollision( creature: self, node: node )
        }
        
        if let food = node as? Food, food.isBeingRemoved
        {
            return
        }
        
        if let creature = node as? Creature, creature.isBeingRemoved
        {
            return
        }
        
        if let cat1 = self.physicsBody?.categoryBitMask,
           let cat2 = node.physicsBody?.categoryBitMask,
           cat1 == cat2
        {
            self.removeAction( forKey: Creature.moveActionKey )
            self.move()
        }
    }
    
    private func energyChanged()
    {
        if self.isBeingRemoved
        {
            return
        }
        
        self.genes.filter { $0.isActive }.forEach
        {
            $0.onEnergyChanged( creature: self )
        }
        
        if self.energy == -1
        {
            self.die( dropFood: true )
            EventLog.shared.died( creature: self )
        }
        else if self.energy == 0
        {
            self.flash( true )
        }
        else
        {
            self.flash( false )
        }
        
        if self.isBaby && self.energy >= self.settings.creatures.energyNeededToGrow
        {
            self.isBaby  = false
            self.energy -= self.settings.creatures.growthEnergyCost
        }
    }
    
    public func die( dropFood: Bool )
    {
        if let scene = self.scene, let emitter = SKEmitterNode( fileNamed: "Skull" )
        {
            emitter.position  = self.position
            emitter.zPosition = CGFloat.infinity
            let emit          = SKAction.run { scene.addChild( emitter ) }
            let wait          = SKAction.wait( forDuration: 2 )
            
            self.run( SKAction.sequence( [ emit, wait ] ) )
            {
                emitter.removeFromParent()
            }
        }
        
        self.removeAction( forKey: Creature.moveActionKey )
        
        if dropFood && self.settings.meat.isEnabled
        {
            let energy    = self.energy > 0 ? self.energy : 1
            let meat      = Meat( energy: energy, settings: self.settings )
            meat.position = self.position
            meat.alpha    = 0
            
            self.scene?.addChild( meat )
            meat.run( SKAction.fadeIn( withDuration: 1 ) )
        }
        
        self.willChangeValue( for: \.isAlive )
        self.remove()
        self.didChangeValue( for: \.isAlive )
        
        NotificationCenter.default.post( name: Constants.creatureDieNotification, object: self )
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
        
        self.removeAction( forKey: Creature.growActionKey )
        
        let size       = grow ? NSSize( width: 40, height: 40 ) : NSSize( width: 20, height: 20 )
        let scale      = SKAction.scale( to: size, duration: 1 )
        let completion = SKAction.run { [ weak self ] in self?.updateCustomName() }
        let sequence   = grow ? [ completion, scale ] : [ scale, completion ]
        
        self.run( SKAction.sequence( sequence ), withKey: Creature.growActionKey )
    }
    
    public func updateTexture()
    {
        if self.hasActiveGene( Vampire.self )
        {
            self.texture = SKTexture( imageNamed: "Vampire" )
        }
        else if self.hasActiveGene( Predator.self )
        {
            self.texture = SKTexture( imageNamed: "Predator" )
        }
        else if self.hasActiveGene( Scavenger.self )
        {
            self.texture = SKTexture( imageNamed: "Scavenger" )
        }
        else if self.hasActiveGene( Herbivore.self )
        {
            self.texture = SKTexture( imageNamed: "Herbivore" )
        }
        else
        {
            self.texture = SKTexture( imageNamed: "Basic" )
        }
    }
    
    private func updateCustomName()
    {
        if let name = self.customName, name.isEmpty == false
        {
            if self.isBaby
            {
                self.customNameLabel?.update( text: name, fontSize: 24, shadowOffset: NSPoint( x: 2, y: -2 ) )
                
                self.customNameLabel?.position = NSPoint( x: 0, y: 30 )
            }
            else
            {
                self.customNameLabel?.update( text: name, fontSize: 12, shadowOffset: NSPoint( x: 1, y: -1 ) )
                
                self.customNameLabel?.position = NSPoint( x: 0, y: 25 )
            }
        }
        else
        {
            self.hideCustomName()
        }
    }
    
    private func showCustomName()
    {
        if let _ = self.customNameLabel
        {
            return
        }
        
        guard let name = self.customName, name.isEmpty == false else
        {
            return
        }
        
        let label            = LabelNode( text: name, fontName: nil, fontSize: 24, textColor: NSColor.white, shadowColor: NSColor.black, shadowOffset: NSPoint( x: 1, y: -1 ) )
        label.position       = NSPoint( x: 0, y: 25 )
        label.zPosition      = 1
        self.customNameLabel = label
        
        self.addChild( label )
        self.updateCustomName()
    }
    
    private func hideCustomName()
    {
        self.customNameLabel?.removeFromParent()
        
        self.customNameLabel = nil
    }
    
    public override func toggleHighlight()
    {
        self.toggleHighlight( radius: 25 )
    }
    
    public override func highlight( _ flag: Bool )
    {
        self.highlight( flag, radius: 25 )
    }
    
    public override func highlight( _ flag: Bool, radius: Double )
    {
        super.highlight( flag, radius: radius )
        
        if self.settings.world.showCreaturesNames
        {
            return
        }
        
        if flag
        {
            self.showCustomName()
        }
        else
        {
            self.hideCustomName()
        }
    }
}
