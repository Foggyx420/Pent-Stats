#!/bin/bash

ba="["
bb="]"
bc="[]"
dq='"'
p="#"
e="="
c=":"
z=","
y="+"
x="/"
w="%"

IR=$1
file="percents.results"

# Percents

# example of pulling data jq -r '.[]."272654".cpid' yoyo01done.json
# example of using it in command execute as quotes matter. getvar="${bc}.${dq}cpidnumber${dq}.cpid"
# Lets put all the cpids into a string for a read loop. Axe the grp output and butcher it up. Black Magic?

CPIDINPUTS=$(jq -r '.[]' ${1} | grep "\"\: {" | cut -d '"' -f2- | rev | cut -d '"' -f2- | rev)

# Lets process and make 2 basic stats file. One for valid beacons and One for no valid beacon.
# You must have a valid beacon to be awarded the rain!
# We use gridcoinresearchd and we will sleep lots through this as to not over tax the wallet rpc.

# Final output will be percents.results. We will use the tmp file and jq to modify the PER only value in each cpid.
# input temp
rm -f a.tmp
# output temp
rm -f b.tmp
# $1 will be copied to a.tmp so even if i make a coding mistake while making this it wont be problem some :)
# a.tmp values change will be > to b.tmp and then b.tmp moved back to a.tmp and repeat for each cpid.

# Lets gather the total difference in credits! This vital to figuring out each persons percentage. Do the dry run baby!

echo "All percent data in json file will be stored 0.25.. which means 25%" > percents.log
totaldiffcount="0"
while read inputread; do
    readdiff=".${bc}.${dq}${inputread}${dq}.DC"
    getdiff=$(jq -r ${readdiff} ${1})
    totaldiffcount=$(echo ${totaldiffcount}${y}${getdiff} | bc -l)
    # Output for eyes
    echo "Total Diff from ${inputread} is ${getdiff} bringing totaldiffcount to ${totaldiffcount}"
    echo "Total Diff from ${inputread} is ${getdiff} bringing totaldiffcount to ${totaldiffcount}" >> percents.log
done <<< $CPIDINPUTS

# Now we have that crucial value lets begin updating the PER value in the json to the correct PER.

# Copy $1 input to a.tmp. Safety first!
cp -f $1 a.tmp
totalpercentcount="0"
while read dataread; do
    datareaddiff=".${bc}.${dq}${dataread}${dq}.DC"
    datagetdiff=$(jq -r ${datareaddiff} ${1})
    datapercentraw=$(echo ${datagetdiff}${x}${totaldiffcount} | bc -l)
    datapercenthuman=$(echo ${datapercentraw}*100 | bc -l)
    totalpercentcount=$(echo ${totalpercentcount}${y}${datapercentraw} | bc -l)
    echo "CPID: ${dataread} | DIFF: ${datagetdiff} | Percentage of PIE: ${datapercentraw}(${datapercenthuman}${w})"
    echo "CPID: ${dataread} | DIFF: ${datagetdiff} | Percentage of PIE: ${datapercentraw}(${datapercenthuman}${w})" >> percents.log
    # Update the value in json file.
    jq -r ".${bc}.${dq}${dataread}${dq}.PER${e}${dq}${datapercentraw}${dq}" a.tmp > b.tmp
    cp -f b.tmp a.tmp
done <<< $CPIDINPUTS
cp -f a.tmp $file
echo "Total percenatge calculated is ${totalpercentcount}" >> percents.log
echo "Complete"
