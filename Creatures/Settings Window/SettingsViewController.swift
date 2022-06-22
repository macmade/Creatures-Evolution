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
    @IBOutlet private var contentView: NSStackView!
    
    @objc public dynamic var settings: Settings
    {
        didSet
        {
            self.controllers.forEach { $0.updateSettings( self.settings ) }
        }
    }
    
    private var controllers = [ SettingsValueViewController ]()
    
    public init( settings: Settings )
    {
        self.settings = settings
        
        super.init( nibName: nil, bundle: nil )
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public func addBox( title: String, controllers: [ SettingsValueViewController ] )
    {
        let box   = NSBox()
        box.title = title
        
        self.contentView.addView( box, in: .top )
        self.contentView.addConstraint( NSLayoutConstraint( item: box, attribute: .left,  relatedBy: .equal, toItem: self.contentView, attribute: .left,  multiplier: 1, constant: 0 ) )
        self.contentView.addConstraint( NSLayoutConstraint( item: box, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1, constant: 0 ) )
        
        let stack                 = NSStackView()
        stack.orientation         = .vertical
        stack.distribution        = .fill
        stack.alignment           = .leading
        stack.spacing             = 8
        stack.detachesHiddenViews = true
        
        stack.setViews( controllers.map { $0.view }, in: .leading )
        box.contentView?.addFillingSubview( stack, insets: NSEdgeInsets( top: 20, left: 20, bottom: 20, right: 20 ), removeAllExisting: true )
        
        self.controllers.append( contentsOf: controllers )
    }
}
