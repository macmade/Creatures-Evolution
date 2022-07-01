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

public class PlantsSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Plants", settings: settings, enabled: \.plants.isEnabled )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.plants = PlantsSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.helpText = "If enabled, plants will grow repeatedly in the world."
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsBoolViewController( title: "Plants can disappear", settings: self.settings, key: \.plants.canDisappear ),
                SettingsBoolViewController( title: "Plants can decay",     settings: self.settings, key: \.plants.canDecay ),
            ]
        )
        
        self.addBox(
            title: "Growth",
            controllers:
            [
                SettingsIntSliderViewController( title: "Initial amount:", settings: self.settings, key: \.plants.initialAmount, minValue: 0, maxValue: 100 ),
                SettingsIntSliderViewController( title: "Renew amount:",   settings: self.settings, key: \.plants.renewAmount,   minValue: 0, maxValue: 100 ),
                SettingsIntSliderViewController( title: "Renew interval:", settings: self.settings, key: \.plants.renewInterval, minValue: 5, maxValue:  60 ),
            ]
        )
        
        self.addBox(
            title: "Lifetime",
            controllers:
            [
                SettingsIntSliderViewController( title: "Disappear after:",              settings: self.settings, key: \.plants.disappearAfter,      minValue: 1, maxValue: 60 ),
                SettingsIntSliderViewController( title: "Disappear after (randomness):", settings: self.settings, key: \.plants.disappearAfterRange, minValue: 0, maxValue: 60 ),
            ]
        )
        
        self.addBox(
            title: "Decay",
            controllers:
            [
                SettingsIntSliderViewController( title: "Decay after:",              settings: self.settings, key: \.plants.decayAfter,      minValue:   1, maxValue: 60 ),
                SettingsIntSliderViewController( title: "Decay after (randomness):", settings: self.settings, key: \.plants.decayAfterRange, minValue:   0, maxValue: 60 ),
                SettingsIntSliderViewController( title: "Decayed energy:",           settings: self.settings, key: \.plants.decayEnergy,     minValue: -10, maxValue:  0 ),
            ]
        )
    }
}
