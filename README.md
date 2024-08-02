# PartiMoDE
<!-- badges: start -->
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.13169644.svg)](https://doi.org/10.5281/zenodo.13169644)
 <!-- badges: end -->

Modeling **Parti**cle **Mo**vement and **De**struction in the sediment surface mixed layer.

## Purpose

Before particles such as fossil remains are fixed in the fossil record, they are mixed, moved, and destroyed in the surface mixed layer of the sediment. As a result, particles of the same age can be found at different depths (stratigraphic disorder), and at the same depth, particles of various ages can be found (time-averaging). The **PartiMoDe** model simulates the distribution of particle ages and depths as a function of mixing, sedimentation, destruction (taphonomy), and varying import/export fluxes.

## Software requirements

Matlab 2006a or later.  
The code was written in Matlab2022, the implementation calls the Matlab internal function [pdepe](https://nl.mathworks.com/help/matlab/ref/pdepe.html) and will thus not run in Octave.

## Authors

**Niklas Hohmann**  
Utrecht University  
email: n.h.hohmann [at] uu.nl  
Web page: [www.uu.nl/staff/NHohmann](https://www.uu.nl/staff/NHHohmann)  
ORCID: [0000-0003-1559-1838](https://orcid.org/0000-0003-1559-1838)

## Citation

To cite this repository, please use

* Niklas Hohmann. (2024). MindTheGap-ERC/PartiMoDe: PartiMoDe: Modeling particle movement and destruction in the sediment surface mixed layer (v1.0.0). Zenodo. https://doi.org/10.5281/zenodo.13169644

or see the *CITATION.cff* file at the root of the repostitory

## Copyright

Copyright 2023-2024 Netherlands eScience Center and Utrecht University

## License

Apache 2.0 License, see LICENSE file for license text.

## Repository structure

* code : directory with main model code
* docs : documentation and formalization
* examples : directory with examples and use cases
* LICENSE : Apache 2.0 License text
* README : Readme file

## Funding information

Funded by the European Union (ERC, MindTheGap, StG project no 101041077). Views and opinions expressed are however those of the author(s) only and do not necessarily reflect those of the European Union or the European Research Council. Neither the European Union nor the granting authority can be held responsible for them.
![European Union and European Research Council logos](https://erc.europa.eu/sites/default/files/2023-06/LOGO_ERC-FLAG_FP.png)
