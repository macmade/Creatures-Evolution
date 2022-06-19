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

public class CreatureStatusChartView: NSView
{
    private var total:     Int?
    private var items:     [ CreatureStatusItem ]?
    private var highlight: Int?
    
    public func setData( total: Int, items: [ CreatureStatusItem ] )
    {
        self.total    = total
        self.items    = items
        let remaining = items.reduce( total ) { $0 - $1.count }
        
        if remaining > 0
        {
            self.items?.insert( CreatureStatusItem( title: nil, count: remaining, color: NSColor.white ), at: 0 )
        }
        
        self.needsDisplay = true
    }
    
    public func highlightItem( at index: Int? )
    {
        self.highlight    = index
        self.needsDisplay = true
    }
    
    public override var isFlipped: Bool
    {
        return true
    }
    
    public override func draw( _ rect: NSRect )
    {
        guard let total = self.total, let items = self.items, total > 0 else
        {
            let size       = min( rect.size.width, rect.size.height )
            let rect       = NSMakeRect( rect.origin.x, rect.origin.y, size, size ).insetBy( dx: 4, dy: 4 )
            let path       = NSBezierPath( ovalIn: rect )
            path.lineWidth = 8
            
            NSColor.white.setStroke()
            path.stroke()
            
            return
        }
        
        let center = NSMakePoint( rect.origin.x + ( rect.size.width / 2 ), rect.origin.y + ( rect.size.height / 2 ) )
        let radius = min( rect.size.width / 2, rect.size.height / 2 )
        var start  = CGFloat( -90.0 )
        var i      = 0
        
        for item in items
        {
            if item.count == 0
            {
                i += 1
                
                continue
            }
            
            let ratio = CGFloat( total ) / CGFloat( item.count )
            let path  = NSBezierPath()
            let end   = start + ( 360.0 / ratio )
            
            path.move( to: center )
            path.appendArc( withCenter: center, radius: radius, startAngle: start, endAngle: end )
            path.close()
            
            let clip: NSBezierPath = NSBezierPath( rect: rect )
            let mask: NSBezierPath =
            {
                if let highlight = self.highlight, highlight == i
                {
                    return NSBezierPath( ovalIn: rect.insetBy( dx: 12, dy: 12 ) )
                }
                
                return NSBezierPath( ovalIn: rect.insetBy( dx: 8, dy: 8 ) )
            }()
            
            clip.append( mask.reversed )
            clip.setClip()
            
            item.color.setFill()
            path.fill()
            
            start = end
            i    += 1
        }
    }
}
