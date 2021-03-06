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

public class StatsViewController: NSViewController
{
    @objc public dynamic var alive       = 0
    @objc public dynamic var dead        = 0
    @objc public dynamic var generations = 0
    
    @objc public private( set ) dynamic var scene: Scene
    
    private var creatureDieObserver:               Any?
    private var creatureBornObserver:              Any?
    private var timer:                             Timer?
    private var classStatusViewController        = CreatureStatusChartViewController()
    private var reproductionStatusViewController = CreatureStatusChartViewController()
    
    @IBOutlet private var creatureClassStatusView:        NSView?
    @IBOutlet private var creatureClassGraphView:         CreatureStatusGraphView?
    @IBOutlet private var creatureReproductionStatusView: NSView?
    @IBOutlet private var creatureReproductionGraphView:  CreatureStatusGraphView?
    
    public init( scene: Scene )
    {
        self.scene = scene
        
        super.init( nibName: nil, bundle: nil )
        
        self.creatureBornObserver = NotificationCenter.default.addObserver( forName: Constants.creatureBornNotification, object: nil, queue: nil )
        {
            [ weak self ] _ in self?.update()
        }
        
        self.creatureDieObserver = NotificationCenter.default.addObserver( forName: Constants.creatureDieNotification, object: nil, queue: nil )
        {
            [ weak self ] _ in self?.dead += 1
        }
        
        self.timer = Timer.scheduledTimer( withTimeInterval: 1, repeats: true )
        {
            [ weak self ] _ in self?.update()
        }
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    deinit
    {
        self.timer?.invalidate()
    }
    
    public override var nibName: NSNib.Name?
    {
        "StatsViewController"
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        self.update()
    }
    
    public func update()
    {
        guard let delegate             = NSApp.delegate as? ApplicationDelegate,
              let mainWindowController = delegate.mainWindowController
        else
        {
            return
        }
        
        let creatures   = scene.children.compactMap { $0 as? Creature }
        let generations = creatures.reduce( 0 ) { $1.generation > $0 ? $1.generation : $0 }
        self.alive      = creatures.filter { $0.isAlive }.count
        
        if generations > self.generations
        {
            self.generations = generations
        }
        
        if mainWindowController.isPaused
        {
            return
        }
        
        if let chart = self.creatureClassStatusView, let graph = self.creatureClassGraphView
        {
            if chart.subviews.count == 0
            {
                chart.addFillingSubview( self.classStatusViewController.view, removeAllExisting: true )
            }
            
            let data    = CreatureStatusItem()
            data.data1  = creatures.compactMap { $0.hasActiveGene( Herbivore.self ) ? $0 : nil }.count
            data.data2  = creatures.compactMap { $0.hasActiveGene( Scavenger.self ) ? $0 : nil }.count
            data.data3  = creatures.compactMap { $0.hasActiveGene( Predator.self  ) ? $0 : nil }.count
            data.data4  = creatures.compactMap { $0.hasActiveGene( Vampire.self   ) ? $0 : nil }.count
            data.title1 = "Herbivores"
            data.title2 = "Scavengers"
            data.title3 = "Predators"
            data.title4 = "Vampires"
            data.color1 = NSColor.systemGreen
            data.color2 = NSColor.systemGray
            data.color3 = NSColor.systemOrange
            data.color4 = NSColor.systemPurple
            data.gene1  = Herbivore.self
            data.gene2  = Scavenger.self
            data.gene3  = Predator.self
            data.gene4  = Vampire.self
            
            self.classStatusViewController.setData( data )
            graph.addData( data )
        }
        
        if let chart = self.creatureReproductionStatusView, let graph = self.creatureReproductionGraphView
        {
            if chart.subviews.count == 0
            {
                chart.addFillingSubview( self.reproductionStatusViewController.view, removeAllExisting: true )
            }
            
            let data   = CreatureStatusItem()
            data.data1 = creatures.compactMap { $0.hasActiveGene( Mitosis.self ) ? $0 : nil }.count
            data.data2 = creatures.compactMap { $0.hasActiveGene( Sex.self     ) ? $0 : nil }.count
            data.title1 = "Mitosis"
            data.title2 = "Sex"
            data.color1 = NSColor.systemBlue
            data.color2 = NSColor.systemPink
            data.gene1  = Mitosis.self
            data.gene2  = Sex.self
            
            self.reproductionStatusViewController.setData( data )
            graph.addData( data )
        }
    }
}
