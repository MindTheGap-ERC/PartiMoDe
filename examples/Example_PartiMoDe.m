%% Introduction
% Simple example on how to use the PartiMoDe and StratProfile function
% Artificial scenario where particle movement depends on time and location
% Author: Niklas Hohmann
% email: N.H.Hohmann (at) uu.nl , ORCID: https://orcid.org/0000-0003-1559-1838

%% Define Grid
timeMax=1;
depthMax=1;
timeSteps=100;
depthSteps=50;
times=linspace(0,timeMax,timeSteps); % times where the model is evaluated
depths=linspace(0,depthMax,depthSteps); % depths where the model is evaluated

%% Define Initial Condition
meanInitialParticleDepth=0.5;   %mean depth of particles at t=0
sdInitialParticleLocation=0.05; %SD of particle depths at t=0
% location of particles at t=0 is determined by pdf of normal distribution
fZero=@(x) 1/(sdInitialParticleLocation*sqrt(2*pi))*exp(-0.5*((x-meanInitialParticleDepth)/sdInitialParticleLocation).^2);

%% Plot Initial Condition
figure
plot(depths, arrayfun(fZero,depths))
xlabel("Depth")
ylabel("Particle Density")
title("Particle Density at t=0 (Initial Condition)")

%% Define Surface Loss Rate
surfaceLossRate=@(t) max([0.01*sin(8*pi*t),0]);

%% Plot Surface Loss Rate
figure
plot(times,arrayfun(surfaceLossRate,times))
xlabel("Time")
ylabel("Particle Loss Rate")
title("Loss of Particles through the Sediment Surface (Surface Loss Rate)")

%% Define Surface Influx
surfaceInflux=@(t)  max([10*cos(8*pi*t),0]);

%% Plot Surface Influx
figure
plot(times,arrayfun(surfaceInflux,times))
xlabel("Time")
ylabel("New Particles per Time Unit")
title("Influx of New Particles Through the Sediment Surface (Surface Influx)")

%% Define Diffusion Term
M = @(x,t) (x<0.7) * (sin(t)+1.1);

%% Plot Diffusion Term
A=ones([length(times),length(depths)]);
for i=1:length(times)
    for j=1:length(depths)
        A(i,j)=M(times(i),depths(j));
    end
end
figure
contourf(depths,times,A,'showtext','On')
xlabel("Time")
ylabel("Depth")
title("Mixing Intensity M=M(x,t)")
set(gca, 'Ydir', 'reverse')
set(gca, 'YAxisLocation', 'Left')
set(gca, 'XAxisLocation', 'Top')

%% Define Advection Term
S= @(x,t) ((x<0.2) + 0.5*(x>=0.2))*(0.2*cos(t)+0.21);

%% Plot Advection Term
A=ones([length(times),length(depths)]);
for i=1:length(times)
    for j=1:length(depths)
        A(i,j)=S(times(i),depths(j));
    end
end
figure
contourf(depths,times,A,'showtext','On')
xlabel("time")
ylabel("depth")
title("Advection S=S(x,t)")
set(gca, 'Ydir', 'reverse')
set(gca, 'YAxisLocation', 'Left')
set(gca, 'XAxisLocation', 'Top')

%% Define Disintegration Rate
L=@(x,t) exp(-5*x)*(0.1*sin(t*2*pi)+0.11);

%% Plot Disintegration Rate
A=ones([length(times),length(depths)]);
for i=1:length(times)
    for j=1:length(depths)
        A(i,j)=L(times(i),depths(j));
    end
end
figure
contourf(depths,times,A,'showtext','On')
xlabel("time")
ylabel("depth")
title("Disintegration Rate L=L(x,t)")
set(gca, 'Ydir', 'reverse')
set(gca, 'YAxisLocation', 'Left')
set(gca, 'XAxisLocation', 'Top')


%% Set Options for PDE solver
odeOptions = odeset('RelTol',1e-9,'AbsTol',1e-9);
% Default options are
% for 'RelTol': 1e-3,
% for 'AbsTol': 1e-6
% For details type
% doc odeset
% in te command line and/or see
% https://www.mathworks.com/help/matlab/math/summary-of-ode-options.html
% for details

%% Solve PDE
u=PartiMoDe(times, depths, S, M, L, fZero, surfaceInflux, surfaceLossRate, odeOptions);

%% Plots Particle Density
figure
levels=10.^(-5:0.1:4);
contourf(times,depths,u,levels,'ShowText','On')
xlabel('Time t')
ylabel('Depth x')
title('Particle Density u(x,t)')
set(gca, 'Ydir', 'reverse')
set(gca, 'YAxisLocation', 'Left')
set(gca, 'XAxisLocation', 'Top')

% close all

%% Plot Stratigraphic Profile
d=StratProfile(u,times); % get profile

plot(depths,d)
xlabel('Depth x')
ylabel('Particle Density')



