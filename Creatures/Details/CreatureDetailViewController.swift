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

public class CreatureDetailViewController: DetailViewController, NSTableViewDelegate, NSTableViewDataSource
{
    @objc private dynamic var genes: [ Gene ]
    
    @IBOutlet private var genesController: NSArrayController!
    
    private var nameObserver: NSKeyValueObservation?
    
    public init( creature: Creature )
    {
        self.genes = []
        
        super.init( node: creature )
        
        self.nameObserver = creature.observe( \.customName )
        {
            [ weak self ] _, _ in self?.update()
        }
    }
    
    public required init?( coder: NSCoder )
    {
        nil
    }
    
    public override var nibName: NSNib.Name?
    {
        "CreatureDetailViewController"
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        self.update()
    }
    
    public func tableView( _ tableView: NSTableView, rowViewForRow row: Int ) -> NSTableRowView?
    {
        TableRowView( frame: NSZeroRect )
    }
    
    public override func update()
    {
        super.update()
        
        if let creature = self.node as? Creature
        {
            self.genes = creature.genes.filter { $0.isActive }
            self.title = creature.customName ?? "Creature"
        }
    }
    
    @IBAction public func increaseEnergy( _ sender: Any? )
    {
        ( self.node as? Creature )?.energy += 1
    }
    
    @IBAction public func decreaseEnergy( _ sender: Any? )
    {
        ( self.node as? Creature )?.energy -= 1
    }
    
    @IBAction public func kill( _ sender: Any? )
    {
        guard let creature = self.node as? Creature else
        {
            NSSound.beep()
            
            return
        }
        
        creature.die( dropFood: true )
        EventLog.shared.killed( creature: creature, by: nil )
    }
    
    @IBAction public func editName( _ sender: Any? )
    {
        guard let creature = self.node as? Creature else
        {
            NSSound.beep()
            
            return
        }
        
        let controller = EditNameWindowController( creature: creature )
        
        guard let window = self.view.window, let sheet = controller.window else
        {
            NSSound.beep()
            
            return
        }
        
        window.beginSheet( sheet )
        {
            response in
            
            if response != .OK
            {
                return
            }
            
            creature.customName = controller.name.isEmpty ? nil : controller.name
        }
    }
    
    @IBAction public func removeGene( _ sender: Any? )
    {
        guard let creature = self.node as? Creature else
        {
            NSSound.beep()
            
            return
        }
        
        guard let gene = self.genesController.selectedObjects.first as? Gene else
        {
            NSSound.beep()
            
            return
        }
        
        gene.isActive = false
        
        self.willChangeValue( for: \.node )
        self.didChangeValue(  for: \.node )
        creature.updateTexture()
        self.update()
    }
    
    @IBAction public func addGene( _ sender: Any? )
    {
        guard let creature = self.node as? Creature else
        {
            NSSound.beep()
            
            return
        }
        
        let controller = AddGeneWindowController( creature: creature )
        
        guard let window = self.view.window, let sheet = controller.window else
        {
            NSSound.beep()
            
            return
        }
        
        window.beginSheet( sheet )
        {
            response in
            
            if response != .OK
            {
                return
            }
            
            guard let gene = controller.selectedGene else
            {
                return
            }
            
            gene.isActive = true
            
            EvolutionHelper.deactivateConflictingGenes( gene: gene, in: creature.genes )
            
            self.willChangeValue( for: \.node )
            self.didChangeValue(  for: \.node )
            creature.updateTexture()
            self.update()
        }
    }
}
