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

public class AttackSettings: NSObject, Codable
{
    @objc public dynamic var isEnabled              = true
    @objc public dynamic var isActive               = false
    @objc public dynamic var canRegress             = true
    @objc public dynamic var activates              = [ String ]()
    @objc public dynamic var deactivates            = [ String ]()
    @objc public dynamic var requires               = [ String ]()
    @objc public dynamic var defaultMultiplier      = 1.0
    @objc public dynamic var defaultMultiplierRange = 0.5
    @objc public dynamic var minimumMultiplier      = 0.1
    @objc public dynamic var maximumMultiplier      = 5.0
    @objc public dynamic var minimumMutationChange  = 0.2
    @objc public dynamic var maximumMutationChange  = 0.5
    @objc public dynamic var chanceIfSmaller        = 30
    @objc public dynamic var chanceIfSameSize       = 60
    @objc public dynamic var chanceIfBigger         = 90
    @objc public dynamic var energyCostSuccess      = 0
    @objc public dynamic var energyCostFailure      = 0
}
