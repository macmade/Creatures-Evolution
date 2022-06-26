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

public class GeneticStatisticsGraphViewController: NSViewController
{
    @IBOutlet private var graphView: GraphView!
    @IBOutlet private var valueView: BackgroundView!
    
    @objc public private( set ) dynamic var color:         NSColor
    @objc public private( set ) dynamic var currentValue = 0.0
    @objc public                dynamic var maximumValue = 0.0 { didSet { self.graphView.maximumValue = self.maximumValue } }
    @objc public                dynamic var minimumValue = 0.0 { didSet { self.graphView.minimumValue = self.minimumValue } }
    
    init( title: String, color: NSColor )
    {
        self.color = color
        
        super.init( nibName: nil, bundle: nil )
        
        self.title = title
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    public override var nibName: NSNib.Name?
    {
        "GeneticStatisticsGraphViewController"
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.graphView.color           = self.color
        self.valueView.backgroundColor = self.color
    }
    
    public func addData( _ data: Double )
    {
        let _ = self.view
        
        self.graphView.addData( data )
        
        self.currentValue = data
    }
    
    public func clear()
    {
        let _ = self.view
        
        self.graphView.clear()
        
        self.currentValue = 0
        self.maximumValue = 0
        self.minimumValue = 0
    }
}
