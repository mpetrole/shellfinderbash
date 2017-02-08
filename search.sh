#!/bin/bash
echo "   _____ __         ____         ";
echo "  / ___// /_  ___  / / /         ";
echo "  \__ \/ __ \/ _ \/ / /          ";
echo " ___/ / / / /  __/ / /           ";
echo "/__________/\___/_/_/ __         ";
echo "   / ____(_)___  ____/ /__  _____";
echo "  / /_  / / __ \/ __  / _ \/ ___/";
echo " / __/ / / / / / /_/ /  __/ /    ";
echo "/_/   /_/_/ /_/\__,_/\___/_/     ";
echo "                                 ";
echo ""
echo "Version 1.0"
echo ""
echo ""
echo ""
if ! [ -e ./Search/.accept ]; then
echo "Notice: Taking actions on a server which you have not been given explicit permission to do so may be a crime. Please be careful. The author of this script provides it for educational purposes, and can not be held liable for it's use in illegal activity."
echo ""
echo "Press enter to accept. If you do not agree, please exit this script immediately."
read enter
touch ./Search/.accept
fi
python3.5 --version > /dev/null
if [ $? -ne 0 ]; then
    echo "Python3.5 is not installed. Please install it before continuing!"
    read enter
    exit
fi
redo=y
while [ "$redo" == "y" ]; do
echo "Type 'search' and press enter to search for a shell."
echo "Type 'add' and press enter to add a shell to the shell list"
echo "Type 'remove' and press enter to remove a shell from the shell list"
echo "Type 'quit' and press enter to exit"
read option
#Case sets up the options for the script
case "$option" in
search) #searches for shells using dirsearch
echo "Enter Directory: "
read  dir
seddir=$(echo  "$dir" | sed 's~http[s]*://~~g') #directories hate forward slashes
echo "Enter number of threads (default 150)" 
read threads
echo "Enter number of retries(default 3)"
read retries
echo "Search Recursively? (Will take much longer/take more resources) [y/N]"
read recursive
mkdir -p ./Reports/"$seddir" #make a directory with the name of the target, then dump the results to that directory
report="./Reports/$seddir/$(date +"%Y_%m_%d_%I_%M_%p").txt" #sets the name of the report to the current date and time. I do this here so that the time is consistent throughout the script.
detailedReport="./Reports/$seddir/details_$(date +"%Y_%m_%d_%I_%M_%p").txt"
if [ "$recursive" == 'Y' ] || [ "$recursive" == 'y' ]
  then python3.5 ./Search/dirsearch-master/dirsearch.py -u "$dir" -e php -r -t ${threads:-150} -x 300,400,403,406,500,501,502,503,504,508 --user-agent="Mozilla/4.0" -w ./Search/shellsdir.txt --simple-report="$report" --plain-text-report="$detailedReport" --max-retries=${retries:-3}
  else python3.5 ./Search/dirsearch-master/dirsearch.py -u "$dir" -e php -t ${threads:-150} -x 300,400,403,406,500,501,502,503,504,508 --user-agent="Mozilla/4.0" -w ./Search/shellsdir.txt --simple-report="$report" --plain-text-report="$detailedReport" --max-retries=${retries:-3}
fi
#the following is a method to search for potential shells among the results
echo "Attempt to automatically parse shells? [y/N]"
echo ""
read auto
if [ "$auto" == 'Y' ] || [ "$auto" == 'y' ]
then
    shell=n
    while IFS= read -r var
    do
        echo -ne "Checking $var \r"
            if curl --silent "$var" | iconv -f windows-1251 | grep -qilE 'passthrough|eval|base64_decode|preg_replace|shell_exec|chmod|cwd|upload|action=\"\"|input type=password|name=pass|name=pw|name=xx'; then #this just cURLs the results, and then makes sure they are in a standard character set, and then greps for common shell content. Hopefully, this will find both open and password protected shells.
                echo ""
                echo "Potential Shell: $var" | tee -a "./Reports/$seddir/PotentialShells.txt" #this lets the script both echo the result to the terminal and save it to the given file
                shell=y
            fi
        echo -ne "\r"
    done < <(grep ".php$" "$report")
    if [ "$shell" == 'n' ]; then
        echo ""
        echo -ne "No shells found \r"
        echo ""
    fi
fi
isTor=1
threads=150
retries=3
recursive=n
;;
add) #this is for adding shells to the list
shelltxt="./Search/shellsdir.txt"
echo "Shell name? (include .php please)"
read name
if ! grep -q "$name" "$shelltxt"; then
    sed -i "1s/^/$name\n/" "$shelltxt"
    if [ $? -eq 0 ]; then
        echo "Successfully added to list"
    else
        echo "Failed to add to list"
    fi
else
    echo "$name already exists in the list!"
fi
;;
remove) #this will remove shells from the list
echo "Shell name? (include .php please)"
read name
if grep -q "$name" "$shelltxt"; then
    grep -v "$name" "$shelltxt" > "$shelltxt".bak; mv "$shelltxt".bak "$shelltxt"
else
    echo "$name not found in list!"
fi
;;
quit) #for the sake of looking nice
redo=n
;;
*) #if all else fails
echo "Sorry, $option isn't a valid option!"
;;
esac
done
kill
