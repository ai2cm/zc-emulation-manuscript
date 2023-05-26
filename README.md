# Zhao-Carr Microphysics Emulation JAMES Manuscript Code and Data

This repository contains all the code to reproduce the model training, online simulations, and figures for the Zhao-Carr microphysics emulation manuscript. The data for reproducing results can be found on Zenodo (https://doi.org/10.5281/zenodo.7963397), including reduced outputs from all experiments used in the notebooks, a subsampled set of training/validation data, and FV3GFS intialization data.

After downloading the data, run the following to extract the data into the manuscript directory:

    tar -xzf zc-emulation-manuscript-data.tar.gz -C /path/to/zc-emulation-manuscript/.

This will place all the folders in locations where `Makefile` targets and configuration files reference.

### Docker images

We also provide docker images to re-run the model training or prognostic simulations:

* fv3fit: gcr.io/vcm-ml/fv3fit:zc-manuscript-submission
* prognostic_run: us.gcr.io/vcm-ml/prognostic_run:zc-manuscript-submission

If for some reason, these images are no longer available via `docker pull <image url>`, we have uploaded the images to the same zenodo repository.  After downloading `zc-manuscript-docker-images.tar.gz`, load the images using `docker load --input zc-manuscript-docker-images.tar.gz`.

## Figure notebooks

All of the figures presented in the main manuscript are reproducible using jupyter notebooks under `notebooks` and reduced data and metrics from our simulations stored under `notebooks/fig_data`.  This does require a local installation of Python 3 with at least `matplotlib`, `xarray`, and `numpy` packages installed.  (**Note** `fig_data` is populated upon untarring the data tarball uploaded to (Zenodo)[https://doi.org/10.5281/zenodo.7963397].)

### Figure data descriptions

| Filename  | Description | File Contents |
| --- | --- | --- |
| `physics_transect.nc` | Lat--pressure transects of tendencies used in Figure 2. | tendency_of_cloud_water_due_to_gscond_physics, tendency_of_cloud_water_due_to_zhao_carr_physics, tendency_of_specific_humidity_due_to_gscond_physics, tendency_of_specific_humidity_due_to_zhao_carr_physics, time, lon | 
| `online_zonal_avg.nc` | Zonally averaged model state after timestep from the online 30-day runs. Dimensions of init, time, lat, and pressure, where init covers the twelve monthly initializations. Used in Figure 4.| air_temperature, specific_humidity, cloud_water_mixing_ratio, relative_humidity | 
| `offline_zonal_avg.nc` | Zonally averaged model state after timestep from the offline 30-day runs. Dimensions of init, time, lat, and pressure, where init covers the twelve monthly initializations. Used in Figure 4.| air_temperature, specific_humidity, cloud_water_mixing_ratio, relative_humidity | 
| `offline_precipitation.nc` | Surface precipitation rate data from the offline twelve 30-day simulations, including the zhao-carr specific precipitation and the total fv3gfs  precipitation.  Dimensions of init, time, lat.  Used for Figure 5a.  Additionally,  histogram counts for ZC precipitation rate for each init, used in Figure 5b; and the baseline/emulator output averages used to calculate biases. | emulator_hist_counts, fortran_hist_counts, zonal_surface_precipitation_due_to_zhao_carr_emulator, zonal_surface_precipitation_due_to_zhao_carr_physics, zonal_total_fv3gfs_precipitation, mse, emulator_mean, fortran_mean | 
| `online_precipitation.nc` | Surface precipitation rate data from the online twelve 30-day simulations, including the zhao-carr specific precipitation and the total fv3gfs  precipitation.  Dimensions of init, time, lat.  Used for Figure 5a.  Additionally,  histogram counts for ZC precipitation rate for each init, used in Figure 5b; and the baseline/emulator output averages used to calculate biases. | emulator_hist_counts, fortran_hist_counts, zonal_surface_precipitation_due_to_zhao_carr_emulator, zonal_surface_precipitation_due_to_zhao_carr_physics, zonal_total_fv3gfs_precipitation, mse, emulator_mean, fortran_mean | 
| `online_1yr_run_zonal_2d.nc` | Zonally averaged diagnostic fields after timestep from the online continuous 1-year run.  Dimensions of time, lat. Used to create hoevmoller in Figure 6. | total_precipitation, cloud_water_mixing_ratio, PWAT, ULWRFtoa, USWRFtoa, h500 | 
| `offline_1yr_run_zonal_2d.nc` | Zonally averaged diagnostic fields after timestep from the offline continuous 1-year run.  Dimensions of time, lat. Used to create hoevmoller in Figure 6. | total_precipitation, cloud_water_mixing_ratio, PWAT, ULWRFtoa, USWRFtoa, h500 | 
| `online_1yr_run_zonal_3d_avg.nc` | Zonally averaged model state fields after timestep from the online continuous 1-year run. Dimensions of lat, pressure.  Used to discuss the polar stratospheric bias in Figure 7.   | air_temperature, specific_humidity, cloud_water_mixing_ratio, total_precipitation, relative_humidity | 
| `offline_1yr_run_zonal_3d_avg.nc` | Zonally averaged model state fields after timestep from the offline continuous 1-year run. Dimensions of lat, pressure.| air_temperature, specific_humidity, cloud_water_mixing_ratio, total_precipitation, relative_humidity| 
| `cloud_day15_classifier_comparison.nc` | Cloud condensate amounts on day 15 of the July simulation comparing the use of a classifier in online runs against a baseline case.  Used in Figure 8. | with classifier, without classifier, baseline | 
| `skill_dropout_data.nc` | Surface precipitation skill metrics over time (skill_gscond_and_precpd_mask, skill_gscond_only_mask) for the two upper-level mask configurations of the 1-year simulation.  Used in Figure B1.  Vertical profiles of condensate tendency (emu_gscond_max_err_loc, emu_precpd_max_err_loc, fort_gscond_max_err_loc, fort_precpd_max_err_loc) from the location of maximum emulator vs. diagnostic Fortran error at the time of skill dropout used in Figure B2. The time by height data of the maximum skill dropout (precpd_dc_skill) used in the supplementary Figure S6. | skill_gscond_and_precpd_mask, skill_gscond_only_mask, precpd_dc_skill, tile, y, x, emu_gscond_max_err_loc, emu_precpd_max_err_loc, fort_gscond_max_err_loc, fort_precpd_max_err_loc | 

### Table data descriptions

| Filename | Description|
| --- | --- |
| topline_skill.csv | Skill values averaged over the twelve 30-day simulations. Used in Table 1. |
| metrics_30day_runs_tendency_bias_rmse.csv | Tendency RMSE and bias values averaged over the twelve 30-day simulations.  Used in Table 1.|
| metrics_30day_runs_state_bias.csv | Model state biases averaged over the twelve 30-day simulations.  Used in Table 2.|
| online_skill_1yr_run.csv | Online skill values from the continuous 1-year simulation.  Used in Table 3.|
| online_bias_1yr_run.csv | Model state biases averaged over the 1-year simulation used in Table 4.|
| prior_arch_skill_sensitivity.csv | Skill values from ablation experiments exploring the sensitivity to architecture.  Used in Table 5.|
| default_wandb_metrics_30day_runs.csv | All metrics for individual 30-day run experiments.  Includes individual skill for gscond, precpd, and total ZC tendencies, 10-day drifts against the baseline, and Antarctic-average column-integrated condensate on day 5 of simulation. |


## Training data

We provide a random subset (~10%) of the full training dataset described in the manuscript split into `train` and `test` groups.  This step requires the `prognostic_run` Docker image is available locally.  To recreate the full training dataset run the following:

1. `make create_training_allmonths`
1. `make gather_training`

The first target will run 12 30-day simulations initialized from GFS data on the 1st of each month in 2016.  The outputs from these simulations in the `outputs` folder for each month.  (**Note**: the current simulations are run in serial, this step could be sped up greatly by farming out the simulations to multiple jobs/machines.)  Then, `gather_training` will take the stored netCDFs and gather them into test/train folders under `outputs/train` and `outputs/test`.

## Emulation Models

We provide the models used in the manuscript (gscond regressor + classifier, and precpd regressor) under `models`, loadable as Tensorflow keras models.  To train new models on the provided subset data use `make train_models`, which will train each component individually.  This requires the `fv3fit` docker image to be available locally.  If you recreated the full training dataset, make sure to edit the `train_url`/`test_url` values in the config YAML files (under `code/training`) to point to the new data.

## Prognostic simulation

Finally, we provide an entry point to re-run online emulation runs of FV3GFS using the emulation models under `models`.  Using `make run_30_day_july` will initialize an online simulation from July 1st, 2016.  This requires the `prognostic_run` docker image to be available locally.  If you recreated the training dataset, you can initialize models from the end of those simulations (as in the manuscript) by pointing the initialization configuration paramter (`initial_conditions`) in `online-emulation-30day.yaml` to the `RESTART` directories stored in the outputs of each training data run.

We also provide a target for the 1-year simulation (`make run_1yr`) to initialize a continuous 1-year simulation from July 1st, 2016.  **Note: This will generate very large amounts of data**.

## Code

All of the training and runtime code, as well as the configuration files can be found under `code/`.  This includes the `fv3net` submodule pointed to the release commit used to generate all of the results.  The training image (`fv3fit`) and prognostic run image (`prognostic_run`) were created using build files under `fv3net/docker`.  The relevant training involves code under `fv3net/external/fv3fit`, specifically the `train_microphyscs.py` and code under the `emulation/` directory.  The code responsible for runtime emulation tasks is found under `fv3net/external/emulation`.
