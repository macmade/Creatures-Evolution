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

public class GeneticStatisticsWindowController: NSWindowController, NSWindowDelegate
{
    @objc public dynamic var scene: Scene?
    {
        didSet
        {
            self.clear()
            self.update()
        }
    }
    
    private var geneStatisticsController = GeneStatisticsViewController()
    private var data                     = [ GeneStatisticsData ]()
    private var valueGeneControllers     = [ ValueGeneGraphViewController ]()
    private var updateTimer:               Timer?
    
    @IBOutlet private var stackView: NSStackView!
    
    @objc private dynamic var isEmpty = true
    
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
        self.update()
        
        self.window?.delegate = self
        
        if Preferences.shared.firstLaunch
        {
            self.window?.center()
        }
    }
    
    private func clear()
    {
        let _ = self.window
        
        self.geneStatisticsController.data = []
        self.data                          = []
        self.valueGeneControllers          = []
        
        self.stackView.setViews( [], in: .leading )
    }
    
    private func update()
    {
        let _ = self.window
        
        guard let scene = self.scene, scene.isPaused == false else
        {
            return
        }
        
        let remove = [ Mitosis.self, Sex.self, Herbivore.self, Scavenger.self, Predator.self, Vampire.self ]
        
        let enabledGenes = GeneInfo.allGenes( settings: scene.settings ).filter
        {
            info in info.isEnabled && remove.contains { $0 == info.geneClass } == false
        }
        .sorted
        {
            $0.name < $1.name
        }
        
        if enabledGenes.count == 0
        {
            self.isEmpty = true
            
            return
        }
        
        self.isEmpty = false
        
        let creatures = scene.children.compactMap
        {
            $0 as? Creature
        }
        .filter
        {
            $0.isAlive
        }
        
        let genes: [ ( info: GeneInfo, color: NSColor, genes: [ Gene ] ) ] = enabledGenes.enumerated().compactMap
        {
            index, info in
            
            let genes = creatures.compactMap
            {
                $0.genes.first { type( of: $0 ) == info.geneClass }
            }
            
            let n          = Double( enabledGenes.count ) / 2.0
            let i          = Double( index ) < n ? Double( index ) : Double( index ) - n
            let hue        = ( 1.0 / n ) * i
            let saturation = Double( index ) < n ? 1.0 : 0.5
            let brightness = Double( index ) < n ? 1.0 : 0.9
            
            let color = NSColor( calibratedHue: hue, saturation: saturation, brightness: brightness, alpha: 1 )
            
            return ( info, color, genes )
        }
        
        let valueGenes = genes.filter
        {
            $0.info.geneClass.isSubclass( of: DoubleValueGene.self ) || $0.info.geneClass.isSubclass( of: IntValueGene.self )
        }
        
        if self.valueGeneControllers.isEmpty
        {
            self.valueGeneControllers = valueGenes.map
            {
                gene in
                
                let controller = ValueGeneGraphViewController( title: "Average \( gene.info.name )", color: gene.color.withAlphaComponent( 0.75 ) )
                
                controller.onMouseEnter =
                {
                    [ weak self ] in
                    
                    guard let delegate = NSApp.delegate as? ApplicationDelegate, let mainWindowController = delegate.mainWindowController else
                    {
                        return
                    }
                    
                    self?.geneStatisticsController.highlightGene( gene.info.geneClass )
                    mainWindowController.highlightGene( gene.info.geneClass )
                }
                
                controller.onMouseExit =
                {
                    [ weak self ] in
                    
                    guard let delegate = NSApp.delegate as? ApplicationDelegate, let mainWindowController = delegate.mainWindowController else
                    {
                        return
                    }
                    
                    self?.geneStatisticsController.highlightGene( nil )
                    mainWindowController.highlightGene( nil )
                }
                
                return controller
            }
        }
        
        if self.stackView.views.isEmpty
        {
            let even: [ NSView? ] = self.valueGeneControllers.enumerated().filter { $0.offset % 2 == 0 }.map { $1.view }
            var odd : [ NSView? ] = self.valueGeneControllers.enumerated().filter { $0.offset % 2 != 0 }.map { $1.view }
            
            if even.count != odd.count
            {
                odd.append( nil )
            }
            
            let pairs             = zip( even, odd ).map { ( $0, $1 ) }
            var views: [ NSView ] = pairs.map
            {
                let stack                 = NSStackView()
                stack.orientation         = .horizontal
                stack.distribution        = .fillEqually
                stack.alignment           = .centerY
                stack.spacing             = 8
                stack.detachesHiddenViews = true
                
                stack.setViews( [ $0.0, $0.1 ].compactMap { $0 }, in: .leading )
                
                return stack
            }
            
            views.insert( self.geneStatisticsController.view, at: 0 )
            self.stackView.setViews( views, in: .leading )
        }
        
        valueGenes.enumerated().forEach
        {
            self.addData( self.getAverage( genes: $1.genes ), in: self.valueGeneControllers[ $0 ] )
        }
        
        if self.data.isEmpty
        {
            self.data = genes.map
            {
                GeneStatisticsData( name: $0.info.name, color: $0.color, gene: $0.info )
            }
            
            self.geneStatisticsController.data = data
        }
        
        genes.enumerated().forEach
        {
            self.data[ $0 ].data.append( self.getPercentOfActiveGenes( in: $1.genes ) )
            
            self.data[ $0 ].data = self.data[ $0 ].data.suffix( 3600 )
        }
        
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
    
    private func getAverage( genes: [ Gene ] ) -> Double?
    {
        if let genes = genes as? [ DoubleValueGene ]
        {
            return self.getAverage( genes: genes )
        }
        else if let genes = genes as? [ IntValueGene ]
        {
            return self.getAverage( genes: genes )
        }
        
        return nil
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
    
    public func windowDidBecomeKey( _ notification: Notification )
    {
        if notification.object as? NSWindow == self.window
        {
            Preferences.shared.openStatistics = true
        }
    }
    
    public func windowWillClose( _ notification: Notification )
    {
        if let delegate = NSApp.delegate as? ApplicationDelegate, delegate.exiting
        {
            return
        }
        
        if notification.object as? NSWindow == self.window
        {
            Preferences.shared.openStatistics = false
        }
    }
}
