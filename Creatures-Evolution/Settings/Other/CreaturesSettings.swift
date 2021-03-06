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

public class CreaturesSettings: NSObject, Codable
{
    @objc public enum PopulationLimitStrategy: Int, Codable
    {
        case killRandom
        case preventBirth
    }
    
    @objc public dynamic var initialAmount               = 5
    @objc public dynamic var populationLimit             = 500
    @objc public dynamic var populationLimitStrategy     = 0
    @objc public dynamic var generateRandomNames         = true
    @objc public dynamic var initialEnergy               = 1
    @objc public dynamic var energyNeededToGrow          = 2
    @objc public dynamic var growthEnergyCost            = 1
    @objc public dynamic var energyDecreaseAmount        = 1
    @objc public dynamic var energyDecreaseInterval      = 15
    @objc public dynamic var energyDecreaseIntervalRange = 5
    @objc public dynamic var maximumEnergy               = 20
}
