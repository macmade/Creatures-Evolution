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

public class CreatureStatusGraphView: NSView
{
    private var data: [ CreatureStatusItem ] = []
    
    public func addData( _ data: CreatureStatusItem )
    {
        self.data.append( data )
        
        self.data         = Array( self.data.suffix( 2000 ) )
        self.needsDisplay = true
    }
    
    public override var isFlipped: Bool
    {
        return false
    }
    
    public override func draw( _ rect: NSRect )
    {
        let border       = NSBezierPath( roundedRect: rect.insetBy( dx: 1, dy: 1 ), xRadius: 10, yRadius: 10 )
        border.lineWidth = 1
        
        NSColor.white.withAlphaComponent( 0.05 ).setFill()
        NSColor.white.setStroke()
        border.fill()
        border.stroke()
        
        if self.data.count < 2
        {
            return
        }
        
        let herbivores = self.data.map { $0.herbivores }
        let scavengers = self.data.map { $0.herbivores + $0.scavengers }
        let predators  = self.data.map { $0.herbivores + $0.scavengers + $0.predators }
        let vampires   = self.data.map { $0.herbivores + $0.scavengers + $0.predators + $0.vampires }
        
        self.draw( points: vampires,   color: NSColor.systemPurple, in: rect.insetBy( dx: 7.5, dy: 7.5 ) )
        self.draw( points: predators,  color: NSColor.systemOrange, in: rect.insetBy( dx: 7.5, dy: 7.5 ) )
        self.draw( points: scavengers, color: NSColor.systemGray,   in: rect.insetBy( dx: 7.5, dy: 7.5 ) )
        self.draw( points: herbivores, color: NSColor.systemGreen,  in: rect.insetBy( dx: 7.5, dy: 7.5 ) )
    }
    
    private func draw( points: [ Int ], color: NSColor, in rect: NSRect )
    {
        if points.count == 0
        {
            return
        }
        
        let origin = rect.origin
        let deltaX = rect.size.width / Double( self.data.count - 1 )
        let max    = self.data.reduce( 0 )
        {
            $0 > $1.total ? $0 : $1.total
        }
        
        let path       = NSBezierPath()
        path.lineWidth = 1
        var i          = 0
        
        points.forEach
        {
            let y = ( Double( $0 ) / Double( max ) ) * rect.size.height
            
            if i == 0
            {
                path.move( to: NSPoint( x: origin.x, y: origin.y + y ) )
            }
            else
            {
                path.line( to: NSPoint( x: origin.x + Double( i ) * deltaX, y: origin.y + y ) )
            }
            
            i += 1
        }
        
        path.line( to: NSPoint( x: origin.x + Double( i - 1 ) * deltaX, y: origin.y ) )
        path.line( to: NSPoint( x: origin.x, y: origin.y ) )
        path.close()
        color.setFill()
        path.fill()
    }
}
