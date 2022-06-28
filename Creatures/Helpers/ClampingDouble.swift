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

import Foundation

@objc public class ClampingDouble: NSObject
{
    public struct Change
    {
        let old:        Double
        let new:        Double
        let difference: Double
    }
    
    @objc public private( set ) dynamic var value: Double
    
    public var minimumValue: Double?
    public var maximumValue: Double?
    public var onChange:     ( ( Change ) -> Void )?
    
    public init( value: Double )
    {
        self.value = value
    }
    
    final class func +=( left: inout ClampingDouble, right: Double )
    {
        var new = left.value + right
        
        if let minimumValue = left.minimumValue
        {
            new = max( minimumValue, new )
        }
        
        if let maximumValue = left.maximumValue
        {
            new = min( maximumValue, new )
        }
        
        let diff = new - left.value
        
        if diff < 0 || diff > 0
        {
            let change = Change( old: left.value, new: new, difference: diff )
            left.value = new
            
            left.onChange?( change )
        }
    }
    
    final class func -=( left: inout ClampingDouble, right: Double )
    {
        left += -right
    }
    
    final class func ==( left: ClampingDouble, right: Double ) -> Bool
    {
        left.value == right
    }
    
    final class func <( left: ClampingDouble, right: Double ) -> Bool
    {
        left.value < right
    }
    
    final class func >( left: ClampingDouble, right: Double ) -> Bool
    {
        left.value > right
    }
    
    final class func <=( left: ClampingDouble, right: Double ) -> Bool
    {
        left.value <= right
    }
    
    final class func >=( left: ClampingDouble, right: Double ) -> Bool
    {
        left.value >= right
    }
    
    final class func +=( left: inout ClampingDouble, right: Int )
    {
        left += Double( right )
    }
    
    final class func -=( left: inout ClampingDouble, right: Int )
    {
        left -= Double( right )
    }
    
    final class func ==( left: inout ClampingDouble, right: Int ) -> Bool
    {
        left == Double( right )
    }
    
    final class func <( left: inout ClampingDouble, right: Int ) -> Bool
    {
        left < Double( right )
    }
    
    final class func >( left: inout ClampingDouble, right: Int ) -> Bool
    {
        left < Double( right )
    }
    
    final class func <=( left: inout ClampingDouble, right: Int ) -> Bool
    {
        left <= Double( right )
    }
    
    final class func >=( left: inout ClampingDouble, right: Int ) -> Bool
    {
        left >= Double( right )
    }
}
