function fuse_img = dofuse(img,v)

% convert colour spaces and get layers
[~,~,v1] = rgb2hsv(img);
tmp = rgb2ycbcr(im2double(img));

candi = zeros(size(img));

% normalise the candidate layers
candi(:,:,1) = v1;
candi(:,:,2) = tmp(:,:,1);
candi(:,:,3) = 1-tmp(:,:,2);

fuse_img = sum(bsxfun(@times,candi,reshape(v,[1 1 3])),3);

end