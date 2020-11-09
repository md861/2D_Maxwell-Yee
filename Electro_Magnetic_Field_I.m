%Function to calculate values of field for Electromagnetic waves using average of all
%possible derivatives. Here the E field is in the Z direction and the B
%field is in the X-Y plane.
function[Ez,Bx,By,pulse,iterations]=Electro_Magnetic_Field_I(length,nofe,c,totaltime,disturbance_time,disturbance_type,A,w,draw_disturbance,F_mask,Plot_or_not,boundary,rotate,az_user,el_user,pause_or_not)
        %create a 2D mesh
[x,y,X,Y,noe,dt]=create_mesh_2D(length,nofe,c);
        %calculate total number of iterations
iterations=totaltime/dt;
        %Create disturbance in Electric field at some random point at time
        %specified by the user
[xd,yd,Ezd,STATE_E,pulse]=disturbance(x,y,X,Y,iterations,noe,disturbance_time,A,w,draw_disturbance,nofe,disturbance_type);
        %define matrices to store the values of fields
Ez=zeros(noe,noe,iterations);
Bx=zeros(noe,noe,iterations);
By=zeros(noe,noe,iterations);
        %Calculate and update the fields due to disturbance and iterate for
        %all time instants
        Ez(xd,yd,1)=Ezd(xd,yd,1);
for n=2:iterations
        %Calculate the fields for current instant due to previous disturbance
            %Magnetic field
            for u=2:noe-1
                for v=2:noe-1
                    i=u;
                    j=v;
                    %Method I
                    Bx1=Bx(u,v,n-1)-((1/c)*(Ez(i,j+1,n-1)-Ez(i,j,n-1)));
                    By1=By(u,v,n-1)+((1/c)*(Ez(i+1,j,n-1)-Ez(i,j,n-1)));                    
                    %Method II
                    Bx2=Bx(u,v,n-1)-((1/c)*(Ez(i+1,j+1,n-1)-Ez(i+1,j,n-1)));
                    By2=By(u,v,n-1)+((1/c)*(Ez(i+1,j,n-1)-Ez(i,j,n-1)));                    
                    %Method III
                    Bx3=Bx(u,v,n-1)-((1/c)*(Ez(i+1,j+1,n-1)-Ez(i+1,j,n-1)));
                    By3=By(u,v,n-1)+((1/c)*(Ez(i+1,j+1,n-1)-Ez(i,j+1,n-1)));                    
                    %Method IV
                    Bx4=Bx(u,v,n-1)-((1/c)*(Ez(i,j+1,n-1)-Ez(i,j,n-1)));
                    By4=By(u,v,n-1)+((1/c)*(Ez(i+1,j+1,n-1)-Ez(i,j+1,n-1)));   
                    %AVERAGE
                    Bx(u,v,n)=(1/4)*(Bx1+Bx2+Bx3+Bx4);
                    By(u,v,n)=(1/4)*(By1+By2+By3+By4);
                end
            end
            %Electric field ----this uses the value of B field just
            %calculated above, i.e B(n)
            for u=2:noe-1
                for v=2:noe-1  
                    i=u-1;
                    j=v-1;
                    %Method I
                    Ez1=Ez(u,v,n-1)+((c)*((By(i+1,j,n)-By(i,j,n))-(Bx(i+1,j+1,n)-Bx(i+1,j,n))));
                    %Method II
                    Ez2=Ez(u,v,n-1)+((c)*((By(i+1,j,n)-By(i,j,n))-(Bx(i,j+1,n)-Bx(i,j,n))));
                    %Method III
                    Ez3=Ez(u,v,n-1)+((c)*((By(i+1,j+1,n)-By(i,j+1,n))-(Bx(i,j+1,n)-Bx(i,j,n))));
                    %Method IV
                    Ez4=Ez(u,v,n-1)+((c)*((By(i+1,j+1,n)-By(i,j+1,n))-(Bx(i+1,j+1,n)-Bx(i+1,j,n))));
                    %Average
                    Ez(u,v,n)=(1/4)*(Ez1+Ez2+Ez3+Ez4);
                end
            end
                %Update Field at Mask
                Ez(:,:,n)=(Ez(:,:,n)).*(F_mask);
            %Update new disturbance
            Ez(xd,yd,n)=Ezd(xd,yd,n);
            if(boundary==1)%Inverting phase
                %Set boundary conditions
                j=1;
                for i=1:noe
                    Bx(i,j,n)=0;
                    By(i,j,n)=0;
                    Ez(i,j,n)=0;
                end
                j=noe;
                for i=1:noe
                    Bx(i,j,n)=0;
                    By(i,j,n)=0;
                    Ez(i,j,n)=0;
                end
                i=1;
                for j=1:noe
                    Bx(i,j,n)=0;
                    By(i,j,n)=0;
                    Ez(i,j,n)=0;
                end
                i=noe;
                for j=1:noe
                    Bx(i,j,n)=0;
                    By(i,j,n)=0;
                    Ez(i,j,n)=0;
                end
            else            %Non inverting phase
                j=1;
                for i=1:noe
                    Bx(i,j,n)=Bx(i,j+1,n-1);
                    By(i,j,n)=Bx(i,j+1,n-1);
                    Ez(i,j,n)=Ez(i,j+1,n-1);
                end
                j=noe;
                for i=1:noe
                    Bx(i,j,n+1)=Bx(i,j-1,n);
                    By(i,j,n+1)=Bx(i,j-1,n);
                    Ez(i,j,n+1)=Ez(i,j-1,n);
                end
                i=1;
                for j=1:noe
                    Bx(i,j,n)=Bx(i+1,j,n-1);
                    By(i,j,n)=Bx(i+1,j,n-1);
                    Ez(i,j,n)=Ez(i+1,j,n-1);
                end
                i=noe;
                for j=1:noe
                    Bx(i,j,n+1)=Bx(i-1,j,n);
                    By(i,j,n+1)=Bx(i-1,j,n);
                    Ez(i,j,n+1)=Ez(i-1,j,n);
                end
            end
end
%pause;
STATE_B=[-length length -length length];
if(Plot_or_not==1)
    for n=1:iterations
        u=Bx(:,:,n);
        v=By(:,:,n);
        quiver(x,y,u,v);
        axis(STATE_B);
        xlabel('Bx');
        ylabel('By');
        drawnow;
        if(pause_or_not==1)
            pause;
        end
    end
    %pause;
    for n=1:iterations
        z=Ez(:,:,n);
        surf(x,y,z);
        set(gcf,'Renderer','zbuffer')
        view(10,37);
        axis tight;
        axis(STATE_E);
        xlabel('x');
        ylabel('y');
        zlabel('Ez');
        if (rotate==1)
            az=n/2;
            view(az,el_user);
            drawnow;
            if(pause_or_not==1)
                pause;
            end
        else
            drawnow;
            if(pause_or_not==1)
                pause;
            end
        end
    end
end
end