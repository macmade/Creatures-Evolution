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

public class SettingsImageViewController: NSViewController
{
    @objc private dynamic var image: NSImage?
    
    @IBOutlet private var imageView: NSImageView!
    
    public init( image: NSImage?, title: String? )
    {
        super.init( nibName: nil, bundle: nil )
        
        self.title = title
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    public func setImage( _ image: NSImage?, animated: Bool )
    {
        let _ = self.view
        
        self.image = image
        
        guard animated else
        {
            self.imageView.image = image
            
            return
        }
        
        let transition            = CATransition()
        transition.duration       = 1
        transition.type           = .fade
        transition.timingFunction = CAMediaTimingFunction( name: CAMediaTimingFunctionName.easeInEaseOut )
        
        self.imageView.layer?.add( transition, forKey: nil )
        
        self.imageView.image = image
    }
}
