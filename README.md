# offset_estimation

## Hands-on Session: Distributed Clock Time Offset Estimation on POWDER
[Platform for Open Wireless Data-drive Experimental Research (POWDER)](https://powderwireless.net/)

## Measurement Collection via SHOUT
The SHOUT measurement framework is used to automate TX and RX functions across multiple nodes in the POWDER network. The data collected will be analyzed in the offset estimation tool outlined below.

### Create IQ File for Message to Transmit
1. Open (or make a copy and open) of the IQ generation script  [IQ_generation.ipynb](https://github.com/cjeng8771/offset_estimation/blob/main/IQ_generation.ipynb).
2. In the first function in the file, `Information_Transmit`, change the string `Info_to_TX` to hold the desired message to transmit. For the purpose of this experiment, ensure the message is 94 characters, including spaces, just like the original message.
3. In the 11th cell, the `write_complex_binary` function is defined. If desired, customize the specified name string for the new IQ file in the function call immediately below the function definition. If it is changed, change it in the last cell, as well.
4. Click the double right arrow &#9658 &#9658 symbol.

### Reserve Resources & Instantiate an Experiment
1. Log into [POWDER](https://powderwireless.net/).
