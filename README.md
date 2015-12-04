# monkeychunker
Chunk up and process data from Twitter streaming API.

#NOTE: config.yaml.sample has the config file format and instructions on how to set it up for your own use. Copy it to config.yaml and populate the 
connection info for your Twitter development account to try it out.

This script looks for config.yaml in the current folder by default.

#Original description:
As a quick tech evaluation I'd like you to use the Twitter streaming API (statuses/sample) to collect 5 minutes of tweets.
 Obtain a total word count, filter out "stop words" (words like "and", "the", "me", etc -- useless words),
 and present the 10 most frequent words in those 5 minutes of tweets. 

Please don't copy and paste any code, but of course you can do whatever research necessary.
 Your code should be clear to follow, with explanatory comments where necessary. 

Let me know if you have any questions about this (and also please confirm that you understand the project),
 and I look forward to seeing what you come up with!

Optional Part B) How would you implement it so that if you had to stop the program and restart,
 it could pick up from the total word counts that you started from?



 #####

 Several ways to do this. For a command line tool like this, the simplest option would be 
 to capture signals such as SIGINT (interrupt signal) or SIGTSTP (temporary interrupt signal)
 once these signals are received, the word counts could be dumped to a temp file. Code could them be added 
 to read this file on startup and delete it once the contents are read in.

 If we did this, it would also be a good idea to dump how much time was remaining to a file so on startup, 
 it would know how much longer to run.

 If this same type of code was meant to run as a background daemon all the time, it would be better if it 
 was set up to accept some kind of input from other processes (maybe via interprocess communication) to 
 incidate when it should start & stop and how often it should snapshot its progress to some kind of data store (file system or database)