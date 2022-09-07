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

extension Bundle
{
    var bundleShortVersionString: String?
    {
        self.object( forInfoDictionaryKey: "CFBundleShortVersionString" ) as? String
    }
    
    var bundleVersion: String?
    {
        self.object( forInfoDictionaryKey: "CFBundleVersion" ) as? String
    }
    
    var bundleName: String?
    {
        self.object( forInfoDictionaryKey: "CFBundleName" ) as? String
    }
    
    var humanReadableCopyright: String?
    {
        self.object( forInfoDictionaryKey: "NSHumanReadableCopyright" ) as? String
    }
    
    var humanReadableVersion: String?
    {
        guard let version = self.bundleShortVersionString, version.isEmpty == false else
        {
            return "0.0.0"
        }
        
        if let build = self.bundleVersion, build.isEmpty == false
        {
            return "\( version ) (\( build ))"
        }
        
        return version
    }
}
