function main(fdeb,pran)
%MAIN is the driver for batch shadow removal.
%   MAIN takes two optional parameters: FDEB is a debug flag which allows
%   for showing intermediate results; PRAN is a vector that specifies the 
%   numbers of which images to remove shadow from. The paths of images are
%   defined in datapath.p ('data/original').
%
%   MAIN removes shadow from all images in data path without showing
%   debug information.
%
%   MAIN(FDEB) removes shadow from all images in data path and shows
%   debug information if FDEB is true.
%
%   MAIN(FDEB,PRAN) removes shadow from the images in data path specified
%   by their index PRAN in alphabetical order.
%
%   Example
%   -------
%       main(false,200:203); % remove shadow from 4 images quietly
%       main(true,200); % remove shadow from 1 image and show information
%       main; % remove shadow from all images quietly
%
  
%   Copyright 2014-2015 Han Gong, University of Bath

paths = datapath(true); % add image files to path
[imgs,img_name] = loadimlist(paths); % load image files
len = size(img_name,1); % length of testcases
ipath = 'in/'; % input path
opath = 'out/'; % output path
if ~exist(opath,'dir'), mkdir(opath); end

% global definition
global deb; deb = 0; % debug mark
% load global parameters
ran = 1:len;

if nargin>1, ran = pran; end;
if nargin>0, deb = fdeb; end;

load('para.mat','v'); % load parameters

for i = ran
    fprintf('PROCESS %s (%d/%d)\n',imgs{i},i,len); tic;
    img = im2double(imread([paths{1},'/',imgs{i}])); % input image
    imsk = im2double(imread([ipath,img_name{i},'.png'])); % load user input
    rimg = deshadow(img,imsk,v); % remove shadow
    imwrite(rimg,[opath,img_name{i},'.','tif']); % output
    toc;
end

datapath(false); % remove image files from path

end
