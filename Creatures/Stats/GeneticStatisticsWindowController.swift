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

public class GeneticStatisticsWindowController: NSWindowController
{
    @objc public dynamic var scene: Scene?
    {
        didSet
        {
            self.clear()
            self.update()
        }
    }
    
    private var averageAbnegationController = GeneticStatisticsGraphViewController( title: "Average Abnegation", color: NSColor.systemPurple )
    private var averageAttackController     = GeneticStatisticsGraphViewController( title: "Average Attack",     color: NSColor.systemRed )
    private var averageDefenseController    = GeneticStatisticsGraphViewController( title: "Average Defense",    color: NSColor.systemBlue )
    private var averageDigestionController  = GeneticStatisticsGraphViewController( title: "Average Digestion",  color: NSColor.systemGreen )
    private var averageSpeedController      = GeneticStatisticsGraphViewController( title: "Average Speed",      color: NSColor.systemYellow )
    
    private var updateTimer: Timer?
    
    @IBOutlet private var stackView: NSStackView!
    
    public init()
    {
        super.init( window: nil )
        
        self.updateTimer = Timer.scheduledTimer( withTimeInterval: 1, repeats: true )
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
        self.updateTimer?.invalidate()
    }
    
    public override var windowNibName: NSNib.Name?
    {
        "GeneticStatisticsWindowController"
    }
    
    public override func windowDidLoad()
    {
        super.windowDidLoad()
        
        let views =
        [
            self.averageAbnegationController.view,
            self.averageAttackController.view,
            self.averageDefenseController.view,
            self.averageDigestionController.view,
            self.averageSpeedController.view,
        ]
        
        self.stackView.setViews( views, in: .leading )
    }
    
    private func clear()
    {
        self.averageAbnegationController.clear()
        self.averageAttackController.clear()
        self.averageDefenseController.clear()
        self.averageDigestionController.clear()
        self.averageSpeedController.clear()
    }
    
    private func update()
    {
        guard let scene = self.scene, scene.isPaused == false else
        {
            return
        }
        
        let abnegation: [ Abnegation ] = self.getGene()
        let attack:     [ Attack ]     = self.getGene()
        let defense:    [ Defense ]    = self.getGene()
        let digestion:  [ Digestion ]  = self.getGene()
        let speed:      [ Speed ]      = self.getGene()
        
        self.addData( self.getAverage( genes: abnegation ), in: self.averageAbnegationController )
        self.addData( self.getAverage( genes: attack     ), in: self.averageAttackController )
        self.addData( self.getAverage( genes: defense    ), in: self.averageDefenseController )
        self.addData( self.getAverage( genes: digestion  ), in: self.averageDigestionController )
        self.addData( self.getAverage( genes: speed      ), in: self.averageSpeedController )
    }
    
    private func addData( _ data: Double?, in controller: GeneticStatisticsGraphViewController )
    {
        if let data = data
        {
            controller.addData( data )
        }
        else if controller.isEmpty == false
        {
            controller.addData( controller.currentValue )
        }
    }
    
    private func getGene< T: Gene >() -> [ T ]
    {
        guard let scene = self.scene else
        {
            return []
        }
        
        return scene.children.compactMap
        {
            $0 as? Creature
        }
        .filter
        {
            $0.isAlive
        }
        .compactMap
        {
            $0.genes.first { $0 is T } as? T
        }
        .filter
        {
            $0.isActive
        }
    }
    
    private func getAverage( genes: [ DoubleValueGene ] ) -> Double?
    {
        if genes.count == 0
        {
            return nil
        }
        
        return genes.reduce( 0.0 ) { $0 + $1.value } / Double( genes.count )
    }
    
    private func getAverage( genes: [ IntValueGene ] ) -> Double?
    {
        if genes.count == 0
        {
            return nil
        }
        
        return genes.reduce( 0.0 ) { $0 + Double( $1.value ) } / Double( genes.count )
    }
}
