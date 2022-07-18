function [xc] = crosspoint(x1,x2,x3,x4)

x1h = [x1,1];
x2h = [x2,1];
x3h = [x3,1];
x4h = [x4,1];

l1 = cross(x1h,x2h);
l2 = cross(x3h,x4h);
pp = cross(l1,l2);

xc = [pp(1)/pp(3),pp(2)/pp(3)];