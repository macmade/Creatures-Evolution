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

public class CannibalSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Cannibal", settings: settings, enabled: \.cannibal.isEnabled )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.cannibal = CannibalSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.helpText = "Creatures evolving this gene will be able to eat creatures of the same class.\nOnly effective for creatures having evolved the predator or vampire gene."
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsBoolViewController( title: "Activate gene at start", settings: self.settings, key: \.cannibal.isActive ),
                SettingsBoolViewController( title: "Allow gene to regress",  settings: self.settings, key: \.cannibal.canRegress ),
                SettingsSeparatorViewController(),
                SettingsGeneActivationViewController( title: "Activates:",   gene: Cannibal.self, settings: self.settings, key: \.cannibal.activates ),
                SettingsGeneActivationViewController( title: "Deactivates:", gene: Cannibal.self, settings: self.settings, key: \.cannibal.deactivates ),
            ]
        )
        
        self.addBox(
            title: "Behavior",
            controllers:
            [
                SettingsBoolViewController( title: "Can eat parents",  settings: self.settings, key: \.cannibal.canEatParents ),
                SettingsBoolViewController( title: "Can eat children", settings: self.settings, key: \.cannibal.canEatChildren ),
                SettingsBoolViewController( title: "Can eat siblings", settings: self.settings, key: \.cannibal.canEatSiblings ),
            ]
        )
    }
}
