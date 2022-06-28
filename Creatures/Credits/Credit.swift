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

import Foundation

public class Credit: NSObject
{
    @objc public dynamic var title:           String
    @objc public dynamic var abstract:        String
    @objc public dynamic var descriptionText: String
    @objc public dynamic var url:             URL?
    @objc public dynamic var license:         String?
    @objc public dynamic var licenseText:     String?
    
    public init( title: String, abstract: String, descriptionText: String, url: String?, license: String?, licenseFile: String? )
    {
        self.title           = title
        self.abstract        = abstract
        self.descriptionText = descriptionText
        self.license         = license
        
        if let url = url
        {
            self.url = URL( string: url )
        }
        
        if let licenseFile = licenseFile,
           let url         = Bundle.main.url( forResource: licenseFile, withExtension: "txt" ),
           let data        = try? Data( contentsOf: url ),
           let text        = String( data: data, encoding: .utf8 )
        {
            self.licenseText = text
        }
    }
}
