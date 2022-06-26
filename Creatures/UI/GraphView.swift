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
    private var data: [ Double ] = []
    
    @objc public dynamic var color        = NSColor.clear { didSet { self.needsDisplay = true } }
    @objc public dynamic var fill         = true          { didSet { self.needsDisplay = true } }
    @objc public dynamic var lineWidth    = 1.0           { didSet { self.needsDisplay = true } }
    
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
    
    public override func draw( _ rect: NSRect )
    {
        self.drawBackground( in: rect )
        self.drawBorder( in: rect )
        self.draw( points: self.data, color: self.color, in: rect.insetBy( dx: 4, dy: 4 ) )
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
        
        NSColor.white.setStroke()
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
    
    public func draw( points: [ Double ], color: NSColor, in rect: NSRect )
    {
        if points.count < 2
        {
            return
        }
        
        let max = self.max( in: points )
        let min = self.min( in: points )
        let dx  = rect.size.width / Double( points.count - 1 )
        
        let path       = NSBezierPath()
        path.lineWidth = 1
        var i          = 0
        
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
        
        if self.fill
        {
            path.line( to: NSPoint( x: rect.origin.x + Double( i - 1 ) * dx, y: rect.origin.y ) )
            path.line( to: NSPoint( x: rect.origin.x, y: rect.origin.y ) )
            path.close()
            color.setFill()
            path.fill()
        }
        else
        {
            path.lineWidth = self.lineWidth
            
            color.setStroke()
            path.stroke()
        }
    }
}
