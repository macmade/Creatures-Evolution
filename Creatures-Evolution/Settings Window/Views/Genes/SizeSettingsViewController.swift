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

public class SizeSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Size", settings: settings, enabled: \.size.isEnabled )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.size = SizeSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.helpText = "Creatures evolving this gene will be able to increase or decrease their size."
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsBoolViewController( title: "Activate gene at start", settings: self.settings, key: \.size.isActive ),
                SettingsBoolViewController( title: "Allow gene to regress",  settings: self.settings, key: \.size.canRegress ),
                SettingsSeparatorViewController(),
                SettingsGeneActivationViewController( title: "Activates:",   gene: Size.self, settings: self.settings, key: \.size.activates ),
                SettingsGeneActivationViewController( title: "Deactivates:", gene: Size.self, settings: self.settings, key: \.size.deactivates ),
                SettingsGeneActivationViewController( title: "Requires:",    gene: Size.self, settings: self.settings, key: \.size.requires ),
            ]
        )
        
        self.addBox(
            title: "Size Multiplier",
            controllers:
            [
                SettingsDoubleSliderViewController( title: "Default multiplier:",              settings: self.settings, key: \.size.defaultMultiplier,      minValue: 0.5, maxValue: 2.0 ),
                SettingsDoubleSliderViewController( title: "Default multiplier (randomness):", settings: self.settings, key: \.size.defaultMultiplierRange, minValue: 0.0, maxValue: 1.0 ),
                SettingsDoubleSliderViewController( title: "Minimum multiplier:",              settings: self.settings, key: \.size.minimumMultiplier,      minValue: 0.5, maxValue: 1.0 ),
                SettingsDoubleSliderViewController( title: "Maximum multiplier:",              settings: self.settings, key: \.size.maximumMultiplier,      minValue: 1.0, maxValue: 2.0 ),
                SettingsDoubleSliderViewController( title: "Minimum mutation change:",         settings: self.settings, key: \.size.minimumMutationChange,  minValue: 0.1, maxValue: 0.2 ),
                SettingsDoubleSliderViewController( title: "Maximum mutation change:",         settings: self.settings, key: \.size.maximumMutationChange,  minValue: 0.2, maxValue: 0.5 ),
            ]
        )
    }
}
