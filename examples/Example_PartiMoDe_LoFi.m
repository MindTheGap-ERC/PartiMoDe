%% Introduction
% Example on how to use the PartiMoDe_LoFi function
% For an empirically realisic example see the file "Example_CGibba.m"
% Author: Niklas Hohmann
% email: N.H.Hohmann (at) uu.nl , ORCID: https://orcid.org/0000-0003-1559-1838

%% Define Grid
ageMax=1;
depthMax=1;
timeSteps=100;
depthSteps=50;
ages=linspace(0,ageMax,timeSteps);
depths=linspace(0,depthMax,depthSteps);


%% Parameters of Surface Sediment Layer
sedRate=1;
bioDiff=0.1;
bottomSML=0.95;
disintegrationRate=1;
bottomDisintegrationZone=0.5;
surfaceLossRate=0;

 %% Define Coefficient Functions
 % Mixing
M=@(x) bioDiff* (x<=bottomSML);
% Advection
S=@(x) sedRate; 
% Disintegration
L=@(x) min([disintegrationRate, exp(-10*(x-bottomDisintegrationZone))]);

% Location of Particle Input
sd=0.05; %SD of normal distribution
mu=0.5; % loc of normal distr
% pdf of half normal distribution
% input location
particleInputLocation=@(x) 2/(sd*sqrt(2*pi))*exp(-0.5*((x-mu)/sd).^2);

% Volume of Particles placed in the Sediment
particleInputVolume=@(t) sin(3*pi*t) + 1.1;


%% Set options for PDE solver
odeOptions = odeset('RelTol',1e-9,'AbsTol',1e-9);
% Default options are
% for 'RelTol': 1e-3,
% for 'AbsTol': 1e-6
% For details type
% doc odeset
% in te command line and/or see
% https://www.mathworks.com/help/matlab/math/summary-of-ode-options.html
% for details

%% Plot Coefficient Functions and Initial Conditions
figure
plot(depths,arrayfun(M,depths))
xlabel("Depth")
ylabel("Mixing M")
ylim([0,1.1*bioDiff])

figure
plot(depths,arrayfun(L,depths))
xlabel("Depth")
ylabel("Disintegration Rate L")
ylim([0,1.1*disintegrationRate])

figure
plot(depths, arrayfun(particleInputLocation,depths))
xlabel("Depth")
title("Location of Particle Input")
xlabel("Particel Input per Depth Increment (Initioal Condition)")

figure
plot(ages, arrayfun(particleInputVolume,ages))
xlabel("Time before Present")
ylabel("Particle Input Volume per time increment")
ylim([0,1.1*max(arrayfun(particleInputVolume,ages))])

%% Plot Input of Particles

A=ones([length(ages),length(depths)]);
for i=1:length(ages)
    for j=1:length(depths)
        A(i,j)=particleInputVolume(ages(i))*particleInputLocation(depths(j));
    end
end
figure
contourf(ages,depths,(A)','ShowText','on')
xlabel('Time before Present')
ylabel('Depth')
title('Particle Input')
set(gca, 'Ydir', 'reverse')
set(gca, 'YAxisLocation', 'Left')
set(gca, 'XAxisLocation', 'Top')


%% Solve PDE
ADD=PartiMoDe_LoFi(ages, depths, S, M, L, particleInputLocation, particleInputVolume, surfaceLossRate, odeOptions);

%% Plot results
levels=[0,10.^[-5:0.25:1]];
figure
contourf(ages,depths,ADD,levels,'ShowText','On')
xlabel('Time t')
ylabel('Depth x')
title('u(x,t)')
set(gca, 'Ydir', 'reverse')
set(gca, 'YAxisLocation', 'Left')
set(gca, 'XAxisLocation', 'Top')






