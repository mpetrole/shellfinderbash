# shellfinderbash
This is a wrapper for dirsearch with some extras

You probably will have to set the script to executable by opening a terminal and setting your working directory to this one and then running "sudo chmod +x ./search.sh" in this directory.

Recursive will map the site. It takes a lot longer! The old behavior was to search recursively without option.

If you get a bunch of error code and you see something about too many redirects, that's a limitation of the underlying brute forcing script. There's nothing that can be done in that instance, the script won't work.

After the scan completes, you will be given the option to auto-scan the results for common back door indicators. This scans the results and outputs any potential hits that it finds.

Usage should be pretty straightforward, let me know if there are any bugs or confusing things, in person or at mpetrole@phishlabs.com.

Dependencies: python 3.5

Special thanks to Mauro Soria, who wrote the underlying fuzzing script, DirSearch. 

Happy hunting!

////////////////////////////////////////////////////////////////////////
Change Log

.01 - initial release

.02 - Cleaned up some code, made it handle results in a more organized fashion. They now go to ./Reports/<directory>/ so that you can find the reports for a specific site

.03 - Added options for searching recursively. Beta shell processor that might show you potential shells after the search. Commented some so that I can remember what's going on. Fixed reports so that they don't make http// directories anymore =)

.04 - Fixed the auto shell parser script. It works now ^.^ it currently stops after the first hit, I'm not sure how to fix it yet lol. Also added a function to add shells to the list from within the script. Cleaned up what I could.

1.0 - Cleaned up more code. Added some parameters to the shell parser to catch more shells. It doesn't crash after the first hit anymore, at least not all the time. Should now properly log found shells in a file in the Results folder. Added a way to remove shells from the list from within the script. In general it is more polished that previous releases, I removed as much of the ugly stuff as I could. I feel that this is now complete enough to warrant a full version number. 

1.1 - Removed tor as an option, since it didn't work anyway. This will be my last version in bash, I'm moving over to ruby because it's better in every conceivable way. Oh, I made the discalimer only run on first load using magic.
