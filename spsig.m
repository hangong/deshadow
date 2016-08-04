function [bd,bl] = spsig(bl,bd,dimg,DBScan_Rad,Meanshift_Rad)
%SPSIG samples and selects valid signals
%
% Copyright Han Gong 2014
global deb;

imsz = size(dimg); imhw = imsz(1:2);
len = size(bl.s,2); % length of selected boundary points
tt = zeros(len,1); % a copy of original types

%% filter signals using constraint of length
svec = bl.s-bl.e; % vector of sampling line
slen = arrayfun(@(x) norm(svec(:,x)), (1:len)'); % sampling line lengths
l_l = 3; h_l = mean(slen)+3*std(slen);
tt(slen<=l_l|slen>=h_l) = -2; % reject sample with invalid length
% get sample id with valid length
lsid = find(~tt);
llen = length(lsid);

bl.v = cell(len,1); bl.cx = cell(len,1); bl.cy = cell(len,1);
%% sample raw signal
for i = 1:llen
    id = lsid(i);
    % sampling line pixel coordinates
    xi = sat([bl.s(1,id),bl.e(1,id)],1,imhw(2));
    yi = sat([bl.s(2,id),bl.e(2,id)],1,imhw(1));
    % sample signals
    [bl.cx{i},bl.cy{i},bl.v{i}] = improfile(dimg,xi,yi);
    bl.v{i} = permute(bl.v{i},[1,3,2]);
end

%% filter signals using constraint of quality
sigq = arrayfun(@(x) sigqm(bl.v{x}), 1:llen);
% valid signal quality threholds
q_lmax = 1; q_l = min(mean(sigq)+2*std(sigq),q_lmax);
% reject invalid samples due to bad quality
tt(lsid(sigq>=q_l)) = -3;
qsid = find(~tt);

%% filter signals using constraint of illumination change
% reject invalid samples due to illumination change mismatch
[~,rid] = intersect(lsid,qsid); rlen = numel(rid); 
omf = zeros(rlen,3); mf = zeros(rlen,3);
for k = 1:rlen
    i = rid(k); %hl = max(round(size(bl.v{i},2)/2),1); % half of length
    %uf = median(bl.v{i}(hl+1:end,:)); df = median(bl.v{i}(1:hl,:));
    uf = bl.v{i}(end,:); df = bl.v{i}(1,:);
    omf(k,:) = log(uf+1)-log(df+1);
end
[mf(:,1),mf(:,2),mf(:,3)] = cart2sph(omf(:,1),omf(:,2),omf(:,3));
cm = dbscan(mf,3,DBScan_Rad); % classify the illumination changes
[~,hc] = max(histc(cm,1:max(cm))); % find the majority group
om = cm==hc; % orginal majority cluster
mm = imfillhole(om,10); % prevent noise
tt(lsid(rid(~mm))) = -4; % discard minorities

mid = find(mm); % id of majority group
[~,cc] = MeanShiftCluster(omf(mid,:)',Meanshift_Rad); % further divide the majority groups
hc2 = histc(cc,1:max(cc)); % find the majority groups
vhc = find(hc2>max(hc2)/10);
tt(lsid(rid(mid))) = -5; % discard minorities
for ci = 1:numel(vhc), tt(lsid(rid(mid(cc==vhc(ci))))) = 0; end

% remove contours with too few valid samples
blm = bd.m(~bd.t); % original sampling line mark
bum = unique(blm); % set of marks
hm = histc(blm(~tt),bum); % count of marks
bim = bum(hm<4); % invalid marks
tt(ismember(blm,bim)) = -4; % mark invalid samples

csid = find(~tt);
bd.t(~bd.t) = tt; % update boundary point types
[vid,vidk] = intersect(lsid,csid); % filter bad sampling lines

if deb
    isid = setxor(1:len,vid'); % get invalid sample id
    % select samples for plotting according to the demo type
    if deb == 1
        demo_vid = vid'; % normal plotting
        demo_isid = isid; 
        demo_lw = 0.5; % line width specification
    else
        demo_sp = 5; % plotting density
        demo_vid = vid(1:demo_sp:length(vid))'; % plotting for paper display
        demo_isid = isid(1:demo_sp:length(isid));
        demo_lw = 4;
    end

    % plot sampling lines
    for i = demo_vid
        sxi = [bl.s(1,i),bl.e(1,i)]; syi = [bl.s(2,i),bl.e(2,i)];
        pv = plot(sxi,syi,'b','LineWidth',demo_lw);
    end
    pli = NaN(4,1); tc = {'c','m','r','g'};
    txt = {'invalid length','invalid quality','minority group',...
           'minority class','valid samples'};
    % do the same for invalid samples
    for i = demo_isid
        sxi = [bl.s(1,i),bl.e(1,i)]; syi = [bl.s(2,i),bl.e(2,i)];
        tid = -tt(i)-1;
        if tid~=2, pli(tid) = plot(sxi,syi,tc{tid},'LineWidth',demo_lw); end
    end
    % plot legends
    lm = ~isnan(pli); % used legend mask
    legend([pli(lm);pv],txt{[lm;true]});
    hold off;
end

bl.s = bl.s(:,vid); bl.e = bl.e(:,vid);
bl.cx = bl.cx(vidk); bl.cy = bl.cy(vidk); bl.v = bl.v(vidk);
bl.l = arrayfun(@(x) size(bl.v{x},1), find(vidk)); % line lengths

end
