function [rimg,bd,bl,smsk,sig] = deshadow(im,ip,v) % lxy sxy
%DESHAOW removes shadow from input image
%
% Copyright Han Gong 2014

global deb;

imsz = size(im); imhw = imsz(1:2); % image size

%% detect rough shadow mask
if deb, disp('detect rough shadow mask...'); end
limsk = ip>0.9; simsk = ip<0.6&ip>0.4;
smsk = getrmask(im,limsk,simsk,v(1)); % get shadow mask

%% detect illumination
if deb, toc; disp('detect illumination...'); tic; end
fu = optfuse(im,limsk,simsk); % get fusion image and parameter
ffu = medfilt2(fu,v(2)*[1,1]);

%% sparse scale estimation
if deb, toc; disp('sparse scale estimation...'); tic; end
% get shadow boundary
bd = getbd(smsk,ceil(max(imhw)/512));
% get two ends of sampling lines
bl = bdspln(ffu,smsk,bd,v(5));
% sample and select valid signals
[bd,bl] = spsig(bl,bd,im,v(3),v(4));
% intensity alignment
[sig,sf,bl,bd] = alnsig(bl,bd);
% fit intensity
bl = fitsig(sig,sf,bl,bd);

%% propagate shadow scale field
if deb, toc; disp('propagate shadow scale field...'); tic; end
[imsc,msk] = ppgsf(bl,bd,smsk);

%% relight image
rimo = min(im./min(imsc,1),1);

%% align colour
if deb, toc; disp('align colour...'); tic; end
% start colour alignment
rimg = colaln(rimo,msk,imsc,v(6));
%rimg = rimo; % to disable colour alignment
rimgsc = im./rimg;

if deb
    figure('Name','Comparison of Colour Alignment');
    subplot(4,2,1);imshow(im);title('original');
    subplot(4,2,2);imshow(double(smsk));title('rough shadow mask');
    subplot(4,2,3);imshow(fu);title('original illumination layer');
    subplot(4,2,4);imshow(ffu);title('filtered illumination layer');
    subplot(4,2,5);imshow(imsc);title('shadow scale matte');
    subplot(4,2,6);imshow(rimgsc);title('adjusted scale matte');
    subplot(4,2,7);imshow(rimo);title('relit')
    subplot(4,2,8);imshow(rimg);title('adjusted');
end

end

