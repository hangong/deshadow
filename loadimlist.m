function [imgs,img_name,img_ext] = loadimlist(paths)
%LOADIMLIST load images from path
%
% Copyright Han Gong 2014

fl = []; for i =1:length(paths), fl = [fl,getAllFiles(paths{i})]; end;

% test images names
imgs = sort_nat(fl);

img_name = cellfun(@(x) sscanf(x, '%[^.]'),imgs,'UniformOutput',false);
img_ext = cellfun(@(x) sscanf(x, '%*[^.]%*[.]%s'),imgs,'UniformOutput',false);

end