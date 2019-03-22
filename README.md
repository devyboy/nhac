# Nim Hasher and Cracker
**Nhac** is a simple command line application that allows you to **hash text** and also try to **crack hashes** that you've "acquired". The cracking **takes seconds** since **no hash tables or dictionaries** are built in; all the work is outsourced.
##  Pronunciation
The 'h' is silent so **nhac** is pronounced */nak/*. Like when you have a *knack* for programming. (I don't)
## Installation
**Nhac** was written in the **Nim** programming language which is a low level language disguised as a high level one. It compiles to **C** so it produces **extremely fast binaries with zero dependencies.** 

To **compile a Nim file**, you need to **install Nim** on your machine. There are **lots of ways** to do this so just go to the website and go nuts: [https://nim-lang.org/install.html](https://nim-lang.org/install.html)

After you've added **Nim** to your **PATH**, all you need to do is `nim compile nhac.nim` and it should spit out a nice **executable** for you to run.
## Usage
There is help text built in but I guess I'll repeat myself here.

**Hash raw text:** `./nhac -e <text> <algorithm>`<br/>
**Hash text from a file:** `./nhac -ef <path to file> <algorithm>`

**Crack raw hash:** `./nhac -d <hash>`<br/>
**Crack hash from file:** `./nhac -df <path to file>`

('e' stands for encode, 'd' stands for decode)

## Supported Hashing Algorithms

 - md5
 - sha1
 - sha256
 - sha384
 - sha512
## What's Next
 - The file commands only work if the file contains just the hash or just the text and nothing else because I'm bad at regex
 - Add more cracking sources since the cracking only consults one database and I want more coverage
 - Support for more algorithms probably


