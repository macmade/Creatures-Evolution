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

import Foundation

public class GeneInfo: NSObject
{
    @objc public private( set ) dynamic var name:      String
    @objc public private( set ) dynamic var geneClass: AnyClass
    @objc public private( set ) dynamic var settings:  Settings
    
    public var isEnabled: Bool { self.settings[ keyPath: self.isEnabledKey ] }
    public var isActive:  Bool { self.settings[ keyPath: self.isActiveKey ] }
    
    private var isEnabledKey: KeyPath< Settings, Bool >
    private var isActiveKey:  KeyPath< Settings, Bool >
    private var create:       ( GeneInfo ) -> Gene
    
    public class func allGenes( settings: Settings ) -> [ GeneInfo ]
    {
        [
            GeneInfo( settings: settings, isEnabledKey: \.cannibal.isEnabled, isActiveKey: \.cannibal.isActive )
            {
                Cannibal( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.herbivore.isEnabled, isActiveKey: \.herbivore.isActive )
            {
                Herbivore( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.predator.isEnabled, isActiveKey: \.predator.isActive )
            {
                Predator( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.scavenger.isEnabled, isActiveKey: \.scavenger.isActive )
            {
                Scavenger( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.vampire.isEnabled, isActiveKey: \.vampire.isActive )
            {
                Vampire( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.mitosis.isEnabled, isActiveKey: \.mitosis.isActive )
            {
                Mitosis( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.sex.isEnabled, isActiveKey: \.sex.isActive )
            {
                Sex( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.abnegation.isEnabled, isActiveKey: \.abnegation.isActive )
            {
                Abnegation( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.attack.isEnabled, isActiveKey: \.attack.isActive )
            {
                Attack( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.defense.isEnabled, isActiveKey: \.defense.isActive )
            {
                Defense( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.digestion.isEnabled, isActiveKey: \.digestion.isActive )
            {
                Digestion( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.speed.isEnabled, isActiveKey: \.speed.isActive )
            {
                Speed( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.meatSense.isEnabled, isActiveKey: \.meatSense.isActive )
            {
                MeatSense( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.plantSense.isEnabled, isActiveKey: \.plantSense.isActive )
            {
                PlantSense( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.predatorSense.isEnabled, isActiveKey: \.predatorSense.isActive )
            {
                PredatorSense( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.preySense.isEnabled, isActiveKey: \.preySense.isActive )
            {
                PreySense( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.sexSense.isEnabled, isActiveKey: \.sexSense.isActive )
            {
                SexSense( active: $0.isActive, settings: $0.settings )
            },
            GeneInfo( settings: settings, isEnabledKey: \.vampireSense.isEnabled, isActiveKey: \.vampireSense.isActive )
            {
                VampireSense( active: $0.isActive, settings: $0.settings )
            },
        ]
    }
    
    private init( settings: Settings, isEnabledKey: KeyPath< Settings, Bool >, isActiveKey: KeyPath< Settings, Bool >, create: @escaping ( GeneInfo ) -> Gene )
    {
        self.name         = ""
        self.geneClass    = NSObject.self
        self.settings     = settings
        self.isEnabledKey = isEnabledKey
        self.isActiveKey  = isActiveKey
        self.create       = create
        
        super.init()
        
        let instance   = self.createInstance()
        self.name      = instance.name
        self.geneClass = type( of: instance )
    }
    
    public func createInstance() -> Gene
    {
        self.create( self )
    }
}
