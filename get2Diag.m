function [iag] = get2Diag(vec,vecpro)
% [iag] = get2Diag(vec,vecpro) This function gets included angle between
% two vectors
%
% INPUTS:
%   vec: a 2D vector
%   vecpro: another 2D vector
% OUTPUTS:
%   iag: included angle
% 
% Copyright Han Gong 08/01/2011

iag = get2Dprolen(vec,vecpro)/norm(vec);
