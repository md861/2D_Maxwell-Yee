%Function to give the time and cordinate of disturbance along with its
%magnitude.
function[xd,yd,Ezd,STATE,pulse]=disturbance(x,y,X,Y,iterations,noe,disturbance_time,A,w,draw_disturbance,nofe,disturbance_type)
if(disturbance_type==1)
    [xd,yd,Ezd,STATE,s]=sinusoidal_pulse(x,y,X,Y,iterations,noe,disturbance_time,A,w,draw_disturbance,nofe);
    pulse=s;
else
    [xd,yd,Ezd,STATE,g]=gaussian_pulse(x,y,X,Y,iterations,noe,disturbance_time,A,w,draw_disturbance,nofe);
    pulse=g;
end
end