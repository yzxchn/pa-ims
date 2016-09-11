<a href="https://codeclimate.com/github/yzxchn/pa-ims"><img src="https://codeclimate.com/github/yzxchn/pa-ims/badges/gpa.svg" /></a>

I divided the problem in about three parts:

1. The IMS class, which contains the main loop, and the parsing method for user commands. It also has methods for verifying the validity of the commands, and those that facilitate the interactions between this class and the MusicStorage class.
2. The MusicStorage class, it initializes a PStore file, it contains a hash of track number to Track objects, a hash of artist ID to Artist objects, and an array of Track objects for storing last played tracks. There are also methods for basic reading and manipulations of the storage file.Basically, this class serves as a interface between the storage file and the IMS main class.
3. The Artist and Track classes, they are simple classes for packaging information about an artist or a track.

I misunderstood the problem instructions at first, and I designed the MusicStorage class that it reads and writes to the pstore file constantly, instead of writing at the end. I fixed this problem in a new music_storage file.
