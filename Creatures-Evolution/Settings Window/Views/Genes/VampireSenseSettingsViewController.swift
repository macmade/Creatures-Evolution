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

public class VampireSenseSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Vampire Sense", settings: settings, enabled: \.vampireSense.isEnabled )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.vampireSense = VampireSenseSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.helpText = "Creatures evolving this gene will be able to detect vampires.\nOnly effective for creatures without the vampire gene."
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsBoolViewController( title: "Activate gene at start", settings: self.settings, key: \.vampireSense.isActive ),
                SettingsBoolViewController( title: "Allow gene to regress",  settings: self.settings, key: \.vampireSense.canRegress ),
                SettingsSeparatorViewController(),
                SettingsGeneActivationViewController( title: "Activates:",   gene: VampireSense.self, settings: self.settings, key: \.vampireSense.activates ),
                SettingsGeneActivationViewController( title: "Deactivates:", gene: VampireSense.self, settings: self.settings, key: \.vampireSense.deactivates ),
                SettingsGeneActivationViewController( title: "Requires:",    gene: VampireSense.self, settings: self.settings, key: \.vampireSense.requires ),
            ]
        )
        
        self.addBox(
            title: "Distance",
            controllers:
            [
                SettingsIntSliderViewController( title: "Default distance:",              settings: self.settings, key: \.vampireSense.defaultDistance,       minValue:  1, maxValue: 300 ),
                SettingsIntSliderViewController( title: "Default distance (randomness):", settings: self.settings, key: \.vampireSense.defaultDistanceRange,  minValue:  0, maxValue: 300 ),
                SettingsIntSliderViewController( title: "Minimum distance:",              settings: self.settings, key: \.vampireSense.minimumDistance,       minValue:  1, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Maximum distance:",              settings: self.settings, key: \.vampireSense.maximumDistance,       minValue: 20, maxValue: 300 ),
                SettingsIntSliderViewController( title: "Minimum mutation change:",       settings: self.settings, key: \.vampireSense.minimumMutationChange, minValue:  1, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Maximum mutation change:",       settings: self.settings, key: \.vampireSense.maximumMutationChange, minValue:  1, maxValue: 10 ),
            ]
        )
    }
}
