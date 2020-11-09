%Function to give the time and cordinate of sinusoidal disturbance along with its
%magnitude.
function[xd,yd,Ezd,STATE,s]=sinusoidal_pulse(x,y,X,Y,iterations,noe,disturbance_time,A,w,draw_disturbance,nofe)
        %Define time to calculate sinusoidal function and calculate sine
        %values at different time instants
time=linspace(0,3,iterations);
s=A*sin(w*time);
        %Generate a random value of index for x and y where the disturbance will
        %start at time given by disturbance_time
xp=floor((1/6)*nofe);%randperm(noe-2);                 %
yp=1;%randperm(noe-2);
xd=1+xp(1);
yd=1+yp(1);
        %The time at which disturbance starts is given by the user
td=disturbance_time;
        %Define matrix to store disturbance values at all values of x and
        %time.
Ezd=zeros(noe,noe,iterations);
        %Generate disturbance only for those time instants which are
        %greater than and equal to time of start of disturbance, i.e,
        %disturbance_time
for ti=td:iterations     %ti is the index for time
    Ezd(xd,yd,ti)=s(ti);
end
STATE=[min(X) max(X) min(Y) max(Y) min(s) max(s)];
       %Plot the disturbance (optional)
if(draw_disturbance==1)    
    for n=1:iterations    
        z=Ezd(:,:,n);
        mesh(x,y,z);
        xlabel('x');
        ylabel('y');
        zlabel('Ezd');
        axis(STATE);
        view(10,37);
        drawnow;
    end
end
end