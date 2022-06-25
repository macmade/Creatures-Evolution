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
    @objc public private( set ) dynamic var settings:     Settings
    @objc public private( set ) dynamic var isGameOver  = false
    @objc public private( set ) dynamic var elapsedTime = TimeInterval( 0 )
    
    private var lastUpdateTime:         TimeInterval?
    private var lastFoodGenerationTime: TimeInterval?
    private var lastFPSCheck:           TimeInterval?
    private var frames                = 0
    private var ignoreBadPerformance  = false
    
    public var highlightedGene: AnyClass?
    {
        didSet
        {
            if self.highlightedGene == nil
            {
                self.children.forEach
                {
                    ( $0 as? Creature )?.highlight( false )
                }
            }
        }
    }
    
    public override var isPaused: Bool
    {
        didSet
        {
            self.lastUpdateTime = nil
            self.lastFPSCheck   = nil
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
        
        let backgroundImage: String? =
        {
            let index = self.settings.world.environment
            
            if index < 0 || index >= Constants.backgroundImages.count
            {
                return Constants.backgroundImages.randomElement()
            }
            
            return Constants.backgroundImages[ index ]
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
        else if event.clickCount == 2, let creature = windowController.detailViewController?.node as? Creature
        {
            creature.removeAction( forKey: Creature.moveActionKey )
            creature.run( SKAction.move( to: location, duration: 0 ) )
            {
                [ weak creature ] in creature?.move()
            }
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
    
    private func checkPerformance( _ currentTime: TimeInterval )
    {
        self.frames += 1
        
        if self.lastFPSCheck == nil
        {
            self.lastFPSCheck = currentTime
        }
        
        if let lastFPSCheck = self.lastFPSCheck, currentTime - lastFPSCheck >= 5
        {
            let fps           = Double( self.frames ) / ( currentTime - lastFPSCheck )
            self.lastFPSCheck = nil
            self.frames       = 0
            
            if fps < 15 && self.ignoreBadPerformance == false
            {
                self.performanceWarning( fps: Int( fps ) )
            }
        }
    }
    
    private func performanceWarning( fps: Int )
    {
        guard let window = self.view?.window, let controller = window.windowController as? MainWindowController else
        {
            return
        }
        
        self.isPaused = true
        
        let alert             = NSAlert()
        alert.messageText     = "Low Performance Warning"
        alert.informativeText = "The game appears to perform poorly, rendering about \( fps ) frames per second.\n\nThis might only be temporary, but the game has been paused to prevent performance issues on your computer."
        
        alert.addButton( withTitle: "Change Settings" )
        alert.addButton( withTitle: "Ignore and Continue" )
                
        alert.beginSheetModal( for: window )
        {
            if $0 == .alertFirstButtonReturn
            {
                controller.reset( nil )
            }
            else
            {
                self.isPaused             = false
                self.ignoreBadPerformance = true
            }
        }
    }
    
    public override func update( _ currentTime: TimeInterval )
    {
        super.update( currentTime )
        self.checkPerformance( currentTime )
        DistanceHelper.clearCache()
        
        if let lastUpdateTime = self.lastUpdateTime
        {
            self.elapsedTime += currentTime - lastUpdateTime
        }
        
        self.lastUpdateTime = currentTime
        
        if let lastFoodGenerationTime = self.lastFoodGenerationTime
        {
            if currentTime - lastFoodGenerationTime >= Double( self.settings.plants.renewInterval )
            {
                self.generatePlants( amount: self.settings.plants.renewAmount )
                
                self.lastFoodGenerationTime = currentTime
            }
        }
        else
        {
            self.lastFoodGenerationTime = currentTime
        }
        
        self.children.forEach
        {
            ( $0 as? SpriteNode )?.update( elapsedTime: self.elapsedTime )
            
            if let gene = self.highlightedGene, let creature = $0 as? Creature, creature.hasActiveGene( gene )
            {
                creature.highlight( true )
            }
        }
        
        let creatures = self.children.compactMap { $0 as? Creature }
        
        if creatures.count == 0
        {
            self.isGameOver = true
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
    
    public func shutDown()
    {
        self.children.forEach
        {
            ( $0 as? SpriteNode )?.shutDown()
        }
    }
    
    public func generatePlants( amount: Int )
    {
        if self.isPaused || self.settings.plants.isEnabled == false
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
