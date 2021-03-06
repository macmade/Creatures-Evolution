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

public class NameGenerator
{
    public class Letter
    {
        private static let voyels:     [ Character ] = [ "a", "e", "i", "o", "u", "y" ]
        private static let consonants: [ Character ] = [ "b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z" ]
        
        public  var character:      Character
        private var next:           [ Character ]
        private var nextVoyels:     [ Character ]
        private var nextConsonants: [ Character ]
        
        public init( character: Character )
        {
            self.character      = character
            self.next           = []
            self.nextVoyels     = []
            self.nextConsonants = []
        }
        
        public func add( next: Character )
        {
            if next != self.character
            {
                self.next.append( next )
                
                if Letter.isVoyel( character: next )
                {
                    self.nextVoyels.append( next )
                }
                else
                {
                    self.nextConsonants.append( next )
                }
            }
        }
        
        public func getRandomVoyel() -> Character
        {
            if let letter = self.nextVoyels.randomElement()
            {
                return letter
            }
            
            return Letter.voyels.randomElement()!
        }
        
        public func getRandomConsonant() -> Character
        {
            if let letter = self.nextConsonants.randomElement()
            {
                return letter
            }
            
            return Letter.voyels.randomElement()!
        }
        
        public func getRandomLetter() -> Character
        {
            if let letter = self.next.randomElement()
            {
                return letter
            }
            
            var letters = [ Character ]()
            
            letters.append( contentsOf: Letter.voyels )
            letters.append( contentsOf: Letter.consonants )
            
            return letters.randomElement()!
        }
        
        public class func isVoyel( character: Character ) -> Bool
        {
            return Letter.voyels.contains( character )
        }
        
        public class func isConsonant( character: Character ) -> Bool
        {
            return Letter.consonants.contains( character )
        }
    }
    
    public static let shared = NameGenerator()
    
    private var letters: [ Letter ]    = []
    private var starts:  Set< String > = []
    private var ends:    Set< String > = []
    
    private init()
    {
        let male   = NameGenerator.readNames( source: "names-male" )
        let female = NameGenerator.readNames( source: "names-female" )
        var names  = [ String ]()
        
        names.append( contentsOf: male )
        names.append( contentsOf: female )
        
        names.map
        {
            $0.lowercased()
        }
        .forEach
        {
            if $0.count >= 2
            {
                self.starts.insert( String( $0[ $0.startIndex ..< $0.index( $0.startIndex, offsetBy: 2 ) ] ) )
                self.ends.insert(   String( $0[ $0.index( $0.endIndex, offsetBy: -2 ) ..< $0.endIndex ] ) )
            }
            
            let characters = Array( $0 ).filter
            {
                Letter.isVoyel( character: $0 ) || Letter.isConsonant( character: $0 )
            }
            
            if characters.isEmpty
            {
                return
            }
            
            for i in 0 ..< characters.count
            {
                if i == characters.count - 1
                {
                    break
                }
                
                let character = characters[ i ]
                let next      = characters[ i + 1 ]
                
                if let letter = self.letters.first( where: { $0.character == character } )
                {
                    letter.add( next: next )
                }
                else
                {
                    let letter = Letter( character: character )
                    
                    letter.add( next: next )
                    self.letters.append( letter )
                }
            }
        }
    }
    
    private class func readNames( source: String ) -> [ String ]
    {
        guard let url  = Bundle.main.url( forResource: source, withExtension: "txt" ),
              let data = try? Data( contentsOf: url ),
              let text = String( data: data, encoding: .utf8 )
        else
        {
            return []
        }
        
        return text.split( separator: "\n" ).map
        {
            String( $0 ).trimmingCharacters( in: .whitespacesAndNewlines )
        }
        .filter
        {
            guard let first = $0.first else
            {
                return false
            }
            
            return first != Character( "#" )
        }
    }
    
    public func generate( range: ClosedRange< UInt > ) -> String?
    {
        var name           = self.starts.randomElement() ?? ""
        let length         = Int( UInt.random( in: range ) )
        var voyelCount     = 0
        var consonantCount = 0
        var letter:          Letter?
        
        if length == 0
        {
            return ""
        }
        
        if length == 1
        {
            if let character = self.letters.randomElement()?.character
            {
                return String( character )
            }
            
            return ""
        }
        
        if name.count == 2,
           let first   = name.first,
           let last    = name.last,
           let found   = self.letters.first( where: { $0.character == last } )
        {
            name           = String( first )
            letter         = found
            voyelCount     = Letter.isVoyel(     character: first ) ? 1 : 0
            consonantCount = Letter.isConsonant( character: first ) ? 1 : 0
        }
        
        if letter == nil
        {
            letter         = self.letters.randomElement()
            voyelCount     = 0
            consonantCount = 0
        }
        
        guard var letter = letter else
        {
            return nil
        }
        
        while true
        {
            if name.count == length
            {
                return name.capitalized
            }
            
            if Letter.isVoyel( character: letter.character )
            {
                voyelCount    += 1
                consonantCount = 0
            }
            else
            {
                voyelCount      = 0
                consonantCount += 1
            }
            
            name.append( letter.character )
            
            if name.count == length - 2
            {
                while true
                {
                    if let end   = self.ends.randomElement(),
                       let first = end.first,
                       let last  = end.last
                    {
                        if Letter.isVoyel( character: first ) && Letter.isVoyel( character: last ) && voyelCount != 0
                        {
                            continue
                        }
                        else if Letter.isVoyel( character: first ) && voyelCount == 2
                        {
                            continue
                        }
                        else if Letter.isConsonant( character: first ) && Letter.isConsonant( character: last ) && consonantCount != 0
                        {
                            continue
                        }
                        else if Letter.isConsonant( character: first ) && consonantCount == 2
                        {
                            continue
                        }
                        
                        return name.appending( end ).capitalized
                    }
                }
            }
            
            var nextCharacter: Character
            
            if voyelCount == 2
            {
                nextCharacter = letter.getRandomConsonant()
            }
            else if consonantCount == 2
            {
                nextCharacter = letter.getRandomVoyel()
            }
            else
            {
                nextCharacter = letter.getRandomLetter()
            }
            
            guard let nextLetter = self.letters.first( where: { $0.character == nextCharacter } ) else
            {
                name = ""
                
                continue
            }
            
            letter = nextLetter
        }
    }
}
