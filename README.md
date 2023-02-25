# insulin_calc

A simple insulin dose calculator that I am writing whilst learning Haskell.

Asks a user for a list of items in a meal (with their names and weights) to calculate the amount of carbs in the meal. 
It will then calculate the insulin dose required depending on the chosen insulin to carbs ratio profile.

Currently, this only has a very small embedded food/drink database. I aim to import a larger database from a file in the future.
In addition, the profiles are also embedded (namely Breakfast, Dinner and Tea) with preset values. I will allow these to be set by the user in the future.

**Currently, this is in development, I do not recommend using this to calculate real insulin doses yet.**

Simply compile using the provided shell script (make sure you have GHC installed on your system) and run like so.
```sh
$ sh compile.sh
$ ./insulin_calc
Insulin to carbs ratio: Breakfast
Enter items (<name> <weight> <multiplicity>). Type :d to finish:
> Orange 100 1
> Banana 150 1
> Apple 42 2
> :d
Total carbs: 49.75g
Calculated insulin dose: 7.11 units
```
