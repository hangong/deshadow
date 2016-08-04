function [fsig,sf,bl,bd] = alnsig(bl,bd)
%ALNSIG aligns the signals
%
% Copyright Han Gong 2014
global deb

alen = max(bl.l); % average bl.vnal length
vlen = length(bl.l); % number of valid samples
rsig = zeros(alen,3,vlen); % re-scaled intensity
ri = linspace(0,1,alen); % re-scaled sample sites

%% re-scale intensity
for i = 1:vlen, rsig(:,:,i) = resize(bl.v{i},[alen,3]); end
ags = mean(mean(rsig,3),2); ags = ags/ags(end); % average signal
cs = zeros(vlen,1); ss = zeros(vlen,1);
rgs = squeeze(mean(rsig,2)); rgs = bsxfun(@rdivide,rgs,rgs(end,:));
for i = 1:vlen % find alignment parameters
    [cs(i),ss(i)] = optfit(ags,rgs(:,i));
end

%% re-align
fsig = zeros(alen,3,vlen); % re-aligned intensity
for i = 1:vlen
    % re-align intensity
    si = cs(i)+linspace(ss(i),1-ss(i),alen); % re-aligned sites
    for ch = 1:3
        fsig(:,ch,i) = interp1(si,rsig(:,ch,i),ri,'nearest','extrap');
    end
end

%% rectify boundary points and sampling line
sf.s = ss; % vertical stretching
sf.c = cs; % central shift
nbdv = bl.e-bl.s; % updated sampling vector
vw = arrayfun(@(x) norm(nbdv(:,x)), 1:length(bl.s));
bd.w = zeros(1,length(bd.t)); bd.w(~bd.t) = vw;

if deb
    % re-aligned RGB wrap
    rsview = permute(rsig,[1,3,2]);
    sview = permute(fsig,[1,3,2]);
    % plot stuff
    figure('Name','Penumbra Unwrap');
    subplot(2,1,1);imshow(rsview);title('unwrapped penumbra');
    axis off; axis image;
    subplot(2,1,2);imshow(sview);title('aligned penumbra');
    axis off; axis image;
end

end
