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

public class Sex: NSObject, Gene
{
    public var isActive: Bool
    public var isMale:   Bool
    public var isFemale: Bool
    
    public var canRegress: Bool
    {
        false
    }
    
    public var deactivates: [ AnyClass ]
    {
        get
        {
            [ Mitosis.self ]
        }
    }
    
    public var name: String
    {
        "Sex"
    }
    
    public var detail: String?
    {
        if self.isMale && self.isFemale
        {
            return "Hermaphrodite"
        }
        
        if self.isMale
        {
            return "Male"
        }
        
        return "Female"
    }
    
    private var lastUsed: Date?
    
    public required init( active: Bool )
    {
        self.isActive = active
        
        let sex = Int.random( in: 0 ... 2 )
        
        self.isMale   = sex == 0 || sex == 2
        self.isFemale = sex == 1 || sex == 2
    }
    
    public func copy( with zone: NSZone? = nil ) -> Any
    {
        Sex( active: self.isActive )
    }
    
    public func onEnergyChanged( creature: Creature )
    {}
    
    public func onCollision( creature: Creature, node: SKNode )
    {
        guard let other = node as? Creature else
        {
            return
        }
        
        guard let scene = creature.scene as? Scene else
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
        
        if creature.energy < scene.settings.sex.energyNeeded || other.energy < scene.settings.sex.energyNeeded
        {
            return
        }
        
        if creature.energy < scene.settings.sex.energyCost || other.energy < scene.settings.sex.energyCost
        {
            return
        }
        
        if let lastUsed = self.lastUsed, Date().timeIntervalSince( lastUsed ) < scene.settings.sex.recoveryTime
        {
            return
        }
        
        if Double.random( in: 0 ... 100 ) > scene.settings.sex.chance
        {
            return
        }
        
        self.lastUsed = Date()
        
        if sex1.isMale && sex2.isFemale || sex1.isFemale && sex2.isMale
        {
            creature.energy -= scene.settings.sex.energyCost
            other.energy    -= scene.settings.sex.energyCost
            
            if creature.energy < scene.settings.creatures.energyNeededToGrow
            {
                creature.isBaby = true
            }
            
            if other.energy < scene.settings.creatures.energyNeededToGrow
            {
                other.isBaby = true
            }
            
            for _ in 0 ..< scene.settings.sex.possibleNumberOfChildren
            {
                let genes     = EvolutionHelper.mutate( genes: creature.genes, settings: scene.settings )
                let copy      = Creature( energy: 1, genes: genes, parents: [ creature ] )
                copy.position = creature.position
                
                scene.addChild( copy )
                copy.move()
            }
        }
    }
    
    public func chooseDestination( creature: Creature ) -> Destination?
    {
        nil
    }
}
