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

public class EventLog: NSObject
{
    public static let shared = EventLog()
    
    public private( set ) var events: [ Event ] = []
    
    private var index = 0
    
    public func add( event: Event )
    {
        event.index = self.index
        self.index += 1
        
        self.events.append( event )
        
        self.events = self.events.suffix( 1000 )
    }
    
    public func clear()
    {
        self.events.removeAll()
    }
    
    private func name( of creature: Creature ) -> String
    {
        if let name = creature.customName, name.isEmpty == false
        {
            return name
        }
        else if let name = creature.name, name.isEmpty == false
        {
            return name
        }
        
        return "<unknown>"
    }
    
    public func energyChanged( creature: Creature, difference: Double )
    {
        guard let scene = creature.scene as? Scene, scene.settings.eventLog.logEnergyChanges else
        {
            return
        }
        
        if difference < 0
        {
            self.add( event: Event( message: "Lost \( String( format: "%.02f", abs( difference ) ) ) energy", time: scene.elapsedTime, node: creature ) )
        }
        else
        {
            self.add( event: Event( message: "Gained \( String( format: "%.02f", difference ) ) energy", time: scene.elapsedTime, node: creature ) )
        }
    }
    
    public func killed( creature: Creature, by killer: Creature? )
    {
        guard let scene = creature.scene as? Scene, scene.settings.eventLog.logKills else
        {
            return
        }
        
        if let predator = killer, predator.hasActiveGene( Predator.self )
        {
            self.add( event: Event( message: "Died: killed by predator \( self.name( of: predator ) )", time: scene.elapsedTime, node: creature ) )
        }
        else if let vampire = killer, vampire.hasActiveGene( Vampire.self )
        {
            self.add( event: Event( message: "Died: killed by vampire \( self.name( of: vampire ) )", time: scene.elapsedTime, node: creature ) )
        }
        else
        {
            self.add( event: Event( message: "Died: killed by a greater will", time: scene.elapsedTime, node: creature ) )
        }
    }
    
    public func attack( attacker: Creature, target: Creature, success: Bool )
    {
        guard let scene = attacker.scene as? Scene, scene.settings.eventLog.logCombats else
        {
            return
        }
        
        if success
        {
            self.add( event: Event( message: "\( self.name( of: attacker ) ) successfully attacked \( self.name( of: target ) )", time: scene.elapsedTime, node: attacker ) )
            self.add( event: Event( message: "\( self.name( of: target ) ) failed to defend against \( self.name( of: attacker ) )", time: scene.elapsedTime, node: target ) )
        }
        else
        {
            self.add( event: Event( message: "\( self.name( of: attacker ) ) failed to attack \( self.name( of: target ) )", time: scene.elapsedTime, node: attacker ) )
            self.add( event: Event( message: "\( self.name( of: target ) ) successfully defended against \( self.name( of: attacker ) )", time: scene.elapsedTime, node: target ) )
        }
    }
    
    public func died( creature: Creature )
    {
        guard let scene = creature.scene as? Scene, scene.settings.eventLog.logDeaths else
        {
            return
        }
        
        self.add( event: Event( message: "Died: out of energy", time: scene.elapsedTime, node: creature ) )
    }
    
    public func born( creature: Creature, from parents: [ Creature ] )
    {
        guard let scene = creature.scene as? Scene, scene.settings.eventLog.logBirths else
        {
            return
        }
        
        if parents.count == 1
        {
            self.add( event: Event( message: "Born: birth by mitosis from \( self.name( of: parents[ 0 ] ) )", time: scene.elapsedTime, node: creature ) )
        }
        else if parents.count == 2
        {
            self.add( event: Event( message: "Born: birth by sexual reproduction from \( self.name( of: parents[ 0 ] ) ) and \( self.name( of: parents[ 1 ] ) )", time: scene.elapsedTime, node: creature ) )
        }
        else
        {
            self.add( event: Event( message: "Born: unknown reason", time: scene.elapsedTime, node: creature ) )
        }
    }
    
    public func energyTransfer( amount: Double, from giver: Creature, to receiver: Creature )
    {
        guard let scene = giver.scene as? Scene, scene.settings.eventLog.logEnergyChanges else
        {
            return
        }
        
        let e = String( format: "%.02f", amount )
        
        EventLog.shared.add( event: Event( message: "Gived \( e ) energy to \( self.name( of: receiver ) )", time: scene.elapsedTime, node: giver ) )
        EventLog.shared.add( event: Event( message: "Received \( e ) energy from \( self.name( of: giver ) )", time: scene.elapsedTime, node: receiver ) )
    }
}
