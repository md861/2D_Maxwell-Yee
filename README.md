# 2D_Maxwell-Yee
An experimental Matlab package to solve Maxwell equations for TE mode on a 2D surface. The solver uses modified Yee algorithm, with Crank-Nicolson scheme. 
## Features
* Specify Dirichlet conditions using a mesh masking approach, where the user can store the points on the mesh that have (hard coded) Dirichlet conditions.
* Plotting and saving options for the time domain quiver and surface figures for magnetic and electric fields to avi video files. 

## Usage:
Look at the *Demo code.m* file for examples and usage.
 
## Example files:
Video files for an example 2D surface mask with homogeneous Dirichlet conditions and a sinusoidal point source are stored in the *Examples* folder. These files were generated with the *Demo code.m* script.
