function u=PartiMoDe_StEn(times, depths, S, M, L, fZero, surfaceInflux, surfaceLossRate, odeOptions)
%% Description
% Implementation of the PartiMode model where particle movement and 
% destruction depends on location, but not on time 
% Author: Niklas Hohmann
% email: N.H.Hohmann (at) uu.nl , ORCID: https://orcid.org/0000-0003-1559-1838
%% Inputs:
% times: Vector with strictly increasing positive numbers. The points in
%       time where the model outputs are determined
% depths: vector of strictly increasing numbers with depths(1)=0. The
%       depths/locations where the model outputs are determined
% S:    Function handle. S=S(x) is a function of one variable that  determines
%       the advective flux at depth x
% M:    Function handle. M=M(x) is a function of one variable that determines
%       the diffusive flux at depth x
% L:    Function handle. L=L(x) is a function of one variable that determines the disintegration rate of
%       particles at depth x
% fZero: Function handle. fZero=fZero(x) is a function of one variable that describes the initial
%       condition, e.g. the state of the system at t=0
% surfaceInflux: a scalar >= 0 describing the influx of new 
%       particles through the sedimen surface per time unit 
% surfaceLossRate: a scalar >= 0 describing the rate with which with which
%       particles are lost through the sediment surface
% odeOption: options structure to be handed over to the ODE solver ode15s.
%       For details type
%       doc odeset
%       into the command line and/or see
%       https://www.mathworks.com/help/matlab/math/summary-of-ode-options.html

%% Outputs
% u: Matrix with length(depths) rows and length(times) colums. u(i,j) is
%       the value of u(x,t) at depth x=depths(i) and time t=times(j)

%% See also
% * File "Example_PartiMode_StEn.m" for an example
% * Function PartiMoDe_LoFi: particle input changes with time
% * Function PartiMoDe: effects are depth and time-dependent
% * Function PartiMoDe_Interpol: interpolation of results
% * Function StratProfile: determines particle density as a function of
%       depth

%% Define Flux and Source/Sink Terms
% See Matlab help page of the pdepe function for details on how to code
%       partial differential equations:
%       https://www.mathworks.com/help/matlab/ref/pdepe.html
function [c,f,s] = pdefun(x,~,u,dudx)
% coefficient on left side (in front of d/dt u(x,t)) is always 1
c = 1;
% flux = diffusive flux + advective flux  (negative sign because of
%       downcore advection)
f =  M(x) * dudx - S(x) * u;
% Sink term: loss of particles because of the disintegration rate
s = - L(x)*u;
end

%% Define Boundary Conditions
function [pL,qL,pR,qR] = boundaryconditions(~,uL,xR,uR,~)
% See Matlab help page of the pdepe function for details on how to code
%       partial differential equations
%       https://www.mathworks.com/help/matlab/ref/pdepe.html
%       Here left ("L") is the sediment surface, and R is the bottom of the
%       observed interval

% Standard form for boundary conditions at the surface is
%       pL + qL*flux=0 
%       Particle flux through the sediment surface is determined by the
%       surface influx and the surface loss rate
%       flux = surface influx - surface loss rate * u
pL = surfaceInflux - surfaceLossRate*uL;
qL = 1;

% Standard form for boundary conditions at bottom is
%       pR + qR*flux=0 
% No diffusive flux of particles at the bottom. Since
%       flux = flux_adv + flux_diff
%       we get
pR = S(xR)*uR;
qR = 1;
end

%% Solve PDE
% Hand functions over to pdepe to determine u(x,t) at the specified
%       times and depths
u = pdepe(0,@pdefun,fZero,@boundaryconditions,depths,times,odeOptions);
u=u';
end