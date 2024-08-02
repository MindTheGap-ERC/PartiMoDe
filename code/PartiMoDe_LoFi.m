function ADD=PartiMoDe_LoFi(ages, depths, S, M, L, particleInputLocation, particleInputVolume, surfaceLossRate, odeOptions)
%% Description
% Implementation of the PartiMode LoFi model where
% (1) particle movement and destruction depends on burial depth and is
% independent of time
% (2) Total volume of particles placed in the sediment changed in the past,
% but the location where it was placed in the sediment remained unchanged
% Author: Niklas Hohmann
% email: N.H.Hohmann (at) uu.nl , ORCID: https://orcid.org/0000-0003-1559-1838

%% Inputs:
% ages: Vector with strictly increasing positive numbers. The ages at which
%       the model outputs are determined
% depths: vector of strictly increasing numbers with depths(1)=0. The
%       depths/locations where the model outputs are determined
% S:    Function handle. S=S(x) is a function of one variable that 
%       determines the advective flux at depth x
% M:    Function handle. M=M(x) is a function of one variable that
%       determines the diffusive flux at depth x
% L:    Function handle. L=L(x) is a function of one variable that
%       determines the disintegration rate of particles at depth x
% particleInputLocation: Function handle. particleInputLocation=particleInputLocation(x) is a
%       function of one variable that describes where particles are
%       placed in the sediment
% particleInputVolume: Function handle.
%       particleInputVolume=particleInputVolume(a) is a function of one
%       variable that describes the total volume of particles placed in the
%       sediment at the time a before the onset of the observation
% surfaceLossRate: a scalar >= 0 describing the rate with which with which
%       particles are lost through the sediment surface
% odeOption: options structure to be handed over to the ODE solver ode15s.
%       For details type
%       doc odeset
%       into the command line and/or see
%       https://www.mathworks.com/help/matlab/math/summary-of-ode-options.html

%% Outputs
% ADD: Matrix with length(depths) rows and length(ages) colums. ADD(i,j)
%       is the value of u(x,a) at depth x=depths(i) and
%       age a=ages(j). This is the density of particles of age a at depth x

%% See also
% * File "Example_PartiMoDe_LoFi.m" for an example using this function
% * Function "PartiMoDe": version with time-dependent effects
% * Function "PartiMoDe_StEn": constant particle input into stable
%       environments
% * Function "PartiMoDe_Interpol": interpolates between model outputs
% * Function "StratProfile": determines particle density as a function of
%       depth

%% 1. Define Flux and Source/Sink Terms
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
s = -L(x)*u;
end

%% 2. Define Boundary Conditions
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
pL =  - surfaceLossRate*uL;
qL = 1;

% Standard form for boundary conditions at bottom is
%       pR + qR*flux=0 
% No diffusive flux of particles at the bottom. Since
%       flux = flux_adv + flux_diff
%       we get
pR = S(xR)*uR;
qR = 1;
end

%% 3. Solve PDE
% Hand functions over to pdepe to determine u(x,t) at the specified
% ages and depths
ADD = pdepe(0,@pdefun,particleInputLocation,@boundaryconditions,depths,ages,odeOptions);
ADD = arrayfun(particleInputVolume,ages).*(ADD');
end