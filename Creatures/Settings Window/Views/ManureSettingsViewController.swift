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

public class ManureSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Manure", settings: settings, enabled: \.manure.isEnabled )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.manure = ManureSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.helpText = "If enabled, creatures having evolved the digestion gene will drop manure when ingesting spoiled food."
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsBoolViewController( title: "Manure can disappear",    settings: self.settings, key: \.manure.canDisappear ),
                SettingsBoolViewController( title: "Manure can become plant", settings: self.settings, key: \.manure.canBecomePlant ),
            ]
        )
        
        self.addBox(
            title: "Lifetime",
            controllers:
            [
                SettingsIntSliderViewController( title: "Disappear after:",              settings: self.settings, key: \.manure.disappearAfter,      minValue: 1, maxValue: 60 ),
                SettingsIntSliderViewController( title: "Disappear after (randomness):", settings: self.settings, key: \.manure.disappearAfterRange, minValue: 0, maxValue: 60 ),
            ]
        )
        
        self.addBox(
            title: "Plant",
            controllers:
            [
                SettingsIntSliderViewController( title: "Become plant after:",              settings: self.settings, key: \.manure.becomePlantAfter,      minValue: 1, maxValue: 60 ),
                SettingsIntSliderViewController( title: "Become plant after (randomness):", settings: self.settings, key: \.manure.becomePlantAfterRange, minValue: 0, maxValue: 60 ),
            ]
        )
    }
}
