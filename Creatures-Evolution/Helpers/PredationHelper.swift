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
    
    public class func attack( creature: Creature, target: Creature, settings: CombatSettings ) -> Bool
    {
        if creature.isBeingRemoved || target.isBeingRemoved
        {
            return false
        }
        
        let getGeneValue: ( Creature, AnyClass ) -> Double =
        {
            guard let gene = $0.getGene( $1 ) as? DoubleValueGene, gene.isActive else
            {
                return 1.0
            }
            
            return gene.value
        }
        
        let getChance: ( Creature, Creature ) -> Double =
        {
            if $0.isSmallerThan( creature: $1 )
            {
                return Double( settings.chanceIfSmaller )
            }
            else if $0.isBiggerThan( creature: $1 )
            {
                return Double( settings.chanceIfBigger )
            }
            
            return Double( settings.chanceIfSameSize )
        }
        
        let attack  = getGeneValue( creature, Attack.self )
        let defense = getGeneValue( target,   Defense.self )
        let chance  = ( getChance( creature, target ) * attack ) / defense
        
        if Double.random( in: 0 ... 100 ) <= chance
        {
            creature.energy -= Double( settings.energyCostAttackSuccess )
            target.energy   -= Double( settings.energyCostDefenseFailure )
            
            return true
        }
        
        creature.energy -= Double( settings.energyCostAttackFailure )
        target.energy   -= Double( settings.energyCostDefenseSuccess )
        
        return false
    }
}
