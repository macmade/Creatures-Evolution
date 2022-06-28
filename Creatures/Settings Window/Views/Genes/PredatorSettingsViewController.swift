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

public class PredatorSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Predator", settings: settings, enabled: \.predator.isEnabled )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.predator = PredatorSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.helpText = "Creatures evolving this gene will use other creatures as food source, killing them in the process.\nNote that predators won't attack other predators or related creatures, unless they've evolved the cannibal gene."
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsBoolViewController( title: "Activate gene at start", settings: self.settings, key: \.predator.isActive ),
                SettingsBoolViewController( title: "Allow gene to regress",  settings: self.settings, key: \.predator.canRegress ),
                SettingsSeparatorViewController(),
                SettingsGeneActivationViewController( title: "Activates:",   gene: Predator.self, settings: self.settings, key: \.predator.activates ),
                SettingsGeneActivationViewController( title: "Deactivates:", gene: Predator.self, settings: self.settings, key: \.predator.deactivates ),
                SettingsGeneActivationViewController( title: "Requires:",    gene: Predator.self, settings: self.settings, key: \.predator.requires ),
            ]
        )
        
        self.addBox(
            title: "Combat Chances",
            controllers:
            [
                SettingsIntSliderViewController( title: "Attacker chance if smaller:",   settings: self.settings, key: \.predator.combat.chanceIfSmaller,  minValue: 0, maxValue: 100 ),
                SettingsIntSliderViewController( title: "Attacker chance if same size:", settings: self.settings, key: \.predator.combat.chanceIfSameSize, minValue: 0, maxValue: 100 ),
                SettingsIntSliderViewController( title: "Attacker chance if bigger:",    settings: self.settings, key: \.predator.combat.chanceIfBigger,   minValue: 0, maxValue: 100 ),
            ]
        )
        
        self.addBox(
            title: "Combat Energy",
            controllers:
            [
                SettingsIntSliderViewController( title: "Successfull attack cost:",          settings: self.settings, key: \.predator.combat.energyCostAttackSuccess,   minValue: 0, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Failed attack cost:",               settings: self.settings, key: \.predator.combat.energyCostAttackFailure,   minValue: 0, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Successfull defense cost:",         settings: self.settings, key: \.predator.combat.energyCostDefenseSuccess,  minValue: 0, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Failed defense cost:",              settings: self.settings, key: \.predator.combat.energyCostDefenseFailure,  minValue: 0, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Successfull attack recovery time:", settings: self.settings, key: \.predator.combat.recoveryTimeAttackSuccess, minValue: 1, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Failed attack recovery time:",      settings: self.settings, key: \.predator.combat.recoveryTimeAttackFailure, minValue: 1, maxValue: 10 ),
            ]
        )
    }
}
