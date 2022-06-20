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
    @objc public dynamic var alive = 0
    @objc public dynamic var dead  = 0
    
    private var creatureDieObserver:   Any?
    private var creatureBornObserver:  Any?
    private var timer:                 Timer?
    private var statusViewController = CreatureStatusChartViewController()
    
    @IBOutlet private var creatureStatusView: NSView?
    @IBOutlet private var creatureGraphView:  CreatureStatusGraphView?
    
    public override init( nibName: NSNib.Name?, bundle: Bundle? )
    {
        super.init( nibName: nibName, bundle: bundle )
        
        self.creatureBornObserver = NotificationCenter.default.addObserver( forName: Constants.creatureBornNotification, object: nil, queue: nil )
        {
            _ in self.update()
        }
        
        self.creatureDieObserver = NotificationCenter.default.addObserver( forName: Constants.creatureDieNotification, object: nil, queue: nil )
        {
            _ in self.dead += 1
        }
        
        self.timer = Timer.scheduledTimer( withTimeInterval: 1, repeats: true )
        {
            _ in self.update()
        }
    }
    
    required init?( coder: NSCoder )
    {
        nil
    }
    
    @objc public dynamic var scene: Scene?
    {
        didSet
        {
            self.update()
        }
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
        guard let scene = self.scene, let mainWindowController = self.view.window?.windowController as? MainWindowController else
        {
            return
        }
        
        let creatures = scene.children.compactMap { $0 as? Creature }.filter { $0.isAlive }
        self.alive    = creatures.count
        
        if mainWindowController.isPaused
        {
            return
        }
        
        if let chart = self.creatureStatusView, let graph = self.creatureGraphView
        {
            if chart.subviews.count == 0
            {
                chart.addFillingSubview( self.statusViewController.view, removeAllExisting: true )
            }
            
            let data        = CreatureStatusItem()
            data.herbivores = creatures.compactMap { $0.hasActiveGene( Herbivore.self ) ? $0 : nil }.count
            data.scavengers = creatures.compactMap { $0.hasActiveGene( Scavenger.self ) ? $0 : nil }.count
            data.predators  = creatures.compactMap { $0.hasActiveGene( Predator.self  ) ? $0 : nil }.count
            data.vampires   = creatures.compactMap { $0.hasActiveGene( Vampire.self   ) ? $0 : nil }.count
            
            self.statusViewController.setData( data )
            graph.addData( data )
        }
    }
}
