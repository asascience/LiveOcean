# LiveOcean on the IOOS Cloud Sandbox

### Prerequisites:
- Access to a deployed Sandbox
- A myroms.org user account to download the ROMS source code. Click here: [myroms.org](https://www.myroms.org/index.php?page=RomsCode)

### How to install the LiveOcean model
This will install and build the model and download the data needed to run the test case.

- Log in to your Sandbox
- ``` cd /save/<your user folder>```
- ``` git clone https://github.com/asascience/LiveOcean.git```
- ``` cd LiveOcean```
- ``` ./setup_LiveOcean.sh```

### How to run the LiveOcean model test case using the Cloud Sandox Workflow
* ``` cd /save/<your user folder>```
* If you haven't already, clone the Cloud-Sandbox repo: ```git clone https://github.com/ioos/Cloud-Sandbox.git```
* ```cd Cloud-Sandbox/cloudflow```
* Make sure the cluster configuration file is correctly setup for your deployment: e.g. ```vi cluster/configs/ioos.config```
* Make sure the main driver is using the right machine/cluster config file: 
```
vi ./workflows/workflow_main.py
```
Look for:
```
fcstconf = f'{curdir}/../cluster/configs/ioos.config'
```
* Make sure the job configuration file is correctly setup: e.g. ```vi job/jobs/liveocean.fcst```



```
"CDATE"     : "20170601", this is the date we have input data for 
"NTIMES"    : "2880", will run a 24 hour forecast
"COMROT"    : "/com/<your user folder>"  this is your model output folder 
```

### Run the model

```
cd /save/<your user folder>/Clkoud-Sandbox/cloudflow
./workflows/workflow_main.py job/jobs/liveocean.fcst >& liveocean.log &
```
To watch the output;
```
tail -f liveocean.log
```
And:
```
cd /com/<your user folder>/LO_roms/cas6_traps2_x2b/f2017.06.01
tail -f lofcst.log
```

