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
    
    @objc public private( set ) dynamic var events: [ Event ] = []
    
    public func add( event: Event )
    {
        self.willChangeValue( for: \.events )
        self.events.append( event )
        self.didChangeValue( for: \.events )
    }
    
    public func clear()
    {
        self.willChangeValue( for: \.events )
        self.events.removeAll()
        self.didChangeValue( for: \.events )
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
    
    public func killed( creature: Creature, by killer: Creature? )
    {
        if let scene = creature.scene as? Scene
        {
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
    }
    
    public func died( creature: Creature )
    {
        if let scene = creature.scene as? Scene
        {
            self.add( event: Event( message: "Died: out of energy", time: scene.elapsedTime, node: creature ) )
        }
    }
    
    public func born( creature: Creature, from parents: [ Creature ] )
    {
        if let scene = creature.scene as? Scene
        {
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
    }
}
