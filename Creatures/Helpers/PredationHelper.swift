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

public class PredationHelper
{
    private init()
    {}
    
    public class func canEat( creature: Creature, prey: Creature ) -> Bool
    {
        if creature.isBeingRemoved || prey.isBeingRemoved
        {
            return false
        }
        
        if creature.hasActiveGene( Predator.self ) == false && creature.hasActiveGene( Vampire.self ) == false
        {
            return false
        }
        
        if creature.hasActiveGene( Predator.self ) && prey.hasActiveGene( Predator.self ) && creature.hasActiveGene( Cannibal.self ) == false
        {
            return false
        }
        
        if creature.hasActiveGene( Vampire.self ) && prey.hasActiveGene( Vampire.self ) && creature.hasActiveGene( Cannibal.self ) == false
        {
            return false
        }
        
        if creature.isChild( of: prey ) && ( creature.hasActiveGene( Cannibal.self ) == false || creature.settings.cannibal.canEatParents == false )
        {
            return false
        }
        
        if creature.isParentOf( of: prey ) && ( creature.hasActiveGene( Cannibal.self ) == false || creature.settings.cannibal.canEatChildren == false )
        {
            return false
        }
        
        if creature.isSibling( of: prey ) && ( creature.hasActiveGene( Cannibal.self ) == false || creature.settings.cannibal.canEatSiblings == false )
        {
            return false
        }
        
        return true
    }
    
    public class func canBeEaten( creature: Creature, by attacker: Creature ) -> Bool
    {
        self.canEat( creature: attacker, prey: creature )
    }
    
    public class func attack( creature: Creature, target: Creature ) -> Bool
    {
        if creature.isBeingRemoved || target.isBeingRemoved
        {
            return false
        }
        
        if let attack = creature.getGene( Attack.self ) as? Attack, let defense = target.getGene( Defense.self ) as? Defense
        {
            if attack.isActive && defense.isActive
            {
                if attack.value == defense.value
                {
                    return Bool.random()
                }
                
                return attack.value > defense.value
            }
            else if attack.isActive
            {
                return true
            }
            else if defense.isActive
            {
                return false
            }
        }
        else if let attack = creature.getGene( Attack.self ) as? Attack, attack.isActive
        {
            return true
        }
        else if let defense = creature.getGene( Defense.self ) as? Defense, defense.isActive
        {
            return false
        }
        
        let chance: Int =
        {
            if creature.isSmallerThan( creature: target )
            {
                return creature.settings.attack.chanceIfSmaller
            }
            else if creature.isBiggerThan( creature: target )
            {
                return creature.settings.attack.chanceIfBigger
            }
            
            return creature.settings.attack.chanceIfSameSize
        }()
        
        return Int.random( in: 0 ... 100 ) <= chance
    }
}
