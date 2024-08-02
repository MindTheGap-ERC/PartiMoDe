%% Introduction
% Example on how to use the PartiMoDe_StEn function
% Author: Niklas Hohmann
% email: N.H.Hohmann (at) uu.nl , ORCID: https://orcid.org/0000-0003-1559-1838

%% Define Grid
timeMax=1;
depthMax=1;
timeSteps=100;
depthSteps=50;
times=linspace(0,timeMax,timeSteps);
depths=linspace(0,depthMax,depthSteps);

%% Parameters of Surface Sediment Layer
sedRate=1;
bioDiffusion=0.1;
mixingDepth=0.95;
disintegrationRate=1;
bottomDisintegrationZone=0.5;
declineDisintegrationBelowZone=10;
surfaceInflux=0.1;
surfaceLossRate=0.1;

%% Define Coefficient Functions
M=@(x) bioDiffusion* (x<=mixingDepth);
S=@(x) sedRate;
L=@(x) min([disintegrationRate, exp(-declineDisintegrationBelowZone*(x-bottomDisintegrationZone))]);

meanInitialParticleDepth=0.5;   %mean depth of particles at t=0
sdInitialParticleLocation=0.05; %SD of particle depths at t=0
% location of particles at t=0 is determined by pdf of normal distribution
fZero=@(x) 1/(sdInitialParticleLocation*sqrt(2*pi))*exp(-0.5*((x-meanInitialParticleDepth)/sdInitialParticleLocation).^2);

%% Set Options for PDE solver
odeOptions = odeset('RelTol',1e-9,'AbsTol',1e-9);
% Default options are
% for 'RelTol': 1e-3,
% for 'AbsTol': 1e-6
% type "doc odeset" in command line or go to 
% https://www.mathworks.com/help/matlab/math/summary-of-ode-options.html
% for an overview of the available options

%% Solve PDE
u=PartiMoDe_StEn(times, depths, S, M, L, fZero, surfaceInflux, surfaceLossRate, odeOptions);

%% Plots
figure
plot(times,arrayfun(M,times))
xlabel("Depth")
ylabel("Mixing M")
title("Mixing Intensity")
ylim([0,1.1*bioDiffusion])

figure
plot(times,arrayfun(L,times))
xlabel("Depth")
ylabel("Disintegration Rate L")
title("Disintegration Rate")
ylim([0,1.1*disintegrationRate])

figure
plot(times, arrayfun(fZero,times))
xlabel("Depth")
ylabel("Initial Condition f_0")
title("Initial Condition  (Particle Density at t=0 / Influx)")
ylim([0,1.1*max(arrayfun(fZero,times))])


levels=[0,10.^(-5:0.25:1)];
figure
contourf(times,depths,u,levels,'ShowText','On')
xlabel('Time t')
ylabel('Depth x')
title('u(x,t)')
set(gca, 'Ydir', 'reverse')
set(gca, 'YAxisLocation', 'Left')
set(gca, 'XAxisLocation', 'Top')

% close all
