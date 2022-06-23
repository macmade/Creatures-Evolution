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

public class WorldSettingsViewController: SettingsViewController
{
    @objc private dynamic var preview: NSImage?
    
    private var environmentObserver: NSKeyValueObservation?
    private var previewController  = SettingsImageViewController( image: nil, title: "Preview" )
    
    public init( settings: Settings )
    {
        super.init( title: "World", settings: settings, enabled: nil )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func restoreDefaults()
    {
        self.settings.world = WorldSettings()
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        self.updatePreview()
        
        var backgrounds = Constants.backgroundImages.enumerated().map { ( $1, $0 ) }
        
        backgrounds.insert( ( "Random", -1 ), at: 0 )
        backgrounds.insert( ( "--",     -2 ), at: 1 )
        
        self.addBox(
            title: "General",
            controllers:
            [
                SettingsIntMenuViewController( title: "Environment:",          settings: self.settings, key: \.world.environment, values: backgrounds ),
                SettingsBoolViewController(    title: "Show creatures names:", settings: self.settings, key: \.world.showCreaturesNames, style: .asSwitch ),
            ]
        )
        
        self.addController( self.previewController )
    }
    
    public override func updateSettings( settings: Settings )
    {
        super.updateSettings( settings: settings )
        self.updatePreview()
    }
    
    private func updatePreview()
    {
        self.environmentObserver = self.settings.observe( \.world.environment )
        {
            [ weak self ] _, _ in self?.updatePreview()
        }
        
        let index = self.settings.world.environment
        
        if index < 0 || index >= Constants.backgroundImages.count
        {
            self.preview = nil
        }
        else
        {
            self.preview = NSImage( named: Constants.backgroundImages[ index ] )
        }
        
        self.previewController.image = preview
    }
}
