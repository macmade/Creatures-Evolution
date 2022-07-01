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

public class CreatureStatusGraphView: GraphView
{
    private var data: [ CreatureStatusItem ] = []
    
    public func addData( _ data: CreatureStatusItem )
    {
        if self.data.count == 0 && data.total == 0
        {
            return
        }
        
        self.data.append( data )
        
        self.data         = Array( self.data.suffix( 3600 ) )
        self.needsDisplay = true
    }
    
    public override func draw( _ rect: NSRect )
    {
        self.drawBackground( in: rect )
        self.drawBorder( in: rect )
        
        if self.data.count < 2
        {
            return
        }
        
        let data1 = self.data.map { Double( $0.data1 ) }
        let data2 = self.data.map { Double( $0.data1 + $0.data2 ) }
        let data3 = self.data.map { Double( $0.data1 + $0.data2 + $0.data3 ) }
        let data4 = self.data.map { Double( $0.data1 + $0.data2 + $0.data3 + $0.data4 ) }
        
        if let color = self.data[ 0 ].color4
        {
            self.draw( points: data4, color: color, in: rect.insetBy( dx: 4, dy: 4 ) )
        }
        
        if let color = self.data[ 0 ].color3
        {
            self.draw( points: data3, color: color, in: rect.insetBy( dx: 4, dy: 4 ) )
        }
        
        if let color = self.data[ 0 ].color2
        {
            self.draw( points: data2, color: color, in: rect.insetBy( dx: 4, dy: 4 ) )
        }
        
        if let color = self.data[ 0 ].color1
        {
            self.draw( points: data1, color: color, in: rect.insetBy( dx: 4, dy: 4 ) )
        }
    }
    
    public override func min( in points: [ Double ] ) -> Double
    {
        0
    }
    
    public override func max( in points: [ Double ] ) -> Double
    {
        Double( self.data.reduce( 0 ) { $0 > $1.total ? $0 : $1.total } )
    }
    
    public override func canDrawPoints( _ points: [ Double ] ) -> Bool
    {
        true
    }
}
