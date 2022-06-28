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

public class GeneStatisticsViewController: NSViewController
{
    @IBOutlet private var graphView: GeneStatisticsGraphView!
    @IBOutlet private var stackView: NSStackView!
    
    @objc public dynamic var data: [ GeneStatisticsData ] = []
    {
        didSet
        {
            self.refresh()
            self.refreshDataOnly()
        }
    }
    
    public override var nibName: NSNib.Name?
    {
        "GeneStatisticsViewController"
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    private func refresh()
    {
        let _ = self.view
        
        let views: [ NSView ] = self.data.map
        {
            data in
            
            let stack                 = NSStackView()
            stack.orientation         = .horizontal
            stack.distribution        = .fill
            stack.alignment           = .centerY
            stack.spacing             = 8
            stack.detachesHiddenViews = true
            
            let checkbox                     = MouseTrackingButton( checkboxWithTitle: data.name, target: self, action: #selector( toggleData( _: ) ) )
            checkbox.controlSize             = .small
            checkbox.state                   = data.display ? .on : .off
            checkbox.cell?.representedObject = data
            
            checkbox.onMouseEnter =
            {
                guard let delegate = NSApp.delegate as? ApplicationDelegate, let mainWindowController = delegate.mainWindowController else
                {
                    return
                }
                
                mainWindowController.highlightGene( data.gene.geneClass )
            }
            
            checkbox.onMouseExit =
            {
                guard let delegate = NSApp.delegate as? ApplicationDelegate, let mainWindowController = delegate.mainWindowController else
                {
                    return
                }
                
                mainWindowController.highlightGene( nil )
            }
            
            let color             = BackgroundView( frame: NSZeroRect )
            color.backgroundColor = data.color
            color.cornerRadius    = 6
            
            color.addConstraint( NSLayoutConstraint( item: color, attribute: .width,  relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12 ) )
            color.addConstraint( NSLayoutConstraint( item: color, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12 ) )
            
            stack.setViews( [ color, checkbox ], in: .leading )
            
            return stack
        }
        
        self.stackView.setViews( views, in: .leading )
    }
    
    public func refreshDataOnly()
    {
        self.graphView.data = self.data
    }
    
    @objc private func toggleData( _ sender: Any? )
    {
        guard let checkbox = sender as? NSControl, let data = checkbox.cell?.representedObject as? GeneStatisticsData else
        {
            NSSound.beep()
            
            return
        }
        
        data.display                = data.display == false
        self.graphView.needsDisplay = true
    }
}
