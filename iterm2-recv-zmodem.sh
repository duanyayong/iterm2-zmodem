#!/bin/bash

osascript -e 'tell application "iTerm2" to version' > /dev/null 2>&1 && NAME=iTerm2 || NAME=iTerm
if [[ $NAME = "iTerm" ]]; then
    FILE=$(osascript << EOT
tell application "iTerm"
    activate
    set documents_Path to path to home folder
    set theAliasPaths to (choose file with prompt "select files to send" default location documents_Path with invisibles and multiple selections allowed)
    set myMessage to ""
    set myList to {}
    repeat with theAliasFile in theAliasPaths
        set thePosixPash to POSIX path of theAliasFile
        set end of myList to thePosixPash
        set myMessage to myMessage & thePosixPash & linefeed
    end repeat
    end tell
EOT
)
else
    FILE=$(osascript << EOT
tell application "iTerm2"
    activate
    set documents_Path to path to home folder
    set theAliasPaths to (choose file with prompt "select files to send" default location documents_Path with invisibles and multiple selections allowed)
    set myMessage to ""
    set myList to {}
    repeat with theAliasFile in theAliasPaths
        set thePosixPash to POSIX path of theAliasFile
		set end of myList to thePosixPash
        set myMessage to myMessage & thePosixPash & linefeed
    end repeat
    end tell
EOT
)
fi
if [[ $FILE = "" ]]; then
    echo Cancelled.
    # Send ZModem cancel
    echo -e \\x18\\x18\\x18\\x18\\x18
    sleep 1
    echo
    echo \# Cancelled transfer
else
    for p in $FILE
    do
        /usr/local/bin/sz "$p" -e -b
        sleep 1
    done
    echo
    echo \# Received \-\> $FILE
fi
