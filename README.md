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
Once the experiment has started and is ready, go to the `List View` to view all node hostnames.

1. Click the gear symbol on the far right of each node and select Power Cycle. This will reboot the nodes in case there were issues during set up. Wait until all nodes are ready again.
2. Use the following commands to start ssh and tmux sessions for the orchestrator. Username refers to your POWDER username. `orch_node_hostname` refers to the hostnames listed in `List View`.
    ```
    ssh -Y -p 22 -t <username>@<orch_node_hostname> 'cd /local/repository/bin && tmux new-session -A -s shout1 &&  exec $SHELL'
    ssh -Y -p 22 -t <username>@<orch_node_hostname> 'cd /local/repository/bin && tmux new-session -A -s shout2 &&  exec $SHELL'
    ```
3. Use the following command to start a ssh and tmux session for each of the radios. The `radio_hostname` is listed next to each node in the `List View`. If using the given parameters, there should be 9 sessions open now, including the orchestrator sessions.
    ```
    ssh -Y -p 22 -t <username>@<radio_hostname> 'cd /local/repository/bin && tmux new-session -A -s shout &&  exec $SHELL'
    ```
Note: `tmux` allows multiple remote sessions to remain active even when the SSH connection gets disconncted.
4. 

## Offset Estimation
The local [Jupyter Notebook](https://github.com/cjeng8771/offset_estimation/blob/main/offset_estimation_full.ipynb) or the [Google Colab]() will be used for Distributed Clock Time Offset Estimation. 

### Setting up the Estimation Notebook
Choose either the local Jupyter Notebook or a copy of the Google Colab to conduct the estimation analysis.
  * Using the Jupyter Notebook will require forking the [repository](https://github.com/cjeng8771/offset_estimation/tree/main) or downloading all files locally. Ensure that the subfolder with collected data files is inside the same folder as the Jupyter Notebook.
  * Using the Google Colab will require making a copy since the linked notebook is read only. Ensure that the subfolder with collected data files is uploaded to the Colab Notebook.
  * The data subfolder should, by default, have a name in this format: `Shout_meas_MM-DD-YYYY_HH-MM-SS` where MM-DD-YYYY is the date of collection and HH-MM-SS is the time of collection and contain the following files: `log`, `measurements.hdf5`, and `save_iq_w_tx_file.json`.

### Estimation Analysis
The offset estimation notebooks uses the SHOUT data to:
  * Plot the Power spectral density (PSD) for each link in the data set.
  * Calculate the index offset from the beginning of the received packet to the index of highest correlation with the preamble (true beginning of transmitted packet) for each link.
  * Calculate each link's signal to noise ratio (SNR).
  * Use the offset values to estimate the distributed clock time offset at each SHOUT receiver used in the experiment.
  * Analyze the least square error and root mean squared error (RMSE) for each link's estimation in comparison to the true calculated offsets.

### Additional Notes to Understand the Offset Estimation Results
1. Because SHOUT collects TX/RX data from each link four times, there are four repetitions/trials (referred to as `repNum` in the code) for each link to provide more context for the estimation and inference.
2. Running the Jupyter Notebook will create 8 files in its parent folder. Four files entitled `col_#.txt` and four files entitled `snr_#.txt`. These files hold the offset data and SNR data for each link, respectively, with the files numbered by `repNum`.
