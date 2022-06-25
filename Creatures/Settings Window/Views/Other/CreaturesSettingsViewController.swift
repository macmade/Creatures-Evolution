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

public class CreaturesSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Creatures", settings: settings, enabled: nil )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.creatures = CreaturesSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsIntSliderViewController( title: "Initial amount:",            settings: self.settings, key: \.creatures.initialAmount,   minValue:   1, maxValue: 100 ),
                SettingsIntSliderViewController( title: "Population limit:",          settings: self.settings, key: \.creatures.populationLimit, minValue: 100, maxValue: 1000 ),
                SettingsIntMenuViewController(   title: "Population limit strategy:", settings: self.settings, key: \.creatures.populationLimitStrategy, values: [ ( "Kill Random Creatures", 0 ), ( "Prevent New Births", 1 ) ] ),
                SettingsBoolViewController(      title: "Generate random names:",     settings: self.settings, key: \.creatures.generateRandomNames, style: .asSwitch ),
            ]
        )
        
        self.addBox(
            title: "Energy",
            controllers:
            [
                SettingsIntSliderViewController( title: "Initial energy:",        settings: self.settings, key: \.creatures.initialEnergy,      minValue: 0, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Energy needed to grow:", settings: self.settings, key: \.creatures.energyNeededToGrow, minValue: 0, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Growth energy cost:",    settings: self.settings, key: \.creatures.growthEnergyCost,   minValue: 0, maxValue: 10 ),
            ]
        )
        
        self.addBox(
            title: "Energy Decrease",
            controllers:
            [
                SettingsIntSliderViewController( title: "Amount:",                settings: self.settings, key: \.creatures.energyDecreaseAmount,        minValue: 0, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Interval:",              settings: self.settings, key: \.creatures.energyDecreaseInterval,      minValue: 0, maxValue: 60 ),
                SettingsIntSliderViewController( title: "Interval (randomness):", settings: self.settings, key: \.creatures.energyDecreaseIntervalRange, minValue: 0, maxValue: 10 ),
            ]
        )
    }
}
