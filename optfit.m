function [c,s] = optfit(rs,ts)
% v = optfit(sig) This function fits signal to a piece-wise cubic curve
%
% Copyright Han Gong 02/04/2014

    function f = objfun(v) % object function
        rx = v(1)+linspace(v(2),1-v(2),slen); % re-aligned sites
        y = interp1(tx,ts,rx,'nearest','extrap'); % evaluate
        f = sumsqr(rs-y'); % get error
    end

    slen = size(ts,1); % get length of signal
    tx = linspace(0,1,slen); % x coordinates
    v0 = [0;0]; % initial guess of fit
    lb = [-0.25;-0.5];
    ub = [0.25;0.5]; % para limit
    options = optimset('Algorithm','sqp','Display','off');
    v = fmincon(@objfun,v0,[],[],[],[],lb,ub,[],options);
    c = v(1); s = v(2);
end
