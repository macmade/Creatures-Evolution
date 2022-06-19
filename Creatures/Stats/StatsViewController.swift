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
    @objc public dynamic var time  = 0
    @objc public dynamic var alive = 0
    @objc public dynamic var dead  = 0
    
    var creatureDieObserver:  Any?
    var creatureBornObserver: Any?
    var timer:                Timer?
    var start:                Date?
    
    @objc public dynamic var isPaused: Bool = false
    {
        didSet
        {
            self.update()
            
            if self.isPaused
            {
                self.start = nil
            }
            else
            {
                self.start = Date()
            }
        }
    }
    
    public override init( nibName: NSNib.Name?, bundle: Bundle? )
    {
        self.start = Date()
        
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
    }
    
    public func update()
    {
        guard let scene = self.scene else
        {
            return
        }
        
        self.alive = scene.children.compactMap { $0 as? Creature }.count
        
        if let date = self.start
        {
            let now    = Date()
            self.time += Int( now.timeIntervalSince( date ) * 1000.0 )
            self.start = now
        }
    }
}
