# Interactive Shadow Removal
This repository contains the code for the paper
"[Interactive Shadow Removal and Ground Truth for Difficult Shadow Scenes](http://arxiv.org/abs/1608.00762)", Journal of the Optical Society of America (JOSA) A 2016.

Copyright &copy; 2016 Han Gong (gong@fedoraproject.org)<br />
University of Bath and University of East Anglia

This code is published under the GNU Lesser General Public License (LGPL) 3.

Please contact Han Gong (gong@fedoraproject.org) with questions regarding 
commercial licensing or commercial cooperation.

![alt text](http://www2.cmp.uea.ac.uk/~ybb15eau/josa2016.jpg "Pipeline")

## REQUIREMENT
This code was tested on MATLAB 2015b x64 Ubuntu. The other versions of MATLAB 
may work but the results may not be identical.

## NOTICE
This code is a pure MATLAB script implementation (non-MEX). Therefore, it is NOT optimised for speed. Only the parameter training code is not shared here. But, normally, the provided default set of parameters should do a good job if the binary *shadow mask* is detected in a good accuracy. If you would like to incorporate your own automatic shadow detection algorithm, simply replace the variable 'smsk' in deshadow.m with your own binary shadow mask image.

## Usage
main.m is the driver for batch shadow removal. Please see main.m or execute
doc main in MATLAB terminal

getinput.m is the driver for obtaining the user input for image I.

para.mat is the pre-trained parameter set for general shadow removal.

## Shadow Removal Dataset and Online Benchmark for Variable Scene Categories
To encourage the open comparison of single image shadow removal in community, we provide an [online benchmark site](http://cs.bath.ac.uk/~hg299/shadow_eval/eval.php) and a dataset. Our quantitatively verified high quality dataset contains a wide range of ground truth data (214 test cases in total). Each case is rated according to 4 attributes, which are texture, brokenness, colourfulness and softness, in 3 perceptual degrees from weak to strong.
