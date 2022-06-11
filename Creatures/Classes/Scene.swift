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
    @objc public private( set ) dynamic var settings = Settings()
    
    private var newFoodTimer: Timer?
    
    public override func didMove( to view: SKView )
    {
        super.didMove( to: view )
        
        self.backgroundColor              = NSColor.lightGray
        self.physicsBody                  = SKPhysicsBody( edgeLoopFrom: self.frame )
        self.isUserInteractionEnabled     = true
        self.physicsWorld.contactDelegate = self
        
        self.reset()
    }
    
    public override func update( _ currentTime: TimeInterval )
    {
        super.update( currentTime )
        
        for child in self.children
        {
            ( child as? Updatable )?.update()
        }
    }
    
    public func reset()
    {
        self.newFoodTimer?.invalidate()
        self.removeAllChildren()
        
        self.generatePlants(    amount: self.settings.initialPlantCount )
        self.generateCreatures( amount: self.settings.initialCreatureCount )
        
        self.newFoodTimer = Timer.scheduledTimer( withTimeInterval: self.settings.newPlantInterval, repeats: true )
        {
            _ in self.generatePlants( amount: self.settings.newPlantAmount )
        }
    }
    
    public func didBegin( _ contact: SKPhysicsContact )
    {
        if let creature = contact.bodyA.node as? Creature, let other = contact.bodyB.node
        {
            creature.collide( with: other )
        }
        else if let creature = contact.bodyB.node as? Creature, let other = contact.bodyA.node
        {
            creature.collide( with: other )
        }
    }
    
    public func generatePlants( amount: Int )
    {
        for _ in 0 ..< amount
        {
            let plant      = Plant( energy: 1 )
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
            let creature      = Creature( energy: self.settings.initialCreatureEnergy )
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
