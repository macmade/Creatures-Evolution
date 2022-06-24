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
    
    public class func defaultGenes( settings: Settings ) -> [ Gene ]
    {
        var genes: [ Gene ] = []
        
        if settings.speed.isEnabled
        {
            genes.append( Speed( active: settings.speed.isActive, settings: settings ) )
        }
        
        if settings.attack.isEnabled
        {
            genes.append( Attack( active: settings.attack.isActive, settings: settings ) )
        }
        
        if settings.defense.isEnabled
        {
            genes.append( Defense( active: settings.defense.isActive, settings: settings ) )
        }
        
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
    
    public class func deactivateConflictingGenes( gene: Gene, in genes: [ Gene ] )
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
    
    public class func mutate( genes: [ Gene ], mutationChance: Int ) -> ( genes: [ Gene ], event: String? )
    {
        let copy = genes.compactMap { $0.copy() as? Gene }
            
        if Int.random( in: 0 ... 100 ) > mutationChance
        {
            return ( genes: copy, event: nil )
        }
        
        var event: String?
        
        for gene in copy.shuffled()
        {
            let wasActive       = gene.isActive
            let previousDetails = gene.details
            
            if gene.mutate() == false
            {
                continue
            }
            
            let isActive = gene.isActive
            let details  = gene.details
            
            if isActive
            {
                self.deactivateConflictingGenes( gene: gene, in: copy )
            }
            
            if wasActive == false && isActive
            {
                event = "Gene was evolved: \( gene.name )"
            }
            else if wasActive && isActive == false
            {
                event = "Gene was regressed: \( gene.name )"
            }
            else if let previousDetails = previousDetails, let details = details, previousDetails != details
            {
                event = "Gene was mutated: \( gene.name ) (\( previousDetails ) -> \( details ))"
            }
            else if let details = details
            {
                event = "Gene was mutated: \( gene.name ) (\( details ))"
            }
            else
            {
                event = "Gene was mutated: \( gene.name )"
            }
            
            break
        }
        
        return ( genes: copy, event: event )
    }
    
    public class func genes( from parent1: Creature, and parent2: Creature ) -> [ Gene ]
    {
        let genes = zip( parent1.genes, parent2.genes ).map
        {
            Bool.random() ? $0.0 : $0.1
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
}
