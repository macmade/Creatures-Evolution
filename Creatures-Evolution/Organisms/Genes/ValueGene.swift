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
import SpriteKit

public class ValueGene< T: Numeric & Comparable >: Gene
{
    public override var canIncreaseOrDecreaseValue: Bool
    {
        true
    }
    
    public var value: T = 0
    
    public var defaultValue:          T { 0 }
    public var defaultValueRange:     T { 0 }
    public var minimumValue:          T { 0 }
    public var maximumValue:          T { 0 }
    public var minimumMutationChange: T { 0 }
    public var maximumMutationChange: T { 0 }
    public var increaseAmount:        T { 0 }
    
    public override init( active: Bool, settings: Settings )
    {
        super.init( active: active, settings: settings )
        
        self.value = self.defaultValue + self.random( in: 0 ... self.defaultValueRange )
    }
    
    public init( active: Bool, settings: Settings, value: T )
    {
        super.init( active: active, settings: settings )
        
        self.value = value
    }
    
    public func random( in range: ClosedRange< T > ) -> T
    {
        0
    }
    
    public override func mutate() -> Bool
    {
        if self.isActive == false
        {
            self.isActive = true
            
            return true
        }
        
        if self.canRegress && Bool.random()
        {
            self.isActive = false
            
            return true
        }
        
        if self.minimumMutationChange > self.maximumMutationChange
        {
            return false
        }
        
        let change = self.random( in: self.minimumMutationChange ... self.maximumMutationChange )
        
        if Bool.random()
        {
            self.value += change
        }
        else
        {
            self.value -= change
        }
        
        if self.value < self.minimumValue
        {
            self.value = self.minimumValue
        }
        
        if self.value > self.maximumValue
        {
            self.value = self.maximumValue
        }
        
        return true
    }
    
    public override func increaseValue()
    {
        self.willChangeValue( for: \.details )
        
        let value  = self.value + self.increaseAmount
        self.value = value > self.maximumValue ? self.maximumValue : value
        
        self.didChangeValue( for: \.details )
    }
    
    public override func decreaseValue()
    {
        self.willChangeValue( for: \.details )
        
        let value  = self.value - self.increaseAmount
        self.value = value < self.minimumValue ? self.minimumValue : value
        
        self.didChangeValue( for: \.details )
    }
}
