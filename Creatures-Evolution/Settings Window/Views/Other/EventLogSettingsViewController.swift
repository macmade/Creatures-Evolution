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

public class EventLogSettingsViewController: SettingsViewController
{
    public init( settings: Settings )
    {
        super.init( title: "Event Log", settings: settings, enabled: nil )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.eventLog = EventLogSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsIntSliderViewController( title: "Maximum entries:", settings: self.settings, key: \.eventLog.maximumEntries, minValue: 10, maxValue: 100000 )
            ]
        )
        
        self.addBox(
            title: "Events",
            controllers:
            [
                SettingsBoolViewController( title: "Mutations",        settings: self.settings, key: \.eventLog.logMutations,       style: .asCheckbox ),
                SettingsBoolViewController( title: "Energy changes",   settings: self.settings, key: \.eventLog.logEnergyChanges,   style: .asCheckbox ),
                SettingsBoolViewController( title: "Energy transfers", settings: self.settings, key: \.eventLog.logEnergyTransfers, style: .asCheckbox ),
                SettingsBoolViewController( title: "Births",           settings: self.settings, key: \.eventLog.logBirths,          style: .asCheckbox ),
                SettingsBoolViewController( title: "Kills",            settings: self.settings, key: \.eventLog.logKills,           style: .asCheckbox ),
                SettingsBoolViewController( title: "Deaths",           settings: self.settings, key: \.eventLog.logDeaths,          style: .asCheckbox ),
                SettingsBoolViewController( title: "Combats",          settings: self.settings, key: \.eventLog.logCombats,         style: .asCheckbox ),
            ]
        )
    }
}
