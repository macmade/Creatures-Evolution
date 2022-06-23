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

public class CombatSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Combat", settings: settings, enabled: \.combat.isEnabled )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.combat = CombatSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.helpText = "Creatures evolving this gene will be able to increase or decrease their combat abilities."
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsBoolViewController( title: "Activate gene at start", settings: self.settings, key: \.combat.isActive ),
                SettingsBoolViewController( title: "Allow gene to regress",  settings: self.settings, key: \.combat.canRegress ),
            ]
        )
        
        self.addBox(
            title: "Combat Multiplier",
            controllers:
            [
                SettingsDoubleSliderViewController( title: "Default multiplier:",      settings: self.settings, key: \.combat.defaultMultiplier,     minValue: 0.1, maxValue: 10 ),
                SettingsDoubleSliderViewController( title: "Minimum multiplier:",      settings: self.settings, key: \.combat.minimumMultiplier,     minValue: 0.1, maxValue:  1 ),
                SettingsDoubleSliderViewController( title: "Maximum multiplier:",      settings: self.settings, key: \.combat.maximumMultiplier,     minValue: 2.0, maxValue: 10 ),
                SettingsDoubleSliderViewController( title: "Minimum mutation change:", settings: self.settings, key: \.combat.minimumMutationChange, minValue: 0.1, maxValue:  1 ),
                SettingsDoubleSliderViewController( title: "Maximum mutation change:", settings: self.settings, key: \.combat.maximumMutationChange, minValue: 0.1, maxValue:  1 ),
            ]
        )
        
        self.addBox(
            title: "When inactive or disabled",
            controllers:
            [
                SettingsIntSliderViewController( title: "Attacker chance if smaller:",   settings: self.settings, key: \.combat.chanceIfSmaller,  minValue: 0, maxValue: 100 ),
                SettingsIntSliderViewController( title: "Attacker chance if same size:", settings: self.settings, key: \.combat.chanceIfSameSize, minValue: 0, maxValue: 100 ),
                SettingsIntSliderViewController( title: "Attacker chance if bigger:",    settings: self.settings, key: \.combat.chanceIfBigger,   minValue: 0, maxValue: 100 ),
            ]
        )
    }
}
