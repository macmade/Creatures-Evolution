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

public class Settings: NSObject, Codable
{
    @objc public dynamic var world         = WorldSettings()
    @objc public dynamic var creatures     = CreaturesSettings()
    @objc public dynamic var eventLog      = EventLogSettings()
    @objc public dynamic var plants        = PlantsSettings()
    @objc public dynamic var meat          = MeatSettings()
    @objc public dynamic var manure        = ManureSettings()
    @objc public dynamic var speed         = SpeedSettings()
    @objc public dynamic var attack        = AttackSettings()
    @objc public dynamic var defense       = DefenseSettings()
    @objc public dynamic var abnegation    = AbnegationSettings()
    @objc public dynamic var digestion     = DigestionSettings()
    @objc public dynamic var excretion     = ExcretionSettings()
    @objc public dynamic var mitosis       = MitosisSettings()
    @objc public dynamic var sex           = SexSettings()
    @objc public dynamic var herbivore     = HerbivoreSettings()
    @objc public dynamic var scavenger     = ScavengerSettings()
    @objc public dynamic var predator      = PredatorSettings()
    @objc public dynamic var vampire       = VampireSettings()
    @objc public dynamic var cannibal      = CannibalSettings()
    @objc public dynamic var plantSense    = PlantSenseSettings()
    @objc public dynamic var manureSense   = ManureSenseSettings()
    @objc public dynamic var meatSense     = MeatSenseSettings()
    @objc public dynamic var preySense     = PreySenseSettings()
    @objc public dynamic var sexSense      = SexSenseSettings()
    @objc public dynamic var predatorSense = PredatorSenseSettings()
    @objc public dynamic var vampireSense  = VampireSenseSettings()
    
    public func save() throws
    {
        Preferences.shared.settings = try PropertyListEncoder().encode( self )
    }
    
    public class func restore() -> Settings
    {
        if let data = Preferences.shared.settings, let settings = try? self.from( data: data )
        {
            return settings
        }
        
        return Settings()
    }
    
    public class func from( url: URL ) throws -> Settings
    {
        try self.from( data: try Data( contentsOf: url ) )
    }
    
    public class func from( data: Data ) throws -> Settings
    {
        if let settings = try? PropertyListDecoder().decode( Settings.self, from: data )
        {
            return settings
        }
        
        let settings = Settings()
        let plist    = try PropertyListSerialization.propertyList( from: data, format: nil )
        
        guard let dict = plist as? Dictionary< String, NSObject > else
        {
            throw NSError( domain: NSCocoaErrorDomain, code: NSFileReadCorruptFileError )
        }
        
        self.decode( dictionary: dict, settings: settings )
        
        return settings
    }
    
    public class func decode( dictionary: Dictionary< String, NSObject >, settings: NSObject )
    {
        dictionary.forEach
        {
            pair in
            
            try? NSException.doTry
            {
                
                if let dict = pair.value as? Dictionary< String, NSObject >
                {
                    guard let section = settings.value( forKey: pair.key ) as? NSObject else
                    {
                        return
                    }
                    
                    self.decode( dictionary: dict, settings: section )
                }
                else
                {
                    try? NSException.doTry
                    {
                        settings.setValue( pair.value, forKey: pair.key )
                    }
                }
            }
        }
    }
}
