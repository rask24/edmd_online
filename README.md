# Toy Data Test
toy data test for evaluation of EDMD online

## detail
1. DMD only
2. EDMD
3. EDMD online

## File Structure
```
 .
├──  dmd.m
├──  main.m
├──  nonlinear_mapping.m
├──  nonlinear_mapping_inv.m
├──  README.md
└──  time_evolution.m
```
+ main.m: main file for test
    + define constant values
    + define original data and sampled data on state space
    + DMD only (not included)
    + EDMD
    + EDMD online (not included)
+ dmd.m: define dynamic mode decomposition
+ time_evolution.m: define time evolution function on state space
+ nonlinear_mapping.m: define nonlinear mappnig from state space to feature space
+ nonlinear_mapping_inv.m: define nonlinear mapping from feature space to state space