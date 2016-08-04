function out = colaln(in,msk,sc,BilaterialF_SR)
%COLALN performs colour transfer to correct artefacts
%
% Copyright Han Gong 2014

global deb

imsz = size(in); imhw = imsz(1:2); imel = imhw(1)*imhw(2);

%% compute transfer function
fsz = 2.^(2:4); % kernel size
pysz = numel(fsz); % pyramid size

% create masks
be_i = strel('disk',20); expmask = imdilate(msk.p,be_i);
sasmask = and(expmask,msk.s); satmask = and(expmask,msk.l);

% index of umbra, umbra-side tiny boundary, lit side tiny boundary
sidx = find(~msk.l); usidx = find(sasmask); lsidx = find(satmask);
cin = in;

rstd = zeros(3,pysz);
if deb, figure; title('Pyramid variation alignment'); end

for i = 1:pysz % multi-scale noise alignment
    if deb, oin = cin; end
    fin = zeros(size(in)); % bilaterally filtered image
    for ch = 1:3 % filter image
        tl = cin(:,:,ch);
        fin(:,:,ch) = bFilter(tl,tl,0,1,min(imhw)/fsz(i),BilaterialF_SR);
    end
    ein = cin-fin; % difference of bilateral
    for ch = 1:3
        os = (ch-1)*imel; % pixel offset
        % brightness adjustment
        rstd(ch,i) = mad(ein(lsidx+os),1)/mad(ein(usidx+os),1); % compute std ratio
        tidx = sidx+os;
        cin(tidx) = fin(tidx)+rstd(ch,i)*ein(tidx);
    end
    if deb
        dcol = max(pysz,5);
        subplot(pysz+1,dcol,i); imshow(cin);
        rein = ein; % corrected differnece for display
        for ch = 1:3
            rein(tidx) = rstd(ch,i)*ein(tidx);
        end
        subplot(pysz+1,dcol,i*dcol+1); imshow(oin); title('original');
        subplot(pysz+1,dcol,i*dcol+2); imshow(fin); title('filtered');
        subplot(pysz+1,dcol,i*dcol+3); imshow(abs(ein)); title('error');
        subplot(pysz+1,dcol,i*dcol+4); imshow(abs(rein)); title('adjusted error');
        subplot(pysz+1,dcol,i*dcol+5); imshow(cin); title('corrected');
    end
end

aout = cin;

%% scale-based regularisation
out = zeros(imsz);
for ch = 1:3
    tsc = sc(:,:,ch);
    msc = min(tsc(:)); nsc = (tsc-msc)/(1-msc);
    out(:,:,ch) = in(:,:,ch).*nsc + aout(:,:,ch).*(1-nsc);
end

end
