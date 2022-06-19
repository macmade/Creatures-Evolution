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

public class CreatureStatusChartViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource
{
    @objc private dynamic var total:            Int
    @objc private dynamic var items:            [ CreatureStatusItem ]
    @objc private dynamic var highlightedItem:  CreatureStatusItem?
    @objc private dynamic var highlightedColor: NSColor?
    
    @IBOutlet private var arrayController: NSArrayController?
    @IBOutlet private var dataView:        CreatureStatusChartView?
    
    public init( items: [ CreatureStatusItem ], total: Int = 0 )
    {
        self.items = items
        self.total = total
        
        super.init( nibName: nil, bundle: nil )
    }
    
    public required init?( coder: NSCoder )
    {
        return nil
    }
    
    public override var nibName: NSNib.Name?
    {
        "CreatureStatusChartViewController"
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dataView?.setData( total: self.total, items: self.items )
    }
    
    public func setData( total: Int, items: [ CreatureStatusItem ] )
    {
        self.total = total
        self.items = items
        
        self.dataView?.setData( total: self.total, items: self.items )
    }
    
    public func tableView( _ tableView: NSTableView, shouldSelectRow row: Int ) -> Bool
    {
        return false
    }
    
    public func tableView( _ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int ) -> NSView?
    {
        let view  = tableView.makeView( withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier( "" ), owner: self )
        let badge = view?.findSubview( type: BadgeView.self, recursively: true ) as? BadgeView
        
        if let items = self.arrayController?.arrangedObjects as? [ CreatureStatusItem ], row < items.count
        {
            badge?.color = items[ row ].color
        }
        
        return view
    }
    
    public func tableView( _ tableView: NSTableView, rowViewForRow row: Int ) -> NSTableRowView?
    {
        let view = TableRowView( frame: NSZeroRect )
        
        view.onMouseEnter =
        {
            [ weak self ] in guard let self = self else { return }
            
            self.dataView?.highlightItem( at: row )
            
            if let items = self.arrayController?.arrangedObjects as? [ CreatureStatusItem ], row < items.count
            {
                self.highlightedItem  = items[ row ]
                self.highlightedColor = items[ row ].color
            }
        }
        
        view.onMouseExit =
        {
            [ weak self ] in guard let self = self else { return }
            
            self.dataView?.highlightItem( at: nil )
            
            self.highlightedItem  = nil
            self.highlightedColor = nil
        }
        
        return view
    }
}
