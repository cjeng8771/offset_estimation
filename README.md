# offset_estimation

## Hands-on Session: Distributed Clock Time Offset Estimation on POWDER
[Platform for Open Wireless Data-drive Experimental Research (POWDER)](https://powderwireless.net/)

## Measurement Collection via SHOUT
The SHOUT measurement framework is used to automate TX and RX functions across multiple nodes in the POWDER network. The data collected will be analyzed in the offset estimation tool outlined below.

### Create IQ File for Message to Transmit
1. Open (or make a copy and open) of the IQ generation script  [IQ_generation.ipynb](https://github.com/cjeng8771/offset_estimation/blob/main/IQ_generation.ipynb).
2. In the first function in the file, `Information_Transmit`, change the string `Info_to_TX` to hold the desired message to transmit. For the purpose of this experiment, ensure the message is 94 characters, including spaces, just like the original message.
3. In the 11th cell, the `write_complex_binary` function is defined. If desired, customize the specified name string for the new IQ file in the function call immediately below the function definition. If it is changed, change it in the last cell, as well.
4. Click the ►► symbol to restart the kernel and run all cells. Confirm that a new .iq file, with the specified name, appears in the folder with the Jupyter Notebook.

### Reserve Resources & Instantiate an Experiment
1. Log into [POWDER](https://powderwireless.net/).
2. Start an experiment by opening the [pre-saved parameters](https://www.powderwireless.net/p/PowderSandbox/shout-long-measurement&rerun_paramset=78a15bc0-ad06-11ed-b318-e4434b2381fc).
    * The profile should be shout-long-measurement. If you do not have access to the profile, one can be created via:
    **`Experiments` &rarr; `Create Experiment Profile` &rarr; `Git Repo` &rarr; add [repo link](https://gitlab.flux.utah.edu/frost/proj-radio-meas) &rarr; select the profile**
    * The parameters should include a d740 compute node, a d740 orchestrator node, dataset None, and the following CBAND X310 Radios: Behavioral, Browning, Friendship Manor, Hospital, Honors, SMT, and USTAR. It should include the frequency range: MIN 3450.0 to MAX 3460.0. The range can adjust depending on availability as long as it remains inside the allowed range. Check that `Start X11 VNC on all compute nodes` is checked.
    * Give the project a name and select the `NRDZ` project (or appropriate project).
    * If a warning appears that the resources are not available at this time, create a resource reservation to complete the experiment later based on resource availability. Then schedule the experiment to match the resource reservation.

### Run the Experiment to Collect Data
Once the experiment has started, 

### Offset Estimation
The local [Jupyter Notebook](https://github.com/cjeng8771/offset_estimation/blob/main/offset_estimation_full.ipynb) or the [Google Colab]() will be used for Distributed Clock Time Offset Estimation. Using the Jupyter Notebook will require forking the [repository](https://github.com/cjeng8771/offset_estimation/tree/main) or downloading all files locally. Using the Google Colab will require making a copy since the linked notebook is read only. Both notebooks walk through the steps required for analysis, but ensure that the subfolder with collected data files is inside the same folder as the [Jupyter Notebook](https://github.com/cjeng8771/offset_estimation/blob/main/offset_estimation_full.ipynb) or is uploaded if using the [Google Colab](). The subfolder should, by default, have a name in this format: `Shout_meas_MM-DD-YYYY_HH-MM-SS` where MM-DD-YYYY is the date of collection and HH-MM-SS is the time of collection.

The offset estimation notebooks uses the SHOUT data to plot the Power spectral density (PSD) for each link in the data set, calculate the index offset from the beginning of the received packet to the index of highest correlation with the preamble (true beginning of transmitted packet) for each link, calculate each link's signal to noise ratio (SNR), and use the offset values to estimate the distributed clock time offset at each SHOUT receiver used in the experiment. Because SHOUT collects TX/RX data from each link four times, there are four repetitions/trials (`repNum` in the notebooks) for each link to provide more context for the estimation and inference. The notebooks also analyze the least square error and root mean squared error (RMSE) for each link's estimation in comparison to the true calculated offsets.
