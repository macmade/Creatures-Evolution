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

public class EvolutionHelper
{
    private init()
    {}
    
    public static func defaultGenes( settings: Settings ) -> [ Gene ]
    {
        var genes: [ Gene ] = []
        
        if settings.mitosis.isEnabled
        {
            genes.append( Mitosis( active: settings.mitosis.isActive, settings: settings ) )
        }
        
        if settings.sex.isEnabled
        {
            genes.append( Sex( active: settings.sex.isActive, settings: settings ) )
        }
        
        if settings.herbivore.isEnabled
        {
            genes.append( Herbivore( active: settings.herbivore.isActive, settings: settings ) )
        }
        
        if settings.scavenger.isEnabled
        {
            genes.append( Scavenger( active: settings.scavenger.isActive, settings: settings ) )
        }
        
        if settings.predator.isEnabled
        {
            genes.append( Predator( active: settings.predator.isActive, settings: settings ) )
        }
        
        if settings.vampire.isEnabled
        {
            genes.append( Vampire( active: settings.vampire.isActive, settings: settings ) )
        }
        
        if settings.cannibal.isEnabled
        {
            genes.append( Cannibal( active: settings.cannibal.isActive, settings: settings ) )
        }
        
        if settings.plantSense.isEnabled
        {
            genes.append( PlantSense( active: settings.plantSense.isActive, settings: settings ) )
        }
        
        if settings.meatSense.isEnabled
        {
            genes.append( MeatSense( active: settings.meatSense.isActive, settings: settings ) )
        }
        
        if settings.preySense.isEnabled
        {
            genes.append( PreySense( active: settings.preySense.isActive, settings: settings ) )
        }
        
        if settings.sexSense.isEnabled
        {
            genes.append( SexSense( active: settings.sexSense.isActive, settings: settings ) )
        }
        
        if settings.predatorSense.isEnabled
        {
            genes.append( PredatorSense( active: settings.predatorSense.isActive, settings: settings ) )
        }
        
        if settings.vampireSense.isEnabled
        {
            genes.append( VampireSense( active: settings.vampireSense.isActive, settings: settings ) )
        }
        
        genes.shuffled().forEach
        {
            if $0.isActive
            {
                self.deactivateConflictingGenes( gene: $0, in: genes )
            }
        }
        
        return genes
    }
    
    public static func deactivateConflictingGenes( gene: Gene, in genes: [ Gene ] )
    {
        gene.deactivates.forEach
        {
            name in genes.forEach
            {
                guard let cls = NSStringFromClass( type( of: $0 ) ).components( separatedBy: "." ).last else
                {
                    return
                }
                
                if cls == name
                {
                    $0.isActive = false
                }
            }
        }
    }
    
    public static func mutate( genes: [ Gene ], settings: Settings ) -> [ Gene ]
    {
        let copy = genes.compactMap { $0.copy() as? Gene }
            
        if Int.random( in: 0 ... 100 ) > settings.creatures.mutationChance
        {
            return copy
        }
        
        guard let gene = copy.randomElement() else
        {
            return copy
        }
        
        if gene.canRegress == false && gene.isActive
        {
            return copy
        }
        
        gene.isActive = gene.isActive == false
        
        if gene.isActive
        {
            self.deactivateConflictingGenes( gene: gene, in: copy )
        }
        
        return copy
    }
}
