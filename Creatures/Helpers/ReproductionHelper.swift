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

public class ReproductionHelper
{
    private init()
    {}
    
    public class func canMate( creature: Creature, with other: Creature ) -> Bool
    {
        if creature.isBeingRemoved || other.isBeingRemoved
        {
            return false
        }
        
        guard let scene = creature.scene as? Scene else
        {
            return false
        }
        
        guard let sex1 = creature.getGene( Sex.self ) as? Sex, let sex2 = other.getGene( Sex.self ) as? Sex else
        {
            return false
        }
        
        if sex1.isActive == false || sex2.isActive == false
        {
            return false
        }
        
        if creature.isBaby || other.isBaby
        {
            return false
        }
        
        if creature.energy < scene.settings.sex.energyNeeded || other.energy < scene.settings.sex.energyNeeded
        {
            return false
        }
        
        if creature.energy < scene.settings.sex.energyCost || other.energy < scene.settings.sex.energyCost
        {
            return false
        }
        
        if sex1.isFemale, let lastUsed = sex1.lastUsed, lastUsed + Double( scene.settings.sex.recoveryTime ) > scene.elapsedTime
        {
            return false
        }
        
        if sex2.isFemale, let lastUsed = sex2.lastUsed, lastUsed + Double( scene.settings.sex.recoveryTime ) > scene.elapsedTime
        {
            return false
        }
        
        return ( sex1.isMale && sex2.isFemale ) || ( sex1.isFemale && sex2.isMale )
    }
}
