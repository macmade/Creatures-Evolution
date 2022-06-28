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

public class BackgroundView: NSView
{
    @objc @IBInspectable public dynamic var cornerRadius: Int = 0
    {
        didSet
        {
            self.needsDisplay = true
        }
    }
    
    @objc @IBInspectable public dynamic var backgroundColor: NSColor?
    {
        didSet
        {
            self.needsDisplay = true
        }
    }
    
    @objc @IBInspectable public dynamic var darkBackgroundColor: NSColor?
    {
        didSet
        {
            self.needsDisplay = true
        }
    }
    
    @objc @IBInspectable public dynamic var borderColor: NSColor?
    {
        didSet
        {
            self.needsDisplay = true
        }
    }
    
    @objc @IBInspectable public dynamic var darkBorderColor: NSColor?
    {
        didSet
        {
            self.needsDisplay = true
        }
    }
    
    private var appearanceObserver: NSKeyValueObservation?
    
    public override init( frame: NSRect )
    {
        super.init( frame: frame )
        
        self.appearanceObserver = self.observe( \.effectiveAppearance )
        {
            [ weak self ] _, _ in self?.needsDisplay = true
        }
    }
    
    public required init?( coder: NSCoder )
    {
        super.init( coder: coder )
        
        self.appearanceObserver = self.observe( \.effectiveAppearance )
        {
            [ weak self ] _, _ in self?.needsDisplay = true
        }
    }
    
    public override func draw( _ rect: NSRect )
    {
        super.draw( rect )
        
        let background: NSColor? =
        {
            if self.effectiveAppearance.isDark, let color = self.darkBackgroundColor
            {
                return color
            }
            
            return self.backgroundColor
        }()
        
        let border: NSColor? =
        {
            if self.effectiveAppearance.isDark, let color = self.darkBorderColor
            {
                return color
            }
            
            return self.borderColor
        }()
        
        let path = NSBezierPath( roundedRect: border == nil ? self.bounds : self.bounds.insetBy( dx: 1, dy: 1 ), xRadius: CGFloat( self.cornerRadius ), yRadius: CGFloat( self.cornerRadius ) )
        
        if let color = background
        {
            color.setFill()
            path.fill()
        }
        
        if let color = border
        {
            color.setStroke()
            path.stroke()
        }
    }
}
