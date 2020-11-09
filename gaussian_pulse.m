%Function to give the time and cordinate of gaussian disturbance along with its
%magnitude.
function[xd,yd,Ezd,STATE,g]=gaussian_pulse(x,y,X,Y,iterations,noe,disturbance_time,A,w,draw_disturbance,nofe)
        %Define time to calculate gaussian function and calculate its
        %values at different time instants
w=w*0.0001;
time=linspace(0,3,iterations);
elements=size(time);
elements=elements(2);
center=floor(elements/2);
%The time at which disturbance starts is given by the user
td=disturbance_time;
t2=(-1)*(time-time(center)).^2;
g=A*exp(t2/w);
flag=0;
for i=1:elements
    if(flag==0)
        if (g(i)~=0)
            t_start=i;
            flag=1;
        end
    end
end
pulse_width=2*(center-t_start);        
        %Generate a random value of index for x and y where the disturbance will
        %start at time given by disturbance_time
xp=floor((1/6)*nofe);%randperm(noe-2);                         %nofe+1;%
yp=1;%randperm(noe-2);
xd=1+xp(1);
yd=1+yp(1);
        %Define matrix to store disturbance values at all values of x and
        %time.
Ezd=zeros(noe,noe,iterations);
        %Generate disturbance only for those time instants which are
        %greater than and equal to time of start of disturbance, i.e,
        %disturbance_time
        t_index=0;
for ti=td:(td+pulse_width)    %ti is the index for time
    Ezd(xd,yd,ti)=g(t_start+t_index);
    t_index=t_index+1;
end
STATE=[min(X) max(X) min(Y) max(Y) -max(g(:)) max(g(:))];
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