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

public class CreditViewController: NSViewController
{
    @objc public private( set ) dynamic var credit:      Credit
    @objc private               dynamic var licenseText: NSAttributedString?
    
    @IBOutlet private var textView: NSTextView!
    
    public init( credit: Credit )
    {
        self.credit = credit
        
        super.init( nibName: nil, bundle: nil )
    }
    
    required init?( coder: NSCoder )
    {
        return nil
    }
    
    public override var nibName: NSNib.Name?
    {
        "CreditViewController"
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.textView.textContainerInset = NSMakeSize( 10, 10 )
        
        if let text = self.credit.licenseText
        {
            self.licenseText = NSAttributedString( string: text, attributes: [ .foregroundColor : NSColor.textColor ] )
        }
    }
    
    @IBAction private func openURL( _ sender: Any? )
    {
        guard let url = self.credit.url else
        {
            NSSound.beep()
            
            return
        }
        
        NSWorkspace.shared.open( url )
    }
}
