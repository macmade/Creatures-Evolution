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

public class GeneStatisticsGraphView: GraphView
{
    @objc public dynamic var data: [ GeneStatisticsData ] = []
    {
        didSet
        {
            self.needsDisplay = true
        }
    }
    
    public override func max( in points: [ Double ] ) -> Double
    {
        100
    }
    
    public override func min( in points: [ Double ] ) -> Double
    {
        0
    }
    
    public override func draw( _ rect: NSRect )
    {
        self.style = .line
        
        self.drawBackground( in: rect )
        self.drawBorder( in: rect )
        self.drawLines( in: rect.insetBy( dx: 4, dy: 4 ) )
        
        self.data.forEach
        {
            if $0.data.count < 2 || $0.display == false
            {
                return
            }
            
            if $0.data.reduce( 0, { $0 + $1 } ) == 0
            {
                return
            }
            
            var rect         = rect.insetBy( dx: 4, dy: 4 )
            rect.origin.x   += 30
            rect.size.width -= 60
            
            self.draw( points: $0.data, color: $0.color, in: rect )
        }
    }
    
    private func drawLines( in rect: NSRect )
    {
        for i in 0 ..< 19
        {
            if i == 0 || i == 10
            {
                continue
            }
            
            let y     = rect.origin.y + ( Double( i ) * ( rect.size.height / 10 ) )
            let rect  = NSRect( x: rect.origin.x, y: y, width: rect.size.width, height: 1 )
            
            NSColor.controlTextColor.withAlphaComponent( 0.1 ).setFill()
            rect.fill()
            
            let attributes: [ NSAttributedString.Key : Any ] =
            [
                .foregroundColor : NSColor.controlTextColor.withAlphaComponent( 0.2 ),
                .font            : NSFont.monospacedSystemFont( ofSize: 10, weight: .regular ),
            ]
            
            let percent = "\( i * 10 )%" as NSString
            
            percent.draw( at: NSPoint( x: rect.origin.x + 5, y: y ), withAttributes: attributes )
            percent.draw( at: NSPoint( x: ( rect.origin.x + rect.self.width ) - 25, y: y ), withAttributes: attributes )
        }
    }
}
