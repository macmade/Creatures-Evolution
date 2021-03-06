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

public class MitosisSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Mitosis", settings: settings, enabled: \.mitosis.isEnabled )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.mitosis = MitosisSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.helpText = "Creatures evolving this gene will be able to replicate using mitosis."
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsBoolViewController( title: "Activate gene at start", settings: self.settings, key: \.mitosis.isActive ),
                SettingsBoolViewController( title: "Allow gene to regress",  settings: self.settings, key: \.mitosis.canRegress ),
                SettingsSeparatorViewController(),
                SettingsGeneActivationViewController( title: "Activates:",   gene: Mitosis.self, settings: self.settings, key: \.mitosis.activates ),
                SettingsGeneActivationViewController( title: "Deactivates:", gene: Mitosis.self, settings: self.settings, key: \.mitosis.deactivates ),
                SettingsGeneActivationViewController( title: "Requires:",    gene: Mitosis.self, settings: self.settings, key: \.mitosis.requires ),
            ]
        )
        
        self.addBox(
            title: "Energy",
            controllers:
            [
                SettingsIntSliderViewController( title: "Energy needed:", settings: self.settings, key: \.mitosis.energyNeeded, minValue: 0, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Energy cost:",   settings: self.settings, key: \.mitosis.energyCost,   minValue: 0, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Recovery time:", settings: self.settings, key: \.mitosis.recoveryTime, minValue: 1, maxValue: 10 ),
            ]
        )
        
        self.addBox(
            title: "Other",
            controllers:
            [
                SettingsIntSliderViewController( title: "Reproduction chance:", settings: self.settings, key: \.mitosis.chance,         minValue: 0, maxValue: 100 ),
                SettingsIntSliderViewController( title: "Mutation chance:",     settings: self.settings, key: \.mitosis.mutationChance, minValue: 0, maxValue: 100 ),
            ]
        )
    }
}
