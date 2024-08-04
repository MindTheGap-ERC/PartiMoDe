# Documentation of the PartiMoDe model

The PartiMoDe model simulates the age-depth distribution (ADD) $u(d,a)$ of particles. Here $d$ is depth (measured from the sediment surface), and $a$ is age. Depending on the interpretation of the outputs, $a$ can also refer to time.

The PartiMoDe model comes in three flavors which are explained in detail below:

* PartiMoDe: The base model, where components depend on depth and age/time (implemented in `PartiMoDe`).
* PartiMoDe StEn (stable environment): Model components depend on depth, but not on age/time (implemented in `PartiMoDe_StEn`).
* PartiMoDe LoFi (location fixed): Model components depend on depth, but not on age. Input location of particles is fixed, but influx of particles varies with time/age (implemented in `PartiMoDe_LoFi`).

It comes with two helper functions:

* `StratProfile`: Turns ADD into a stratigraphic profile of particle densities. For an example, see `examples/Example_PartiMoDe.m`.
* `PartiMoDe_Interpol`: Interpolate values of ADDs. For an example, see `examples/Example_PartiMoDe_Interpol.m`.

## PartiMoDe model

This model describes the distribution of particle ages and depths as a function of

* age and depth dependent mixing, burial, and disintegration
* location of particles of age 0 (input location)
* influx and outflux of particles through the sediment surface.

In this model, age $a$ can also be interpreted as time (mutatis mutandis).

The system is specified by the partial differential equation (PDE)

$$
\frac{\partial}{\partial a} u(d,a) =  \frac{ \partial }{ \partial d} \left( M(d,a)  \frac{\partial}{\partial d} u(d,a) - S(d,a)  u(d,a) \right) - \lambda(d,a) u(d,a)
$$

with boundary condtions

$$
u(d,0) = f_0(d)
$$

(initial conditions), flux through the sediment surface $f_{inflow}(a) - f_{outflow}(a)$. The bottom boundary condition is that there is no diffusive flux.

The meaning of the model components are:

* $M(d, a)$ depth and age dependent mixing coefficient
* $S(d,a)$ depth and age dependent sedimentation/burial rate
* $\lambda(d,a)$ depth and age dependent disintegration rate
* $f_0(d)$ location where particles of age 0 are placed into the sediment
* $f_{inflow}(a)$ age dependent flow of particles into the system through the sediment surface
* $f_{outflow}(a)$ age dependent flow of particles out of the system through the sediment surface

The boundary condition at the bottom is no diffusive flus. For this to, $M$, $S$ and $\lambda$ need to drop to 0 at the bottom of the observed system.

For an example, see `examples/Example_PartiMoDe.m`.

## PartiMoDe StEn model

This model is a simplification of the general PartiMoDE model, but all coefficient functions are NOT depending on age/time.

For an example, see `examples/Example_StEn.m`.

## PartiMoDe LoFi model

In this modification of the PartiMoDe StEn model, particle input is fixed to one location, but can vary with age/time as specified by a function $f$. In contrast to PartiMoDe StEn, no influx of particles through the sediment surface is not possible.

For an example, see `examples/Example_LoFi.m`.

## Derivation

Here we derive the PartiMoDe model, the special cases follow identically.

We start by modeling how the position of particles $x$ below sediment surface changes with time $t$ using the PDE

$$
\frac{\partial}{\partial t} u(d,t) =  \frac{\partial}{\partial d} \left( M(d,t) \frac{\partial}{\partial d} u(d,t) - S(d,t)  u(d,t) \right) - \lambda(d,t)  u(d,t)
$$

Here $M$, $S$, and $\lambda$ are time and depth dependent coefficient functions that specify the particle behaviour. $M$ specifies mixing, $S$ burial velocity/advection, and $\lambda$ the disintegration. The boundary conditions of this system specify initial particle location, flux through the sediment surface, and export into historical layers where particles are fixed.

We expand the state space by $a$ to track particle ages, and add an advection term to formalize that per time increment, particles one age increment. This leads to the equation

$$
\frac{\partial }{ \partial t} u(d,t,a) =  \frac{\partial }{\partial d} \left( M(d,t,a)  \frac{\partial }{\partial d} u(d,t,a) - S(d,t, a)  u(d,t,a) \right)  - \lambda(d,t, a)  u(d,t,a)- \frac{\partial }{\partial a} u(d,t,a)
$$

In this model, particle behavior depends both on external controls (e.g., events occurring at a specific time), their age (e.g., age-dependent disintegration) and their burial depth.

Assuming conditions do not vary in time, we get the steady-state equation

$$
\frac{\partial}{\partial a} u(d,a) =  \frac{ \partial }{ \partial d} \left( M(d,a)  \frac{\partial}{\partial d} u(d,a) - S(d,a)  u(d,a) \right) - \lambda(d,a) u(d,a)
$$

for the distribution of particle ages and depths in a stable environment, leading us to the PartiMoDE model.

Note that $a$ can be interpreted as both age and time. In the first case we get the age-depth distribution of particle ages in a temporally stable environment, in the latter is describes how the location of particles changes with time. Both are equally valid interpretations.
