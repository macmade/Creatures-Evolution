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

public class Scene: SKScene, SKPhysicsContactDelegate
{
    @objc public private( set ) dynamic var settings: Settings
    
    private var newFoodTimer: Timer?
    
    @objc public private( set ) dynamic var gameOver: Bool = false
    {
        didSet
        {
            if let controller = self.view?.window?.windowController as? MainWindowController
            {
                controller.isPaused = true
                
                controller.hideDetails( nil )
            }
        }
    }
    
    public init( size: CGSize, settings: Settings )
    {
        self.settings = settings
        
        super.init( size: size )
    }
    
    public required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func didMove( to view: SKView )
    {
        super.didMove( to: view )
        
        self.physicsBody                  = SKPhysicsBody( edgeLoopFrom: self.frame )
        self.isUserInteractionEnabled     = true
        self.physicsWorld.contactDelegate = self
        
        self.reset()
    }
    
    public override func mouseDown( with event: NSEvent )
    {
        guard let windowController = self.view?.window?.windowController as? MainWindowController else
        {
            return
        }
        
        let location = event.location( in: self )
        let node     = self.atPoint( location )
        
        if let creature = node as? Creature ?? node.parent as? Creature
        {
            if event.modifierFlags.contains( .command )
            {
                creature.toggleHighlight()
            }
            else
            {
                windowController.showDetails( node: creature )
            }
        }
        else if let food = node as? Food ?? node.parent as? Food
        {
            windowController.showDetails( node: food )
        }
    }
    
    public override func keyDown( with event: NSEvent )
    {
        if event.keyCode == 49 /* Space */
        {
            if let controller = self.view?.window?.windowController as? MainWindowController
            {
                controller.togglePause( nil )
            }
        }
        else
        {
            super.keyDown( with: event )
        }
    }
    
    public override func update( _ currentTime: TimeInterval )
    {
        super.update( currentTime )
        
        for child in self.children
        {
            ( child as? Updatable )?.update()
        }
        
        let creatures = self.children.compactMap { $0 as? Creature }
        
        if creatures.count == 0
        {
            self.gameOver = true
        }
    }
    
    public func reset()
    {
        self.newFoodTimer?.invalidate()
        self.removeAllChildren()
        
        let backgroundImage: String? =
        {
            let backgroundImages = [ "beach", "desert", "forrest", "moss", "sand", "stones", "wood" ]
            let index            = self.settings.world.environment
            
            if index < 0 || index >= backgroundImages.count
            {
                return backgroundImages.randomElement()
            }
            
            return backgroundImages[ index ]
        }()
        
        if let backgroundImage = backgroundImage
        {
            let background         = SKSpriteNode( imageNamed: backgroundImage )
            background.position    = NSPoint( x: 0, y: 0 )
            background.anchorPoint = NSPoint( x: 0, y: 0 )
            background.size        = self.size
            
            self.addChild( background )
        }
        
        self.generatePlants(    amount: self.settings.plants.initialAmount )
        self.generateCreatures( amount: self.settings.creatures.initialAmount )
        
        self.newFoodTimer = Timer.scheduledTimer( withTimeInterval: self.settings.plants.renewInterval, repeats: true )
        {
            _ in self.generatePlants( amount: self.settings.plants.renewAmount )
        }
    }
    
    public func didBegin( _ contact: SKPhysicsContact )
    {
        if let creature1 = contact.bodyA.node as? Creature, let creature2 = contact.bodyB.node as? Creature
        {
            if Bool.random()
            {
                creature1.collide( with: creature2 )
                creature2.collide( with: creature1 )
            }
            else
            {
                creature2.collide( with: creature1 )
                creature1.collide( with: creature2 )
            }
        }
        else
        {
            if let creature = contact.bodyA.node as? Creature, let other = contact.bodyB.node
            {
                creature.collide( with: other )
            }
            
            if let creature = contact.bodyB.node as? Creature, let other = contact.bodyA.node
            {
                creature.collide( with: other )
            }
        }
    }
    
    public func generatePlants( amount: Int )
    {
        if self.isPaused
        {
            return
        }
        
        for _ in 0 ..< amount
        {
            let plant      = Plant( energy: 1, settings: self.settings )
            plant.position = self.randomPoint()
            plant.alpha    = 0
            
            self.addChild( plant )
            plant.run( SKAction.fadeIn( withDuration: 1 ) )
        }
    }
    
    public func generateCreatures( amount: Int )
    {
        for _ in 0 ..< amount
        {
            let creature      = Creature( energy: self.settings.creatures.initialEnergy, settings: self.settings )
            creature.position = self.randomPoint()
            creature.alpha    = 0
            
            self.addChild( creature )
            creature.run( SKAction.fadeIn( withDuration: 1 ) )
            creature.move()
        }
    }
    
    public func randomPoint() -> NSPoint
    {
        NSPoint( x: Double.random( in: 0 ..< self.frame.size.width ), y: Double.random( in: 0 ..< self.frame.size.height ) )
    }
}
