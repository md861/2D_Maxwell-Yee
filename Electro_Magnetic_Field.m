%Function to calculate values of field for Electromagnetic waves using average of all
%possible derivatives. Here the E field is in the Z direction and the B
%field is in the X-Y plane.
function[Ez,Bx,By,pulse,iterations]=Electro_Magnetic_Field(length,nofe,c,totaltime,disturbance_time,disturbance_type,A,w,draw_disturbance,Plot_or_not,boundary,rotate,az_user,el_user,pause_or_not)
[x,y,X,Y,noe,dt]=create_mesh_2D(length,nofe,c);
[F_mask]=shape_I_mask(noe,nofe);
[EzI,BxI,ByI,pulse,iterations]=Electro_Magnetic_Field_I(length,nofe,c,totaltime,disturbance_time,disturbance_type,A,w,draw_disturbance,F_mask,0,boundary,rotate,az_user,el_user,pause_or_not);
[EzII,BxII,ByII]=Electro_Magnetic_Field_II(length,nofe,c,totaltime,disturbance_time,disturbance_type,A,w,0,F_mask,0,boundary,rotate,az_user,el_user,pause_or_not);
[EzIII,BxIII,ByIII]=Electro_Magnetic_Field_III(length,nofe,c,totaltime,disturbance_time,disturbance_type,A,w,0,F_mask,0,boundary,rotate,az_user,el_user,pause_or_not);
[EzIV,BxIV,ByIV]=Electro_Magnetic_Field_IV(length,nofe,c,totaltime,disturbance_time,disturbance_type,A,w,0,F_mask,0,boundary,rotate,az_user,el_user,pause_or_not);
Ez=(1/4)*(EzI+EzII+EzIII+EzIV);
Bx=(1/4)*(BxI+BxII+BxIII+BxIV);
By=(1/4)*(ByI+ByII+ByIII+ByIV);
pause;
%Plots 
vB = VideoWriter('BField.avi');
vE = VideoWriter('EField.avi');
open(vB);
open(vE);
STATE_B=[-length length -length length];
STATE_E=[-length length -length length -A A];
if(Plot_or_not==1)
    for n=1:iterations
        u=Bx(:,:,n);
        v=By(:,:,n);
        quiver(x,y,u,v);
        axis(STATE_B);
        xlabel('Bx');
        ylabel('By');
        title('2D Magnetic fields');
        frameB = getframe(gcf);
        writeVideo(vB,frameB);
        drawnow;
        if(pause_or_not==1)
            pause;
        end
    end
    close(vB);
    pause;
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
        title('Ez Electric fields');        
        if (rotate==1)
            az=n/2;
            view(az,el_user);
            frameE = getframe(gcf);
            writeVideo(vE,frameE);
            drawnow;
            if(pause_or_not==1)
                pause;
            end
        else
            frameE = getframe(gcf);
            writeVideo(vE,frameE);
            drawnow;
            if(pause_or_not==1)
                pause;
            end
        end
    end
    close(vE);
end
        
end