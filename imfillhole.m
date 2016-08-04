function out = imfillhole(im,size)
%IMFILLHOLE fills small holes of a binary image
%
% Copyright Han Gong 2013

out = ~bwareaopen(~im, size);

end

