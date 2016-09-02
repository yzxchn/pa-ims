<a href="https://codeclimate.com/github/yzxchn/pa-ims"><img src="https://codeclimate.com/github/yzxchn/pa-ims/badges/gpa.svg" /></a>

I divided the problem in about three parts:

1. The IMS class, which contains the main loop, and the parsing method for user commands. It also has methods for verifying the validity of the commands, and those that facilitate the interactions between this class and the MusicStorage class.
2. The MusicStorage class, it initializes two PStore files, one for storing mappings from track number to Track objects, the other for storing mappings from artist IDs to Artist objects. There are also methods for basic reading and manipulations of the storage files.Basically, this class serves as a interface between the storage files and the IMS main class.
3. The Artist and Track classes, they are simple classes for packaging information about an artist or a track.

One thing I noticed while completing this assignment is that, PStore doesn't seem to have methods for getting a list of all the keys, or the size of the storage, so it was hard to get information such as the total number of tracks from the storage. I overcame this problem by maintain a mapping from :track_list to an array which stores references to all the added track objects in the tracks storage file, so that I can retreive the number of tracks added more easily. This doesn't seem to be the best method, but it did solve the problem.
