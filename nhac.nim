import os, strutils, httpclient, sequtils, md5, std/sha1

# Declaring stuff
var client = newHttpClient()
const hashTypes = @["md5", "sha1", "sha256", "sha384", "sha512"]

proc findHash(text, hashType: string) =
    let response = client.getContent("http://hashtoolkit.com/generate-hash/?text=" & text)
    if not response.contains(hashType):
        quit("Error: Hash type not supported\n")
    else:
        # I can't use regex so enjoy this terrible string manipulation to find the end of the result...
        let begindexButNotReally = find(response, toLowerAscii(hashType))
        let realBegindex = begindexButNotReally + find(response[begindexButNotReally .. response.len() - 1], "<span>") + 6
        let endex = realBegindex + find(response[realBegindex .. response.len() - 1], "</span>")
        let result = response[realBegindex .. endex - 1]

        echo "Hash Result: " & result & "\n"

proc decode(hash: string) =
    var hashType: string

    case hash.len()
    of 32: hashType = "md5"
    of 40: hashType = "sha1"
    of 64: hashType = "sha256"
    of 96: hashType = "sha384"
    of 128: hashType = "sha512"
    else: quit("Error: Hash type not supported\n")

    echo "Hash Type: " & hashType 

    let response = client.getContent("http://hashtoolkit.com/reverse-hash/?hash=" & hash)
    if response.contains("No hashes found for"):
        echo "Error: Result not found\n"
    else:
        let begindex = find(response, "text=") + 5
        # More terrible string manipulation, but hey it works
        let endex = begindex + find(response[begindex .. response.len() - 1], "\"")
        let result = response[begindex .. endex - 1]

        echo "Result: " & result & "\n"

proc encode(text, hashType: string) =
    let hashTypeL = toLowerAscii(hashType)
    if any(hashTypes, proc (x: string): bool = return x == hashTypeL):
        case hashTypeL
        of "md5": echo "Result: " & $toMD5(text) & "\n"
        of "sha1": echo "Result: " & $secureHash(text) & "\n"
        else: findHash(text, hashTypeL)
    else:
        quit("Error: Hash function not recognized\n")

proc main() =
    echo """  
      
            oooo                            
            `888                            
ooo. .oo.    888 .oo.    .oooo.    .ooooo.  
`888P"Y88b   888P"Y88b  `P  )88b  d88' `"Y8 
 888   888   888   888   .oP"888  888       
 888   888   888   888  d8(  888  888   .o8 
o888o o888o o888o o888o `Y888""8o `Y8bod8P' 
        
Nim Hasher and Cracker
___________________________________________
    """

    # Incorrect usage/help text
    if paramCount() < 1:
        quit("To decode raw hash: ./nhac -d <hash>\nTo encode raw text: ./nhac -e <text> <type>\nTo decode hash in file: ./nhac -df <path to file>\nTo encode text in file: ./nhac -ef <path to file> <type>\n\nSupported Algorithms: md5, sha1, sha256, sha384, sha512\n")
    if paramStr(1) == "-e":
        if paramCount() < 3:
            quit("Error: Enter some text and a hash function\n")
        else:
            encode(paramStr(2), paramStr(3))
    elif paramStr(1) == "-ef":
        if paramCount() < 3:
            quit("Error: Enter a file and a hash function\n")
        try:
            encode(readFile(paramStr(2)).strip(), paramStr(3))
        except IOError:
            quit("Error: Could not open file\n")
    elif paramStr(1) == "-d":
        try:
            decode(paramStr(2))
        except IndexError:
            quit("Error: Enter a hash to crack\n")
    elif paramStr(1) == "-df":
        # Try to read the file
        if paramCount() < 2:
            quit("Error: Enter a file to read from\n")  
        # Set the hash equal to the file contents and strip the whitespace
        try:
            decode(readFile(paramStr(2)).strip())
        except IOError:
            quit("Error: Could not open file\n")
    else:
        quit("To decode raw hash: ./nhac -d <hash>\nTo encode raw text: ./nhac -e <text>\nTo decode hash in file: ./nhac -df <path to file>\nTo encode text in file: ./nhac -ef <path to file>\n\nSupported Algorithms: md5, sha1, sha256, sha384, sha512\n")

main()
