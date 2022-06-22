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

@objc public class SettingsViewController: NSViewController
{
    @objc public dynamic var settings: Settings
    {
        didSet
        {
            self.valueSliderControllers.forEach { $0.updateSettings( self.settings ) }
        }
    }
    
    private var valueSliderControllers = [ SettingsValueViewController ]()
    
    public init( settings: Settings )
    {
        self.settings = settings
        
        super.init( nibName: nil, bundle: nil )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public func setSliders( controllers: [ SettingsValueViewController ], in stackView: NSStackView )
    {
        self.valueSliderControllers.append( contentsOf: controllers )
        stackView.setViews( controllers.map { $0.view }, in: .leading )
    }
}
