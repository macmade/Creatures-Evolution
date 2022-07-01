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

public class CombatSettings: NSObject, Codable
{
    @objc public dynamic var chanceIfSmaller:           Int
    @objc public dynamic var chanceIfSameSize:          Int
    @objc public dynamic var chanceIfBigger:            Int
    @objc public dynamic var recoveryTimeAttackSuccess: Int
    @objc public dynamic var recoveryTimeAttackFailure: Int
    @objc public dynamic var energyCostAttackSuccess:   Int
    @objc public dynamic var energyCostAttackFailure:   Int
    @objc public dynamic var energyCostDefenseSuccess:  Int
    @objc public dynamic var energyCostDefenseFailure:  Int
    
    public init(
        chanceIfSmaller:            Int,
        chanceIfSameSize:           Int,
        chanceIfBigger:             Int,
        recoveryTimeAttackSuccess:  Int,
        recoveryTimeAttackFailure:  Int,
        energyCostAttackSuccess:    Int,
        energyCostAttackFailure:    Int,
        energyCostDefenseSuccess:   Int,
        energyCostDefenseFailure:   Int
    )
    {
        self.chanceIfSmaller           = chanceIfSmaller
        self.chanceIfSameSize          = chanceIfSameSize
        self.chanceIfBigger            = chanceIfBigger
        self.recoveryTimeAttackSuccess = recoveryTimeAttackSuccess
        self.recoveryTimeAttackFailure = recoveryTimeAttackFailure
        self.energyCostAttackSuccess   = energyCostAttackSuccess
        self.energyCostAttackFailure   = energyCostAttackFailure
        self.energyCostDefenseSuccess  = energyCostDefenseSuccess
        self.energyCostDefenseFailure  = energyCostDefenseFailure
    }
}
