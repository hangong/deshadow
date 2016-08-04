function [imsc,msk] = ppgsf(bl,bd,smsk)
%PPGSF propagates shadow scale field from scale scales
%
% Copyright Han Gong 2014

global deb

%% prepare sparse scales
imhw = size(smsk); vlen = size(bl.s,2);
dfsnum = sum(bl.l); % total number of scale sites
as = zeros(dfsnum,3); cxy = zeros(dfsnum,2); % scale and coordinates
dfsptr = 1; % pointer of updating location
eas = zeros(vlen,3);

for i = 1:vlen
    % get starting point and ending point
    curidx = dfsptr:dfsptr+bl.l(i)-1;
    cxy(curidx,:) = [bl.cx{i},bl.cy{i}];
    as(curidx,:) = bl.sc{i}; eas(i,:) = bl.sc{i}(1,:);
    dfsptr = dfsptr+bl.l(i);
end

ks = median(eas,1); % get average scale
bdip = bd.p(:,bd.t==-1|bd.t==-4)'; % unsampled boundary points
sb = repmat(ks,size(bdip,1),1); % assign scales

%% dense scale interpolation
% shadow masks (penumbra, shadow, lit)
msk.p = getpmsk(bd,imhw); msk.s = ~msk.p&smsk; msk.l = ~msk.p&~smsk;

% generate meshgrid for 2D interpolation
pidx = find(msk.p); [px,py] = ind2sub(imhw,pidx);
imsc = zeros([imhw,3]); % scale image
% 2D interpolation and extrapolation
for i = 1:3
    F = scatteredInterpolant(cxy(:,1),cxy(:,2),as(:,i),'natural','none');
    timg = NaN(imhw);
    timg(pidx) = F(py,px); % fill penumbra scale from sparse scales
    timg(msk.l) = 1; % lit area scale
    timg(sub2ind(imhw,bdip(:,2),bdip(:,1))) = sb(:,i); % fill unsampleds
    timg = inpaint_nans(timg,4); % fill umbra scale
    imsc(:,:,i) = timg;
end

if deb
    figure; scatter(cxy(:,1),cxy(:,2),2,as,'filled');
    axis ij; axis image; axis([0 imhw(2) 0 imhw(1)]); axis off;
    title('sparse scales');
end

end
