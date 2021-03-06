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

public class MeatSenseSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Meat Sense", settings: settings, enabled: \.meatSense.isEnabled )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.meatSense = MeatSenseSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.helpText = "Creatures evolving this gene will be able to detect meat dropped by dead creatures.\nOnly effective for creatures having evolved the scavenger gene."
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsBoolViewController( title: "Activate gene at start", settings: self.settings, key: \.meatSense.isActive ),
                SettingsBoolViewController( title: "Allow gene to regress",  settings: self.settings, key: \.meatSense.canRegress ),
                SettingsSeparatorViewController(),
                SettingsGeneActivationViewController( title: "Activates:",   gene: MeatSense.self, settings: self.settings, key: \.meatSense.activates ),
                SettingsGeneActivationViewController( title: "Deactivates:", gene: MeatSense.self, settings: self.settings, key: \.meatSense.deactivates ),
                SettingsGeneActivationViewController( title: "Requires:",    gene: MeatSense.self, settings: self.settings, key: \.meatSense.requires ),
            ]
        )
        
        self.addBox(
            title: "Distance",
            controllers:
            [
                SettingsIntSliderViewController( title: "Default distance:",              settings: self.settings, key: \.meatSense.defaultDistance,       minValue:  1, maxValue: 300 ),
                SettingsIntSliderViewController( title: "Default distance (randomness):", settings: self.settings, key: \.meatSense.defaultDistanceRange,  minValue:  0, maxValue: 300 ),
                SettingsIntSliderViewController( title: "Minimum distance:",              settings: self.settings, key: \.meatSense.minimumDistance,       minValue:  1, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Maximum distance:",              settings: self.settings, key: \.meatSense.maximumDistance,       minValue: 20, maxValue: 300 ),
                SettingsIntSliderViewController( title: "Minimum mutation change:",       settings: self.settings, key: \.meatSense.minimumMutationChange, minValue:  1, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Maximum mutation change:",       settings: self.settings, key: \.meatSense.maximumMutationChange, minValue:  1, maxValue: 10 ),
            ]
        )
        
        self.addBox(
            title: "Other",
            controllers:
            [
                SettingsBoolViewController( title: "Detects and avoids decayed meat", settings: self.settings, key: \.meatSense.canDetectDecayed, style: .asCheckbox )
            ]
        )
    }
}
