# EDMD ONLINE
toy data test for evaluation of EDMD online

## Usage
first, choose toy data type in `SymConfig.m`.
* linear_affine_time_variant
* linear_time_varinat_theta
* nonlinear_sin_rot

is available for now.

next, in matlab console, type command in below order.

1. init
2. create
3. online
4. only
5. plot

### init
setpath and set warning off

### crate
* crate toy data
* output created toy data to `./data/toy_data/`

### online
* Applying EDMD online algorithm for created toy data
* load toy data from `./data/toy_data/`
* save variable to `./data/result/`

### only
* Applying EDMD algorithm(__only__) for created toy data
* load toy data from `./data/toy_data/`
* save variable to `./data/result/`

### plot
1. plot RMSE transition between toy data and estimated data with EDMD online
2. plot trajectory below
   1. toy data
   2. estimated data with EDMD(__only__)
   3. estimated data with EDMD online
* save jpg image file to `./images/`


## data definition
![data_definition](./images/edmd_online.jpeg)

## File Structure
```
.
├── DICTOL                                                  // CSC Library
├── data
│  ├── result
│  │  ├── linear_affine_time_variant.mat
│  │  ├── linear_time_variant_theta.mat
│  │  └── nonlinear_sin_rot.mat
│  └── toy_data
│     ├── linear_affine_time_variant.mat
│     ├── linear_time_variant_theta.mat
│     └── nonlinear_sin_rot.mat
├── images
│  ├── algorithm.jpeg
│  ├── edmd_online.jpeg
│  ├── linear_affine_time_variant_rmse_transition.jpg
│  ├── linear_affine_time_variant_trajectory.jpg
│  ├── linear_time_variant_theta.jpg
│  ├── linear_time_variant_theta_rsme_transition.jpg
│  ├── nonlinear_sin_rot_rmse_transition.jpg
│  └── nonlinear_sin_rot_trajectory.jpg
├── time_evolution
│  ├── linear_affine_time_variant.m
│  ├── linear_time_variant_theta.m
│  └── nonlinear_sin_rot.m
├── util_edmd_online
│  ├── dmd.m
│  ├── mat_to_mat_tilde.m
│  ├── mat_to_vec_check.m
│  ├── next_mat_K.m
│  └── projection_onto_range_mat.m
├── util_plot
│  ├── error_transition.m
│  └── rmse.m
├── create.m
├── init.m
├── online.m
├── only.m
├── plot.m
├── README.md
└── SymConfig.m
```

## detail
+ detail later...

## csc
+ convolutional sparse coded(dictionary learning)
+ D(Dictionary): mapping from feature space to state space

## DICTOL
* [githb link](https://github.com/tiepvupsu/DICTOL)
