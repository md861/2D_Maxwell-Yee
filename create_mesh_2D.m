%Function to create a 2D mesh
function [x,y,X,Y,noe,dt]=create_mesh_2D(length,nofe,c)
nofe=nofe+1;            %To create extra points for boundary conditions
dx=length/nofe;
dt=dx/c;
X=-length:dx:length;
Y=X;
noe=size(X);
noe=noe(2);
[y,x]=meshgrid(X,Y);
end