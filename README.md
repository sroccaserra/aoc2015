## Learnings

- `concatMap f . g` is `g >=> f` (see [day 10](src/10.hs))
- If I make a map of values to list of values (or a dict or hashtable of values
  to arrays of values, same idea), I am probably working with a tree or graph
  like structure. There are probably classic algorithms I can use to solve the
  problem, and classical structures I can use to represent it (I can switch to
  adjacenty list or matrix if it works better for example).
