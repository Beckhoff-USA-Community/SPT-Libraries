# V4 Available
With the relesase of PackML V3 for TwinCAT 3.1.4026, the SPT Libraries have moved to V4.0 to support the new PackML standard.  
[V4 Release notes](https://beckhoff-usa-community.github.io/SPT-Libraries/V4%20Release%20Notes/Requirements.html) are available in the documentation, and samples are avaiable in the [SPT V4 Samples](https://github.com/Beckhoff-USA-Community/SPT_V4_Samples) repository.  
Before installing the [V4 libraries](https://github.com/Beckhoff-USA-Community/SPT-Libraries/tree/V4.0) please see the documentation section about [Pinning libraries](https://beckhoff-usa-community.github.io/SPT-Libraries/V4%20Release%20Notes/PinningLibraries.html) in your V3 projects.

# About This Repository
These V3 libraries go hand-in-hand with the [VFFS Demo PLC](https://github.com/Beckhoff-USA-Community/PackML_PLC_Example).

This sample is created by [Beckhoff Automation LLC.](https://www.beckhoff.com/en-us/), and is provided as-is under the MIT license.  

# Documentation
Please visit our [documentation page](https://beckhoff-usa-community.github.io/SPT-Libraries/) for detailed information on the contents of this framework as well as thoughts on architecture of machine programs.



## How to get support
For SPT framework support, raise an [issue](https://github.com/Beckhoff-USA-Community/SPT-Libraries/issues/new/choose) here.

For general TwinCAT and Beckhoff Product support, please contact your local [Beckhoff Support](https://www.beckhoff.com/support/).

# Adding this repo as a TwinCAT PLC Library Repository
1. Clone this repository to your PC

2. Open the Library Repository<br>
![image](https://user-images.githubusercontent.com/18381949/232176085-f3e0c4d4-55e7-43ea-8b0a-e522097ed7e2.png)<br>
3. Click Edit Locations...<br>
![image](https://user-images.githubusercontent.com/18381949/232176435-aff683b1-04ab-4db1-bed3-7efa4debf4ac.png)<br>
4. Click Add...<br>
![image](https://user-images.githubusercontent.com/18381949/232176556-f8cc91ee-77a9-45d5-8af9-192611669f2d.png)<br>
5. Browse to the folder where you cloned this repository and give the PLC Library Repository a name (e.g. SPT Libraries).  **NOTE** The location MUST point to the \Library Repository folder under the repo root!<br>
![image](https://user-images.githubusercontent.com/18381949/232176459-5c628467-8b3a-430a-b546-1e111d481e27.png)<br>
6. Future updates to the SPT libraries will automatically propogate into TwinCAT XAE by pulling this repo.
