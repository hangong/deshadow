function [imout,v] = optfuse(imin,limsk,simsk)

imhw = size(limsk);
% convert colour spaces and get layers
tmp = rgb2ycbcr(imin);
candi = zeros([imhw,3]);

% normalise the candidate layers
candi(:,:,1) = tmp(:,:,1);
candi(:,:,2) = 1-tmp(:,:,2);
candi(:,:,3) = tmp(:,:,3);

sidx = find(simsk); lidx = find(limsk);

    function f = objfun(v)
        % object function
        fuse_img = sum(bsxfun(@times,candi,reshape(v,[1 1 3])),3);
        lstd = std(fuse_img(lidx));
        sstd = std(fuse_img(sidx));
        astd = std(fuse_img([lidx;sidx]));
        lmean = mean(fuse_img(lidx));
        smean = mean(fuse_img(sidx));
        rmean = smean/lmean;
        f = (lstd/astd + sstd/astd) + rmean;
    end

v0 = 0.33*ones(1,3); % initial guess of fit

lb = zeros(1,3); ub = ones(1,3); % para boundary
options = optimset('Algorithm','sqp','Display','off');
A = ones(1,3); b = 1;
v = fmincon(@objfun,v0,A,b,[],[],lb,ub,[],options);

imout = sum(bsxfun(@times,candi,reshape(v,[1 1 3])),3);
end