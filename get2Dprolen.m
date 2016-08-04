function [prolen] = get2Dprolen(vec,vecpro)
% [prolen] = get2DproLen(vec,vecpro) This function gets the projection length
% 
% INPUTS:
%   vec: a 2D vector to be projected
%   vecpro: 2 2D vector to be projected on
% OUTPUTS:
%   prolen: length of projection
% 
% Copyright Han Gong 08/01/2011

prolen = dot(vec,vecpro)/norm(vecpro);