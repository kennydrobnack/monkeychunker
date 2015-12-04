Kenny's notes:

This is just sample code. If this was meant for production use, several improvements could be made:

1. Caching. At least periodically snapshot word counts to local file.

2. Splitting up processing to multiple threads/processes if we wanted to capture all of it. One process to capture, one to process.

3. Ideally we could send it commands at runtime to indicate if it should run longer, run shorter, pause, or complete.

4. If I had to do this again, I would have unit tested against a small subset of pre-defined data. Possibly saving 20 or 30 tweets off to a file and working off of those for testing.

5. Better error handling.

6. Ability to pull in encrypted private keys at deploy time.