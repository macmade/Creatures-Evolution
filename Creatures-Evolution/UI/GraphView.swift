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

public class GraphView: NSView
{
    @objc public enum Style: Int
    {
        case line
        case fill
        case gradient
        case gradientWithLine
    }
    
    private var trackingArea: NSTrackingArea?
    private var data:         [ Double ] = []
    
    @objc public dynamic var color        = NSColor.clear { didSet { self.needsDisplay = true } }
    @objc public dynamic var style        = Style.fill    { didSet { self.needsDisplay = true } }
    @objc public dynamic var lineWidth    = 1.0           { didSet { self.needsDisplay = true } }
    
    public var onMouseEnter: ( () -> Void )?
    public var onMouseExit:  ( () -> Void )?
    
    public func addData( _ data: Double )
    {
        self.data.append( data )
        
        self.data         = Array( self.data.suffix( 3600 ) )
        self.needsDisplay = true
    }
    
    public func clear()
    {
        self.data.removeAll()
        
        self.needsDisplay = true
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
    }
    
    public override func mouseExited( with event: NSEvent )
    {
        super.mouseExited( with: event )
        self.onMouseExit?()
    }
    
    public override func draw( _ rect: NSRect )
    {
        self.drawBackground( in: rect )
        self.drawBorder( in: rect )
        self.draw( points: self.data, color: self.color, in: rect.insetBy( dx: 4, dy: 4 ), lineWidth: self.lineWidth )
    }
    
    public func drawBackground( in rect: NSRect )
    {
        let border       = NSBezierPath( roundedRect: rect.insetBy( dx: 1, dy: 1 ), xRadius: 5, yRadius: 5 )
        border.lineWidth = 1
        
        NSColor.white.withAlphaComponent( 0.05 ).setFill()
        border.fill()
    }
    
    public func drawBorder( in rect: NSRect )
    {
        let border       = NSBezierPath( roundedRect: rect.insetBy( dx: 1, dy: 1 ), xRadius: 5, yRadius: 5 )
        border.lineWidth = 1
        
        NSColor.disabledControlTextColor.setStroke()
        border.stroke()
    }
    
    public func max( in points: [ Double ] ) -> Double
    {
        points.reduce( -Double.infinity ) { Swift.max( $0, $1 ) }
    }
    
    public func min( in points: [ Double ] ) -> Double
    {
        points.reduce(  Double.infinity ) { Swift.min( $0, $1 ) }
    }
    
    public func canDrawPoints( _ points: [ Double ] ) -> Bool
    {
        points.count > 1
    }
    
    public func draw( points: [ Double ], color: NSColor, in rect: NSRect, lineWidth: Double? = nil, alpha: Double = 1 )
    {
        if self.canDrawPoints( points ) == false
        {
            return
        }
        
        let max = self.max( in: points )
        let min = self.min( in: points )
        let dx  = rect.size.width / Double( points.count - 1 )
        
        let path          = NSBezierPath()
        path.lineCapStyle = .round
        var i             = 0
        
        points.forEach
        {
            let x     = rect.origin.x + Double( i ) * dx
            let v     = ( $0 - min ) / ( max - min )
            let y     = min == max ? rect.origin.y : rect.origin.y + v * rect.size.height
            
            if i == 0
            {
                path.move( to: NSPoint( x: x, y: y ) )
            }
            else
            {
                path.line( to: NSPoint( x: x, y: y ) )
            }
            
            i += 1
        }
        
        if self.style == .fill
        {
            path.line( to: NSPoint( x: rect.origin.x + Double( i - 1 ) * dx, y: rect.origin.y ) )
            path.line( to: NSPoint( x: rect.origin.x, y: rect.origin.y ) )
            path.close()
            color.withAlphaComponent( alpha ).setFill()
            path.fill()
        }
        else if self.style == .gradient
        {
            path.line( to: NSPoint( x: rect.origin.x + Double( i - 1 ) * dx, y: rect.origin.y ) )
            path.line( to: NSPoint( x: rect.origin.x, y: rect.origin.y ) )
            path.close()
            
            let gradient = NSGradient( colors: [ color, color.withAlphaComponent( 0 ) ] )
            
            gradient?.draw( in: path, angle: -90 )
        }
        else if self.style == .gradientWithLine
        {
            let fill     = path.copy() as! NSBezierPath
            let gradient = NSGradient( colors: [ color.withAlphaComponent( alpha / 2.0 ), color.withAlphaComponent( 0 ) ] )
            
            fill.line( to: NSPoint( x: rect.origin.x + Double( i - 1 ) * dx, y: rect.origin.y ) )
            fill.line( to: NSPoint( x: rect.origin.x, y: rect.origin.y ) )
            fill.close()
            
            if let lineWidth = lineWidth
            {
                path.lineWidth = lineWidth
            }
            else
            {
                path.lineWidth = self.lineWidth
            }
            
            gradient?.draw( in: fill, angle: -90 )
            color.withAlphaComponent( alpha ).setStroke()
            path.stroke()
        }
        else
        {
            if let lineWidth = lineWidth
            {
                path.lineWidth = lineWidth
            }
            else
            {
                path.lineWidth = self.lineWidth
            }
            
            color.withAlphaComponent( alpha ).setStroke()
            path.stroke()
        }
    }
}
