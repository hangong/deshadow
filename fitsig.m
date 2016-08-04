function bl = fitsig(sig,sf,bl,bd)
%FITSIG fits signal and get the scale curve
%
% Copyright Han Gong 2014

global deb

blm = bd.m(~bd.t); % boundary marker
blen = size(sig,3); % number of samples
alen = size(sig,1); % sample length
bl.sc = cell(blen,1); % scales of sampling line
sm = unique(blm); % set of contours
nsm = numel(sm); % number of contours

ri = linspace(0,1,alen); % re-scaled sample sites

if deb, figure('Name','Scales And Relighting'); end
for j = 1:nsm % traverse each contour
    mid = find(blm == sm(j)); % find the index of a boundary
    ml = numel(mid); % length of index
    msig = sig(:,:,mid); % signal of current contour
    osig = msig; % a copy of original signal
    ssig = zeros(size(msig)); % scales of current contour
    fsz = 2.^(2:6); % pyramid kernel size
    fl = numel(fsz); % number of layers
    psig = zeros([size(msig),fl]); % pyramid scales
    for fi = 1:fl
        h = fspecial('average',[1,fsz(fi)]); % averaging kernel        
        for ch = 1:3 % local filtering
           fsig = squeeze(imfilter(squeeze(msig(:,ch,:)),h,'symmetric'));
           psig(:,ch,:,fi) = bsxfun(@rdivide,fsig,fsig(end,:));
        end
    end
    psm = zeros(ml,fl); % roughness measurement
    bs = zeros(ml,1);
    for fi = 1:fl
        for mi = 1:ml
            psm(mi,fi) = sumsqr(diff(psig(:,:,mi,fi),2,1));
        end
    end
    msm = mean2(psm); % average smoothness
    for mi = 1:ml % find the best scale for sample
        fr = find(psm(mi,:)<msm,1,'first');
        if isempty(fr), bs(mi) = fl; else bs(mi) = fr; end
        ssig(:,:,mi) = psig(:,:,mi,bs(mi));
    end
    trs = zeros(alen,3,ml);
    % mapping back to original sampling sites
    for i = 1:ml % compute scales
        si = linspace(sf.s(i),1-sf.s(i),alen)+sf.c(i); % re-aligned sites
        for ch = 1:3 % revert shifts
            trs(:,ch,i) = interp1(si,ssig(:,ch,i),ri,'nearest','extrap');
        end
        bl.sc{mid(i)} = resize(trs(:,:,i),[bl.l(mid(i)),3]); % resize scales
    end

    if deb % plot debug information
        subplot(4,nsm,j); imagesc(permute(sat(ssig,0,1),[1,3,2]));
        title('scale wrap');
        subplot(4,nsm,nsm+j); imagesc(permute(sat(osig./ssig,0,1),[1,3,2]));
        title('re-lit wrap'); xl=xlim;
        subplot(4,nsm,2*nsm+j); imagesc(psm');
        title('roughness response'); xlim(xl);
        bsm = false(ml,fl); for i = 1:ml, bsm(i,bs(i)) = true; end
        subplot(4,nsm,3*nsm+j); imagesc(bsm');
        title('selected scales'); xlim(xl);
    end
end

% compute sampling line width
bdv = bl.e-bl.s; % original sampling vector (2xN)
vw = arrayfun(@(x) norm(bdv(:,x)), 1:blen);
bd.w = zeros(1,length(bd.t)); bd.w(~bd.t) = vw;

end
