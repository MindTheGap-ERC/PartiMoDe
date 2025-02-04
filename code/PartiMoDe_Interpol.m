function [u,dudx]=PartiMoDe_Interpol(atDepths,uSolution,originalDepths,timeIndex)
%% Description
% Interpolates the results generated by the PartiMoDe, PartiMoDe LoFI, and 
% PartiMoDe StEn models
% interpolated the values of u(x,t) and du(x,t)/dx at depths atDepths and
% at time times(timeIndex)
% Author: Niklas Hohmann
% email: N.H.Hohmann (at) uu.nl , ORCID: https://orcid.org/0000-0003-1559-1838
%% Inputs:
% atDepths: Depths where u(x,t) and du(x,t)/dx are determined
% uSolution: Output generated by the functions PartiMoDe, PartiMoDe_LoFI,
%       or PartiMoDe_StEn
% originalDepths: Vector of depths used and input to the functions
%       PartiMoDe, PartiMoDe_LoFI, or PartiMoDe_StEn
% timeIndex: integer, tiimes(timeIndex) is the time at which u(x,t) and du(x,t)/dx
%       will be interpolated
%% Outputs:
% u:    Vector of interpolated values of u(x,t) at x=atDepths and time
%       t=times(timeIndex)
% dudx: Vector of interpolated values of du(x,t)/dx at x=atDepths and time
%       t=times(timeIndex)
%% See Also
% * File "Example_PartiMoDe_Interpol.m" for an example
%% Function body
[u,dudx] = pdeval(0,originalDepths,uSolution(:,timeIndex),atDepths);