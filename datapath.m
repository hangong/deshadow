function paths = datapath(op)
%DATAPATH adds or remove dirs of images
%
% Copyright Han Gong 2014

paths = {
'data/original'; % path of workable images samples
};

if op
    cellfun(@(x) addpath(x),paths);
else
    cellfun(@(x) rmpath(x),paths);
end

end
