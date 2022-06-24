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
        guard let settings = ( creature.scene as? Scene )?.settings else
        {
            return false
        }
        
        if creature.isBeingRemoved || target.isBeingRemoved
        {
            return false
        }
        
        let updateCombatEnergy: ( Bool, Creature, Creature ) -> Bool =
        {
            success, attacker, defenser in
            
            if success
            {
                attacker.energy -= attacker.hasActiveGene( Attack.self )  ? settings.attack.energyCostSuccess  : 0
                defenser.energy -= defenser.hasActiveGene( Defense.self ) ? settings.defense.energyCostFailure : 0
            }
            else
            {
                attacker.energy -= attacker.hasActiveGene( Attack.self )  ? settings.attack.energyCostFailure  : 0
                defenser.energy -= defenser.hasActiveGene( Defense.self ) ? settings.defense.energyCostSuccess : 0
            }
            
            return success
        }
        
        if let attack: Attack = creature.getGene(), let defense: Defense = target.getGene()
        {
            if attack.isActive && defense.isActive
            {
                if attack.value == defense.value
                {
                    return updateCombatEnergy( Bool.random(), creature, target )
                }
                
                return updateCombatEnergy( attack.value > defense.value, creature, target )
            }
            else if attack.isActive
            {
                return updateCombatEnergy( true, creature, target )
            }
            else if defense.isActive
            {
                return updateCombatEnergy( false, creature, target )
            }
        }
        else if let attack: Attack = creature.getGene(), attack.isActive
        {
            return updateCombatEnergy( true, creature, target )
        }
        else if let defense: Defense = creature.getGene(), defense.isActive
        {
            return updateCombatEnergy( false, creature, target )
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
