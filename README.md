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

### Set up Sessions for all Nodes
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

### Setting up Nodes for Experiment
For this part, `node` refers to all sessions except the two orchestrator sessions.

1. Download [filetransfer.sh](https://github.com/cjeng8771/offset_estimation/blob/main/filetransfer.sh) and open as a text file. Update the list of HOSTS in the first line using the `SSH command` column in `List View`. Update the IQ file name in the `scp` line as well.
2. Use the [filetransfer.sh](https://github.com/cjeng8771/offset_estimation/blob/main/filetransfer.sh) script to scp the IQ file to all nodes by running the following command in the terminal/command prompt. The file will show up in the ~ directory on the nodes.
    ```
    ./filetransfer.sh
    ```
3. Use the following command to move the IQ file to the path where it is specified in the JSON file on every node's session. This eliminates what needs to be edited in the JSON file on each node. `iq_file_name` refers to the name of the IQ file being used.
    ```
    mv ~/<iq_file_name> /local/repository/shout/signal_library/<iq_file_name>
    ```
4. Set `useexternalclock = True` in `meascli.py` on each node by running the following command and changing the line shown [here](https://gitlab.flux.utah.edu/frost/shout/-/blob/master/meascli.py#L49). This will enable the use of external clock white rabbit in all nodes.
    ```
    vim /local/repository/shout/meascli.py
    ```
5. On each node, check that the CMD in line 16 is `save_iq_w_tx_file`.
    ```
    vim 3.run_cmd.sh
    ```
6. For each node and the orchestrator, make the following changes to the JSON file. The JSON file can be accessed using the following command.
    ```
    vim /local/repository/etc/cmdfiles/save_iq_w_tx_file.json
    ```
    * `txsamps` should contain the path to the IQ file: `/local/repository/shout/signal_library/<iq_file_name>`.
    * `txrate`, `rxrate`, `txgain`, `rxgain`, `txfreq`, `rxfreq`, and `rxrepeat` can be changed if desired but their default should work for the experiment. `txfreq` and `rxfreq` should be inside the reserved range for the experiment and might need to be changed if the frequency range is different.
    * `txclients` and `rxclients` should be correct if the nodes in the provided parameter set are used. If not, these lists should be updated to contain the full name of all the reserved nodes for the experiment. The two lists should match.
7. Confirm connection on the nodes by running `uhd_usrp_probe` on each node. If a node complains about a firmware mismatch, run `./setup_x310.sh` on that node and then run another Power Cycle on the POWDER `List View` before trying to run `uhd_usrp_probe` again.

### Running the Experiment for Data Collection
1. In one of the orchestrator sessions, run `./1.start_orch.sh`.
2. In each of the clients/nodes (non-orchestrators), run the following commands to resize the buffer and start the clients.
    ```
    sudo sysctl -w net.core.wmem_max=24862979
    ./2.start_client.sh
    ```
3. In the second orchestrator session, run `./3.run_cmd.sh` to initiate the data collection. There should be collected power information printing in the second orchestrator session during collection.

### Confirming and Transferring the Measurements
1. When the second orchestrator session returns to the command prompt, run `ls /local/data/` and check that a folder exists, entitled `Shout_meas_MM-DD-YYYY_HH-MM-SS` where MM-DD-YYYY is the date of collection and HH-MM-SS is the time of collection. The folder should have three files: `log`, `measurements.hdf5`, and `save_iq_w_tx_file.json`.
2. Run the following command, on the local computer terminal/command prompt to transfer the data folder to the local host. `Shout_meas_datestr_timestr` should be changed to the name of the data folder on the orchestrator and `local_dir` should be changed to the desired location on the local host.
    ```
    scp -r <username>@<orch_node_hostname>:/local/data/Shout_meas_datestr_timestr /<local_dir>
    ```
3. Check the local host location to ensure the new data folder transfer was successful.

## Offset Estimation
The local [Jupyter Notebook](https://github.com/cjeng8771/offset_estimation/blob/main/offset_estimation_full.ipynb) or the [Google Colab](https://colab.research.google.com/drive/1bkSyKZGTB1B9pD7VgXEPivuDBxjmpxRi?usp=sharing) will be used for Distributed Clock Time Offset Estimation. 

### Setting up the Estimation Notebook
Choose either the local Jupyter Notebook or a copy of the Google Colab to conduct the estimation analysis.
  * Using the Jupyter Notebook will require forking the [repository](https://github.com/cjeng8771/offset_estimation/tree/main) or downloading all files locally. Ensure that the subfolder with collected data files is inside the same folder as the Jupyter Notebook.
  * Using the Google Colab will require making a copy since the [linked notebook](https://colab.research.google.com/drive/1bkSyKZGTB1B9pD7VgXEPivuDBxjmpxRi?usp=sharing) is read only. Ensure that the subfolder with collected data files is uploaded to the Colab Notebook. Instructions for uploading files and setting up the Google Colab environment are included in the Colab Notebook.
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
