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

@objc public class CreatureStatusItem: NSObject
{
    @objc public dynamic var data1 = 0
    @objc public dynamic var data2 = 0
    @objc public dynamic var data3 = 0
    @objc public dynamic var data4 = 0
    
    @objc public dynamic var title1 = ""
    @objc public dynamic var title2 = ""
    @objc public dynamic var title3 = ""
    @objc public dynamic var title4 = ""
    
    @objc public dynamic var color1: NSColor?
    @objc public dynamic var color2: NSColor?
    @objc public dynamic var color3: NSColor?
    @objc public dynamic var color4: NSColor?
    
    @objc public dynamic var gene1: AnyClass?
    @objc public dynamic var gene2: AnyClass?
    @objc public dynamic var gene3: AnyClass?
    @objc public dynamic var gene4: AnyClass?
    
    @objc public var total: Int
    {
        self.data1 + self.data2 + self.data3 + self.data4
    }
}
