This package contains the code for 
"Interactive Shadow Removal and Ground Truth for Difficult Shadow Scenes", 
JOSA 2016
by Han Gong[1,2] and Darren Cosker[1]

[1] University of Bath
[2] University of East Anglia

LICENSE
###########################################################################

Copyright (C) 2016 Han Gong
University of Bath and University of East Anglia

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the distribution
	* This software is only used or redistributed for non-commercial academic
      use.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

Please contact Han Gong (gong@fedoraproject.org) with questions regarding 
commercial licensing or commercial cooperation.

REQUIREMENT
###########################################################################
This code was tested on MATLAB 2013b x64 windows. The other versions of MATLAB 
may work but the results may not be the same.

NOTICE
###########################################################################
This code is a pure MATLAB script implementation (non-MEX). Although this code
is already fast enough, it is still not optimised for speed. It it only fair
to compare our speed with the other pure MATLAB script implementations.

Usage
###########################################################################
* shadow removal *
main.m is the driver for batch shadow removal. Please see main.m or execute
doc main in MATLAB terminal

para.mat is the pre-trained parameter set for general shadow removal.

