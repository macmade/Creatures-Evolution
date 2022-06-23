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

public class PredatorSenseSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Predator Sense", settings: settings, enabled: \.predatorSense.isEnabled )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.predatorSense = PredatorSenseSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.helpText = "Creatures evolving this gene will be able to detect predators.\nOnly effective for non creatures without the predator gene."
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsBoolViewController( title: "Activate gene at start", settings: self.settings, key: \.predatorSense.isActive ),
                SettingsBoolViewController( title: "Allow gene to regress",  settings: self.settings, key: \.predatorSense.canRegress ),
            ]
        )
        
        self.addBox(
            title: "Distance",
            controllers:
            [
                SettingsIntSliderViewController( title: "Default distance:",        settings: self.settings, key: \.predatorSense.defaultDistance,       minValue:  1, maxValue: 300 ),
                SettingsIntSliderViewController( title: "Minimum distance:",        settings: self.settings, key: \.predatorSense.minimumDistance,       minValue:  1, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Maximum distance:",        settings: self.settings, key: \.predatorSense.maximumDistance,       minValue: 20, maxValue: 300 ),
                SettingsIntSliderViewController( title: "Minimum mutation change:", settings: self.settings, key: \.predatorSense.minimumMutationChange, minValue:  1, maxValue: 10 ),
                SettingsIntSliderViewController( title: "Maximum mutation change:", settings: self.settings, key: \.predatorSense.maximumMutationChange, minValue:  1, maxValue: 10 ),
            ]
        )
    }
}
