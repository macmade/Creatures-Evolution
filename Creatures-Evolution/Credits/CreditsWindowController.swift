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

public class CreditsWindowController: NSWindowController, NSTableViewDelegate, NSTableViewDataSource
{
    @objc private dynamic var items         = [ Credit ]()
    @objc private dynamic var viewController: CreditViewController?
    
    @IBOutlet private var arrayController: NSArrayController!
    @IBOutlet private var tableView:       NSTableView!
    @IBOutlet private var contentView:     NSView!
    
    private var selectionObserver: NSKeyValueObservation?
    
    public override var windowNibName: NSNib.Name
    {
        return "CreditsWindowController"
    }
    
    public override func windowDidLoad()
    { 
        super.windowDidLoad()
        
        self.items = [
            Credit(
                title:           "Creatures Evolution",
                abstract:        "Jean-David Gadina",
                descriptionText: "The Creatures Evolution project, available freely on GitHub.",
                url:             "https://github.com/macmade/Creatures-Evolution.git",
                license:         "MIT",
                licenseFile:     "License-Creatures-Evolution"
            ),
            Credit(
                title:           "Name Corpus",
                abstract:        "Mark Kantrowitz",
                descriptionText: "A list of several thousand male, female, and pet names compiled by Mark Kantrowitz, with some help from Bill Ross.",
                url:             "https://www.cs.cmu.edu/Groups/AI/util/areas/nlp/corpora/names/0.html",
                license:         "Free",
                licenseFile:     "License-NameCorpus"
            ),
        ]
        
        self.selectionObserver = self.arrayController.observe( \.selection )
        {
            [ weak self ] o, c in guard let self = self else { return }
            
            guard let credit = self.arrayController.selectedObjects.first as? Credit else
            {
                self.contentView.subviews.forEach { $0.removeFromSuperview() }
                
                self.viewController = nil
                
                return
            }
            
            let controller = CreditViewController( credit: credit )
            
            self.contentView.addFillingSubview( controller.view, removeAllExisting: true )
            
            self.viewController = controller
        }
        
        self.arrayController.sortDescriptors = [ NSSortDescriptor( key: "title", ascending: true, selector: #selector( NSString.localizedCaseInsensitiveCompare( _: ) ) ) ]
    }
    
    public func tableView( _ tableView: NSTableView, rowViewForRow row: Int ) -> NSTableRowView?
    {
        TableRowView( frame: NSZeroRect )
    }
}
