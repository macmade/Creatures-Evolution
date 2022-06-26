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
    
    private var geneStatisticsController    = GeneStatisticsViewController()
    private var averageAbnegationController = ValueGeneGraphViewController( title: "Average Abnegation", color: NSColor.systemPurple )
    private var averageAttackController     = ValueGeneGraphViewController( title: "Average Attack",     color: NSColor.systemRed )
    private var averageDefenseController    = ValueGeneGraphViewController( title: "Average Defense",    color: NSColor.systemBlue )
    private var averageDigestionController  = ValueGeneGraphViewController( title: "Average Digestion",  color: NSColor.systemGreen )
    private var averageSpeedController      = ValueGeneGraphViewController( title: "Average Speed",      color: NSColor.systemYellow )
    private var data                        = [ GeneStatisticsData ]()
    private var updateTimer:                  Timer?
    
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
            self.geneStatisticsController.view,
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
        
        self.data = []
    }
    
    private func update()
    {
        guard let scene = self.scene, scene.isPaused == false else
        {
            return
        }
        
        let creatures = scene.children.compactMap
        {
            $0 as? Creature
        }
        .filter
        {
            $0.isAlive
        }
        
        let abnegation:    [ Abnegation ]    = self.getGene( in: creatures )
        let attack:        [ Attack ]        = self.getGene( in: creatures )
        let defense:       [ Defense ]       = self.getGene( in: creatures )
        let digestion:     [ Digestion ]     = self.getGene( in: creatures )
        let speed:         [ Speed ]         = self.getGene( in: creatures )
        let manureSense:   [ ManureSense ]   = self.getGene( in: creatures )
        let meatSense:     [ MeatSense ]     = self.getGene( in: creatures )
        let plantSense:    [ PlantSense ]    = self.getGene( in: creatures )
        let predatorSense: [ PredatorSense ] = self.getGene( in: creatures )
        let preySense:     [ PreySense ]     = self.getGene( in: creatures )
        let sexSense:      [ SexSense ]      = self.getGene( in: creatures )
        let vampireSense:  [ VampireSense ]  = self.getGene( in: creatures )
        
        self.addData( self.getAverage( genes: abnegation ), in: self.averageAbnegationController )
        self.addData( self.getAverage( genes: attack     ), in: self.averageAttackController )
        self.addData( self.getAverage( genes: defense    ), in: self.averageDefenseController )
        self.addData( self.getAverage( genes: digestion  ), in: self.averageDigestionController )
        self.addData( self.getAverage( genes: speed      ), in: self.averageSpeedController )
        
        if self.data.isEmpty
        {
            self.data =
            [
                GeneStatisticsData( name: "Abnegation",     color: NSColor.systemPurple ),
                GeneStatisticsData( name: "Attack",         color: NSColor.systemRed ),
                GeneStatisticsData( name: "Defense",        color: NSColor.systemBlue ),
                GeneStatisticsData( name: "Digestion",      color: NSColor.systemGreen ),
                GeneStatisticsData( name: "Speed",          color: NSColor.systemYellow ),
                GeneStatisticsData( name: "Manure Sense",   color: NSColor.systemBrown ),
                GeneStatisticsData( name: "Meat Sense",     color: NSColor.systemGray ),
                GeneStatisticsData( name: "Plant Sense",    color: NSColor.systemMint ),
                GeneStatisticsData( name: "Predator Sense", color: NSColor.systemOrange ),
                GeneStatisticsData( name: "Prey Sense",     color: NSColor.systemCyan ),
                GeneStatisticsData( name: "Sex Sense",      color: NSColor.systemPink ),
                GeneStatisticsData( name: "Vampire Sense",  color: NSColor.systemIndigo ),
            ]
            
            self.geneStatisticsController.data = data
        }
        
        self.data[  0 ].data.append( self.getPercentOfActiveGenes( in: abnegation ) )
        self.data[  1 ].data.append( self.getPercentOfActiveGenes( in: attack ) )
        self.data[  2 ].data.append( self.getPercentOfActiveGenes( in: defense ) )
        self.data[  3 ].data.append( self.getPercentOfActiveGenes( in: digestion ) )
        self.data[  4 ].data.append( self.getPercentOfActiveGenes( in: speed ) )
        self.data[  5 ].data.append( self.getPercentOfActiveGenes( in: manureSense ) )
        self.data[  6 ].data.append( self.getPercentOfActiveGenes( in: meatSense ) )
        self.data[  7 ].data.append( self.getPercentOfActiveGenes( in: plantSense ) )
        self.data[  8 ].data.append( self.getPercentOfActiveGenes( in: predatorSense ) )
        self.data[  9 ].data.append( self.getPercentOfActiveGenes( in: preySense ) )
        self.data[ 10 ].data.append( self.getPercentOfActiveGenes( in: sexSense ) )
        self.data[ 11 ].data.append( self.getPercentOfActiveGenes( in: vampireSense ) )
        
        self.data[  0 ].data = self.data[  0 ].data.suffix( 3600 )
        self.data[  1 ].data = self.data[  1 ].data.suffix( 3600 )
        self.data[  2 ].data = self.data[  2 ].data.suffix( 3600 )
        self.data[  3 ].data = self.data[  3 ].data.suffix( 3600 )
        self.data[  4 ].data = self.data[  4 ].data.suffix( 3600 )
        self.data[  5 ].data = self.data[  5 ].data.suffix( 3600 )
        self.data[  6 ].data = self.data[  6 ].data.suffix( 3600 )
        self.data[  7 ].data = self.data[  7 ].data.suffix( 3600 )
        self.data[  8 ].data = self.data[  8 ].data.suffix( 3600 )
        self.data[  9 ].data = self.data[  9 ].data.suffix( 3600 )
        self.data[ 10 ].data = self.data[ 10 ].data.suffix( 3600 )
        self.data[ 11 ].data = self.data[ 11 ].data.suffix( 3600 )
        
        self.geneStatisticsController.refreshDataOnly()
    }
    
    private func getGene< T: Gene >( in creatures: [ Creature ] ) -> [ T ]
    {
        creatures.compactMap
        {
            $0.genes.first { $0 is T } as? T
        }
    }
    
    private func getPercentOfActiveGenes< T: Gene >( in genes: [ T ] ) -> Double
    {
        if genes.count == 0
        {
            return 0
        }
        
        let active = genes.filter { $0.isActive }
        
        return ( Double( active.count ) / Double( genes.count ) ) * 100.0
    }
    
    private func addData( _ data: Double?, in controller: ValueGeneGraphViewController )
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
    
    private func getAverage( genes: [ DoubleValueGene ] ) -> Double?
    {
        let genes = genes.filter { $0.isActive }
        
        if genes.count == 0
        {
            return nil
        }
        
        return genes.reduce( 0.0 ) { $0 + $1.value } / Double( genes.count )
    }
    
    private func getAverage( genes: [ IntValueGene ] ) -> Double?
    {
        let genes = genes.filter { $0.isActive }
        
        if genes.count == 0
        {
            return nil
        }
        
        return genes.reduce( 0.0 ) { $0 + Double( $1.value ) } / Double( genes.count )
    }
}
