import os, strutils, httpclient, terminal, sequtils

# Declaring stuff
var filename : string
var hash : string
var hashType: string
var client = newHttpClient()
var result : string
const hashTypes = @["md5", "sha1", "sha256", "sha384", "sha512"]

echo """    
            oooo                            
            `888                            
ooo. .oo.    888 .oo.    .oooo.    .ooooo.  
`888P"Y88b   888P"Y88b  `P  )88b  d88' `"Y8 
 888   888   888   888   .oP"888  888       
 888   888   888   888  d8(  888  888   .o8 
o888o o888o o888o o888o `Y888""8o `Y8bod8P' 
        
Nim Hasher and Cracker
"""

# Incorrect usage/help text
if paramCount() < 1:
    quit("Usage for raw hash: ./hash <hash>\nUsage for hash in file: ./hash -f <path to file>")
# If they used the file flag...
if paramStr(1) == "-f":
    # Try to read the file
    try:
        filename = paramStr(2)
    # Error if they used the file flag without actually giving one
    except IndexError:
        quit("Please enter a file to read from")  
    # Set the hash equal to the file contents and strip the whitespace
    try:
        hash = readFile(filename).strip()
    except IOError:
        quit("Could not open file")
elif paramStr(1) == "-h":
    if any(hashTypes, proc (x: string): bool = return x == paramStr(2)):
        
    else:
        quit("This hash type is not supported")
else:
    # If no file or hash flag, just take the 2nd arg as the hash
    hash = paramStr(1)
# Determine what kind of hash it is based on the length
case hash.len()
of 32: hashType = "md5"
of 40: hashType = "sha1"
of 64: hashType = "sha256"
of 96: hashType = "sha384"
of 128: hashType = "sha512"
else: quit("This hash type is not supported")

echo "Hash Type: " & hashType

let response = client.getContent("http://hashtoolkit.com/reverse-hash/?hash=" & hash)
if response.contains("No hashes found for"):
    echo "Result not found."
else:
    # Find where in the HTML response is the result (probably a better way to do this)
    let begindex = find(response, "text=") + 5
    # I can't use regex so enjoy this terrible string manipulation to find the end quote of the result...
    let endex = begindex + find(response[begindex .. response.len() - 1], "\"")
    result = response[begindex .. endex - 1]

    echo "Hash Found!"
    echo "Result: " & result & "\n"
