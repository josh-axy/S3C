# S3C
This is the Star Citizen Cache Cleaner script. I have opted to put this item in a repo to facilitate updates and distribution of files more easily.

For what to expect when you run it. I'm not a great speaker, I prefer to sit in the back corner of a server room doing my own thing but I will get you the information you need.

Script Demo Vid: https://youtu.be/_6ZV40YbdW4

The SC Cache Cleaner script can be ran from anywhere, on first run it requests user input to create a "Config.txt" file in the same directory the script is located. With that in mind just place the script anywhere you feel comfortible and run it, proceeding through the first time setup prompts as they appear.

Should you make a mistake and select the wrong folder don't fret, the script checks for the existence of specifically named folders it is looking to clean up before taking any action. A wrong folder will result in the script simply not cleaning the cache, not deleting random files.

To undo a selection mistake, the most simple route is to delete the Config.txt the script generates and run it again to get the setup prompts.


[Status update]
Added 3.17 clearing functionality.

05-25-2022: Manifold-Consortium created some nice changes to the 3.17 local app data clearer code. Tested, Merged.

05-25-2022: Found where script would erroneously skip cleaning local app data if game client was listed as being on a drive different than C:. Patched.
