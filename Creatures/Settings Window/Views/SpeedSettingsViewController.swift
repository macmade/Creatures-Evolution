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

public class SpeedSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Speed", settings: settings, enabled: \.speed.isEnabled )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.speed = SpeedSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.helpText = "Creatures evolving this gene will be able to mutate their speed, moving either slower or faster."
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsBoolViewController( title: "Activate gene at start", settings: self.settings, key: \.speed.isActive ),
                SettingsBoolViewController( title: "Allow gene to regress",  settings: self.settings, key: \.speed.canRegress ),
                SettingsSeparatorViewController(),
                SettingsGeneActivationViewController( title: "Activates:",   gene: Speed.self, settings: self.settings, key: \.speed.activates ),
                SettingsGeneActivationViewController( title: "Deactivates:", gene: Speed.self, settings: self.settings, key: \.speed.deactivates ),
            ]
        )
        
        self.addBox(
            title: "Speed Multiplier",
            controllers:
            [
                SettingsDoubleSliderViewController( title: "Default multiplier:",              settings: self.settings, key: \.speed.defaultMultiplier,      minValue: 0.1, maxValue: 10 ),
                SettingsDoubleSliderViewController( title: "Default multiplier (randomness):", settings: self.settings, key: \.speed.defaultMultiplierRange, minValue:   0, maxValue: 10 ),
                SettingsDoubleSliderViewController( title: "Minimum multiplier:",              settings: self.settings, key: \.speed.minimumMultiplier,      minValue: 0.1, maxValue:  1 ),
                SettingsDoubleSliderViewController( title: "Maximum multiplier:",              settings: self.settings, key: \.speed.maximumMultiplier,      minValue: 2.0, maxValue: 10 ),
                SettingsDoubleSliderViewController( title: "Minimum mutation change:",         settings: self.settings, key: \.speed.minimumMutationChange,  minValue: 0.1, maxValue:  1 ),
                SettingsDoubleSliderViewController( title: "Maximum mutation change:",         settings: self.settings, key: \.speed.maximumMutationChange,  minValue: 0.1, maxValue:  1 ),
            ]
        )
    }
}
