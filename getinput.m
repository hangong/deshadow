function getinput(varargin)
%GETINPUT obtains user input
%
%   GETINPUT(PRAN) specifies the user input for the images in data
%   path specified by their index PRAN in alphabetical order.
%
%   Example
%   -------
%       getinput(200); % remove shadow from 1 image and show information
%       getinput(1:2); % remove shadow from 1 image and show information
% Copyright Han Gong 2016

addpath('functions'); % path of general functions
paths = datapath(true); % add image path
[imgs,img_name] = loadimlist(paths); % load image list
len = size(img_name,1);
path = 'in/';
wz = 6;

if ~exist(path,'dir'), mkdir(path); end
if nargin==1, lset = varargin{1}; else lset = 1:len; end

for i = lset
    im = imread(imgs{i});
    imsz = size(im); imhw = imsz(1:2);
    % sample area extraction
    imshow(im);           % display image
    msk = zeros(imhw);
    title('Select Lit Pixels');
    while true % get lit pixels
        [~,x,y] = freehanddraw(gca,'color','r','linewidth',wz); % get xy
        if length(x)>2
            tmsk = xy2msk([x,y]',imhw,wz); % convert xy to mask
            msk = msk + tmsk;
        else break;
        end
    end
    title('Select Shadow Pixels');
    while true % get shadow pixels
        [~,x,y] = freehanddraw(gca,'color','b','linewidth',wz); % get xy
        if length(x)>2
            tmsk = xy2msk([x,y]',imhw,wz); % convert xy to mask
            msk = msk + 0.5*tmsk;
        else break;
        end
    end
    imwrite(msk,[path,img_name{i},'.png']);
end

close gcf;

rmpath('functions'); % path of general functions
datapath(false);

end
