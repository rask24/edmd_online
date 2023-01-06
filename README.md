# Toy Data Test
toy data test for evaluation of EDMD online

## detail
1. EDMD part
2. EDMD online part

### EDMD part
+ standard EDMD
+ preparation for EDMD online part

### EDMD online part
+ update time evoluetion mapping on feature space
+ the initial mapping on feature space is determined in standard EDMD

### data definition
![data_definition](./images/edmd_online.jpeg)

## File Structure
```
.
├── archive
│  └── _main.m
├── DICTOL                               // csc library
├── images
│  └── edmd_online.png
├── main.m
├── plot
│  ├── error_transition.m
│  └── rsme.m
├── README.md
└── utils
   ├── dmd.m
   ├── fill_estimation.m
   ├── mat_to_mat_tilde.m
   ├── mat_to_vec_check.m
   ├── next_mat_K.m
   ├── nonlinear_mapping.m
   ├── nonlinear_mapping_inv.m
   ├── projection_onto_range_mat.m
   ├── time_evolution.m
   └── time_evolution_2d.m
```
+ main.m: main file for toy data test
+ util: utility function defined on this directory
    + dmd.m: dynamic mode decomposition
    + time_evolutions2d.m: define time evolution function on state space
    + mat_to_mat_tilde.m: convert matrix to matrix tilde (big matrix)
    + mat_to_vec_check.m: convert matrix to vector
+ images: images directory
+ archive: archive directory using nonlinear mapping(state space <--> feature space)
    + utility functions for _main.m
        + nonlinear_mapping.m: define nonlinear mappnig from state space to feature space
        + nonlinear_mapping_inv.m: define nonlinear mapping from feature space to state space
        + time_evolution.m: define time evolution function on state space
+ plot: functions defined for plot
    + error_transition.m: return rsme corresponding to iteration
    + rsme.m: define rsme(root square mean eror) between 2 matrices
+ DCTORL: csc library

## csc
+ convolutional sparse coded(dictionary learning)
+ D(Dictionary): mapping from feature space to state space

## DICTOL
* [githb link](https://github.com/tiepvupsu/DICTOL)