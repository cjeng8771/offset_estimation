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
    (a) The profile should be shout-long-measurement. If you do not have access to the profile, one can be created via:
    **`Experiments` &rarr; `Create Experiment Profile` &rarr; `Git Repo` &rarr; add [repo link](https://gitlab.flux.utah.edu/frost/proj-radio-meas) &rarr; select the profile**
    (b) The parameters should include a d740 compute node, a d740 orchestrator node, dataset None, and the following CBAND X310 Radios: Behavioral, Browning, Friendship Manor, Hospital, Honors, SMT, and USTAR. It should include the frequency range: MIN 3450.0 to MAX 3460.0. The range can adjust depending on availability as long as it remains inside the allowed range. Check that `Start X11 VNC on all compute nodes` is checked.
    (c) Give the project a name and select the `NRDZ` project (or appropriate project).
    (d) If a warning appears that the resources are not available at this time, create a resource reservation to complete the experiment later based on resource availability. Then schedule the experiment to match the resource reservation.

### Run the Experiment to Collect Data
Once the experiment has started, 
