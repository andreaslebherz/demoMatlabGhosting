# demoMatlabGhosting
Matlab demonstration of ghost detections in sumilated scenarios

This repository is based on https://de.mathworks.com/help/driving/ug/radar-ghost-multipath.html
It therefore requires the 'Automated Driving Toolbox' and the 'Radar Toolbox'. 

The sensor configuration consists of 5R1C and is implemented scenario independent. 

Scenario files should be placed in the /scenario folder. 

Output .csv (detections) and .gif (simulation) are generated in the /output folder.

In mainDemoGhosting.m:

    1. Set EXPORT_CSV flag
    2. Set scenarioHandle to <scenario>.m
    3. Set filename to <scenario>.m (This has to match scenarioHandle)
    4. Run
    