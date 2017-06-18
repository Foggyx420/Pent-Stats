NOTES:
* The PER in results file is the value you would multiply the total GRC rain supply for to get there amount
* Ex: 5000GRC * 0.0025555555555 = there grc of the rain
* 0.0025555555555 is 0.25555555555% of the pie. 
* It is left this way for easy calculations of the rain.

File:

* percents.results
Percentage for each CPID. Also contains GRC address.

* percents.log
Log actively showing the percentage calculation.

* sort.log
Sorts through CPIDs. Finds invalid cpids and dumps them. Also finds valid cpids without a beacon and dumps them.

* *invalid.dump	
CPIDs with no beacons

* *valid.json
JSON file with valid beacon CPIDs made before percentage calcs

* debug.log
debug of when crunching stats from last day to first calculating differences.
If they are not in the last day but in the middle or first days its stored there.
then i add notes on my investigation as to why for each.
