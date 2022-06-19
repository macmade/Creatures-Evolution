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

public class FoodDetailViewController: DetailViewController
{
    public init( food: Food )
    {
        super.init( node: food )
    }
    
    public required init?( coder: NSCoder )
    {
        nil
    }
    
    public override var nibName: NSNib.Name?
    {
        "FoodDetailViewController"
    }
    
    public override func update()
    {
        super.update()
        
        if let _ = self.node as? Plant
        {
            self.title = "Plant"
        }
        else if let _ = self.node as? Meat
        {
            self.title = "Meat"
        }
        else
        {
            self.title = "Food"
        }
    }
    
    @IBAction public func increaseEnergy( _ sender: Any? )
    {
        ( self.node as? Food )?.energy += 1
    }
    
    @IBAction public func decreaseEnergy( _ sender: Any? )
    {
        ( self.node as? Food )?.energy -= 1
    }
    
    @IBAction public func kill( _ sender: Any? )
    {
        ( self.node as? Food )?.remove()
    }
}
