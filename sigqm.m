function qm = sigqm(sig)
% sigqm measures the signal quality of a sampling line
%
% sig: input signal

c2g = [0.2989;0.5870;0.1140];
gsig = sig*c2g; % convert to grey scale signal
sigl = size(gsig,1);
hl = round(sigl/2);

dsig = diff(gsig);

qm = (mean(gsig(1:hl))/mean(gsig(hl+1:end))) + std(dsig);

end
