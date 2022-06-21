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
    @objc private dynamic var data:             CreatureStatusItem?
    @objc private dynamic var highlightedItem:  CreatureStatusChartViewItem?
    @objc private dynamic var highlightedColor: NSColor?
    
    @IBOutlet private var arrayController: NSArrayController?
    @IBOutlet private var dataView:        CreatureStatusChartView?
    
    public override var nibName: NSNib.Name?
    {
        "CreatureStatusChartViewController"
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    public func setData( _ data: CreatureStatusItem )
    {
        self.data = data
        let items = [
            CreatureStatusChartViewItem( title: "Herbivores", count: data.herbivores, color: NSColor.systemGreen,  gene: Herbivore.self ),
            CreatureStatusChartViewItem( title: "Scavengers", count: data.scavengers, color: NSColor.systemGray,   gene: Scavenger.self ),
            CreatureStatusChartViewItem( title: "Predators",  count: data.predators,  color: NSColor.systemOrange, gene: Predator.self ),
            CreatureStatusChartViewItem( title: "Vampires",   count: data.vampires,   color: NSColor.systemPurple, gene: Vampire.self ),
        ]
        
        self.dataView?.setData( total: data.total, items: items )
    }
    
    public func tableView( _ tableView: NSTableView, shouldSelectRow row: Int ) -> Bool
    {
        return false
    }
    
    public func tableView( _ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int ) -> NSView?
    {
        let view  = tableView.makeView( withIdentifier: tableColumn?.identifier ?? NSUserInterfaceItemIdentifier( "" ), owner: self )
        let badge = view?.findSubview( type: BadgeView.self, recursively: true ) as? BadgeView
        
        if let items = self.arrayController?.arrangedObjects as? [ CreatureStatusChartViewItem ], row < items.count
        {
            badge?.color = items[ row ].color
        }
        
        return view
    }
    
    public func tableView( _ tableView: NSTableView, rowViewForRow row: Int ) -> NSTableRowView?
    {
        let view                 = TableRowView( frame: NSZeroRect )
        let mainWindowController = self.view.window?.windowController as? MainWindowController
        
        view.onMouseEnter =
        {
            [ weak self ] in guard let self = self else { return }
            
            self.dataView?.highlightItem( at: row )
            
            if let items = self.arrayController?.arrangedObjects as? [ CreatureStatusChartViewItem ], row < items.count
            {
                self.highlightedItem  = items[ row ]
                self.highlightedColor = items[ row ].color
            }
            
            mainWindowController?.highlightGene( self.highlightedItem?.gene )
        }
        
        view.onMouseExit =
        {
            [ weak self ] in guard let self = self else { return }
            
            self.dataView?.highlightItem( at: nil )
            
            self.highlightedItem  = nil
            self.highlightedColor = nil
            
            mainWindowController?.highlightGene( nil )
        }
        
        return view
    }
}
