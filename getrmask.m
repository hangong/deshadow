function [seg_o,model] = getrmask(im,limsk,simsk,GaussF_Rad)
%GTERMASK Get the rough shadow mask
%
% Copyright Han Gong 2013
global deb
imsz = size(im); imhw = imsz(1:2);
limg = log(max(im,eps));

sidx = find(simsk); lidx = find(limsk);
% umbra feature selection
ShaNum = size(sidx,1); LitNum = size(lidx,1); SamNum = ShaNum + LitNum;
FeatClass = zeros(SamNum,1);
FeatClass(1:ShaNum) = 1; % mark shadow ones
TrainFeats = zeros(SamNum,3);
for i = 1:3
tmp = limg(:,:,i);
TrainFeats(1:ShaNum,i) = tmp(sidx);
TrainFeats(ShaNum+1:end,i) = tmp(lidx);
end

% umbra learning and rough mask prediction
model = ClassificationKNN.fit(TrainFeats,FeatClass,'NumNeighbors',3);

FeatSpace = zeros(imhw(1)*imhw(2),3);
for i = 1:3
    tmp = limg(:,:,i);
    FeatSpace(:,i) = tmp(:); 
end

[~,slb] = predict(model,FeatSpace);
lbimg = reshape(slb(:,1),imhw);
gsH = fspecial('gaussian',GaussF_Rad,round(GaussF_Rad/2));
smatt = imfilter(lbimg,gsH,'replicate');
p_th = 0.5; % threshold of KNN poster-probability
oim = ones(imhw); oim(smatt>p_th)= 0;

% get the largest component
if ~isempty(find(~oim, 1))
    seg_o = ~imfillhole(~imfillhole(oim, 100), 200);
else
    seg_o = [];
end

%% plot debug info
if deb
    figure('Name','Sampling Lines And Shadow Boundary');
    simg = im; % plot user input
    simg(:,:,1) = min(simg(:,:,1) + limsk,1);
    simg(:,:,3) = min(simg(:,:,3) + simsk,1);
    imshow(simg); axis image; hold on;
end

end

