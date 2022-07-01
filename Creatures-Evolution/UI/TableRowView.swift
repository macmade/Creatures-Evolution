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

public class TableRowView: NSTableRowView
{
    private var trackingArea: NSTrackingArea?
    
    public var onMouseEnter: ( () -> Void )?
    public var onMouseExit:  ( () -> Void )?
    
    private var alternate: Bool?
    
    @objc private dynamic var mouseOver = false
    {
        didSet
        {
            self.needsDisplay = true
        }
    }
    
    public convenience init( frame: NSRect, alternate: Bool )
    {
        self.init( frame: frame )
        
        self.alternate = alternate
    }
    
    public override init( frame: NSRect )
    {
        super.init( frame: frame )
    }
    
    required public init?( coder: NSCoder )
    {
        super.init( coder: coder )
    }
    
    public override func updateTrackingAreas()
    {
        super.updateTrackingAreas()
        
        if let trackingArea = self.trackingArea
        {
            self.removeTrackingArea( trackingArea )
        }
        
        let trackingArea  = NSTrackingArea( rect: self.bounds, options: [ .activeInActiveApp, .mouseEnteredAndExited ], owner: self, userInfo: nil )
        self.trackingArea = trackingArea
        
        self.addTrackingArea( trackingArea )
    }
    
    public override func mouseEntered( with event: NSEvent )
    {
        super.mouseEntered( with: event )
        self.onMouseEnter?()
        
        self.mouseOver = true
    }
    
    public override func mouseExited( with event: NSEvent )
    {
        super.mouseExited( with: event )
        self.onMouseExit?()
        
        self.mouseOver = false
    }
    
    public override func drawBackground( in rect: NSRect )
    {
        if self.mouseOver
        {
            let color = NSColor.controlAccentColor.withAlphaComponent( 0.2 )
            let path  = NSBezierPath( roundedRect: rect, xRadius: 6, yRadius: 6 )
            
            color.setFill()
            path.fill()
        }
        else if let alternate = self.alternate
        {
            let colors = NSColor.alternatingContentBackgroundColors
            
            if colors.count < 2
            {
                return
            }
            
            let color = alternate ? colors[ 1 ] : colors[ 0 ]
            let path  = NSBezierPath( roundedRect: rect, xRadius: 6, yRadius: 6 )
            
            color.setFill()
            path.fill()
        }
    }
    
    public override func drawSelection( in rect: NSRect )
    {
        let color = NSColor.controlAccentColor
        let path  = NSBezierPath( roundedRect: rect, xRadius: 6, yRadius: 6 )
        
        color.setFill()
        path.fill()
    }
}
