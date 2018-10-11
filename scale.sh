#!/bin/bash
# Program Name: scale.sh
# Created by: Norman Chen
# Create Date: 12/19/2017
# Description: Will play music from a given text file.  The text file is formated specifying a mneumonic combination of a note, octave, note length.
# All files start specifying bpm per quarter note. 
#
#       Example
#       120
#       c4q d4q e4q  
#
#	example: c4q d3h e3w
#         Note is q and type is quarter note
#         Note is h and type is a half note
#         Note is w and type is a whole note
#
#
# Versions
# 1.1 Update 
#     1. Detect for the prescence if beep is installed. 
#        If installed activated pcspeker driver
#     2. Now able to play multiple octaves and change speed based on bpm
#     3. Realigned octaves to start at C0.
# 1.0 Initial version
#     Limitations: 
#     Plays only in one octave in Middle C.
#         

if [ -e /usr/bin/beep ]
then
   modprobe pcspkr
else
   echo "Please install beep.  Use apt-get beep" 
   exit
fi 
   

# Initialize note fequencies
Notes=(`cat "notefreq.txt"`)

# Set Octave to Middle C
octave=`echo - | awk '{print 2 ^ 4}'`
c=${Notes[0]}
db=${Notes[1]}
cs=$db
d=${Notes[2]}
eb=${Notes[3]}
ds=$eb
e=${Notes[4]}
f=${Notes[5]}
gb=${Notes[6]}
fs=$gb
g=${Notes[7]}
ab=${Notes[8]}
gs=$ab
a=${Notes[9]}
bb=${Notes[10]}
as=$bb
b=${Notes[11]}

# Load Song
echo Loading Song ... 
Song=(`cat $1`)
qtr=${Song[0]}
echo Loading complete.

# Play Song
echo Playing Song ...
for n in ${Song[@]:1}
do

# Set note to freq to play

    if [ ${#n} -eq 3 ]
    then
       note=${n:0:1}
       oct=${n:1:1}
       len=${n:2:1}
    elif [ ${#n} -eq 4 ]
    then
       note=${n:0:2}
       oct=${n:2:1}
       len=${n:3:1}
    fi

    case $note in 
       [Cc]) freq=$c ;;
       [cC][sS]|[dD][bB]) freq=$cs ;;
       [Dd]) freq=$d ;;
       [dD][sS]|[eE][bB]) freq=$ds ;;
       [Ee]) freq=$e ;;
       [Ff]) freq=$f ;;
       [fF][sS]|[gG][bB]) freq=$fs ;;
       [Gg]) freq=$g ;;
       [gG][sS]|[aA][bB]) freq=$gs ;;
       [Aa]) freq=$a ;;
       [aA][sS]|[bB][bB]) freq=$as ;;
       [Bb]) freq=$b ;;
     esac

# Set octave to play

       freq=`echo "$freq * 2 ^ $oct" | bc -l`

# Set note length     
     bpm=`echo "60.0 / $qtr * 1000.0" | bc -l`
     case $len in
         [Ee]) length=`echo "$bpm / 2 " | bc -l` ;;
         [Qq]) length=`echo "$bpm * 1" | bc -l` ;;
         [Hh]) length=`echo "$bpm * 2" | bc -l` ;;
         [Ww]) length=`echo "$bpm * 4" | bc -l` ;;
     esac

# Show note being played.
    
#     echo  Octave: $oct Length: $len  Note: $note
#    echo Frequency: $freq  Octave: $oct Length: $len  Note: $note
#    echo bpm: $bpm   Qtr: $qtr

# Play note
     /usr/bin/beep -f $freq -l $length
done

echo 'Done'
