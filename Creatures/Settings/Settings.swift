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
    private static let defaultsKey = "settings"
    
    @objc public dynamic var world          = WorldSettings()
    @objc public dynamic var creatures      = CreaturesSettings()
    @objc public dynamic var plants         = PlantsSettings()
    @objc public dynamic var meat           = MeatSettings()
    @objc public dynamic var mitosis        = MitosisSettings()
    @objc public dynamic var sex            = SexSettings()
    @objc public dynamic var herbivore      = HerbivoreSettings()
    @objc public dynamic var scavenger      = ScavengerSettings()
    @objc public dynamic var predator       = PredatorSettings()
    @objc public dynamic var vampire        = VampireSettings()
    @objc public dynamic var cannibal       = CannibalSettings()
    @objc public dynamic var plantSense     = PlantSenseSettings()
    @objc public dynamic var meatSense      = MeatSenseSettings()
    @objc public dynamic var creatureSense  = CreatureSenseSettings()
    @objc public dynamic var sexSense       = SexSenseSettings()
    @objc public dynamic var predatorSense  = PredatorSenseSettings()
    @objc public dynamic var vampireSense   = VampireSenseSettings()
    
    public static func restore() -> Settings
    {
        guard let data = UserDefaults.standard.object( forKey: Settings.defaultsKey ) as? Data else
        {
            return Settings()
        }
        
        do
        {
            return try PropertyListDecoder().decode( Settings.self, from: data )
        }
        catch
        {
            return Settings()
        }
    }
    
    public func save() throws
    {
        let data = try PropertyListEncoder().encode( self )
        
        UserDefaults.standard.set( data, forKey: Settings.defaultsKey )
        UserDefaults.standard.synchronize()
    }
}
