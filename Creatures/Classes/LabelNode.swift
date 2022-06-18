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

public class LabelNode: SKNode
{
    private var textNode:   SKLabelNode
    private var shadowNode: SKLabelNode?
    
    public init( text: String, fontName: String?, fontSize: Double?, textColor: NSColor, shadowColor: NSColor? )
    {
        let fontSize = fontSize ?? NSFont.systemFontSize
        let fontName = fontName ?? NSFont.monospacedSystemFont( ofSize: fontSize, weight: .regular ).fontName
        
        let textNode       = SKLabelNode()
        textNode.text      = text
        textNode.fontName  = fontName
        textNode.fontSize  = fontSize
        textNode.fontColor = textColor
        textNode.zPosition = 10
        self.textNode      = textNode
        
        super.init()
        self.addChild( textNode )
        
        
        if let shadowColor = shadowColor
        {
            let shadowNode       = SKLabelNode()
            shadowNode.text      = text
            shadowNode.fontName  = fontName
            shadowNode.fontSize  = fontSize
            shadowNode.fontSize  = fontSize
            shadowNode.fontColor = shadowColor
            shadowNode.position  = NSPoint( x: 0.5, y: -0.5 )
            shadowNode.alpha     = 1
            shadowNode.zPosition = 0
            self.shadowNode      = shadowNode
            
            self.addChild( shadowNode )
        }
        
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
}
