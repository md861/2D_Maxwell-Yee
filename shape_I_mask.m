%Function to create a mask
function[F_mask]=shape_I_mask(noe,nofe)
width_I=floor((1/3)*nofe);
b_height=noe-width_I;
width_II=floor((2/3)*nofe);
ts_height=floor((1/4)*nofe);
t_height=nofe;
%Define matrices to store the values of masked vector fields
F_mask=ones(noe,noe);
%Outer bounder
i=1;
for j=1:b_height
    F_mask(i,j)=0;
end
i=noe;
for j=1:b_height
    F_mask(i,j)=0;
end
j=1;
for i=1:noe
    F_mask(i,j)=0;
end
j=noe;
for i=1:noe
    F_mask(i,j)=0;
end
%top left triangle
incr_x=0;
for i=1:width_I
    incr_y=incr_x;
    for j=noe:-1:b_height+incr_y
        F_mask(i,j)=0;
    end
    incr_x=incr_x+1;
end
%top right triangle
incr_x=0;
for i=noe:-1:noe-width_I
    incr_y=incr_x;
    for j=noe:-1:b_height+incr_y
        F_mask(i,j)=0;
    end
    incr_x=incr_x+1;
end
%Inner boundary
i=width_I;
for j=1:b_height
    F_mask(i,j)=0;
end
j=b_height;
for i=width_I:width_I+width_II
    F_mask(i,j)=0;
end
i=width_I+width_II;
for j=b_height:-1:t_height
    F_mask(i,j)=0;
end
%inner triangle
incr_x=0;
m=(t_height-ts_height)/width_II;
for i=width_I+width_II:-1:width_I
    incr_y=floor(m*incr_x);
    for j=t_height:-1:t_height-incr_y
        F_mask(i,j)=0;
    end
    incr_x=incr_x+1;
end
end