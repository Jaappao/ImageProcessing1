% Make 3D object
close all;
N1 = 40; XX1 = []; 
for i=1:N1, XX1 = [XX1; [-5, -5+10*i/N1, -5]]; end
for i=1:N1, XX1 = [XX1; [ 5, -5+10*i/N1, -5]]; end
for i=1:N1, XX1 = [XX1; [-5, -5+10*i/N1,  5]]; end
for i=1:N1, XX1 = [XX1; [ 5, -5+10*i/N1,  5]]; end
for i=1:N1, XX1 = [XX1; [-5+10*i/N1/2, 5+10*i/N1/2, -5]]; end
for i=1:N1, XX1 = [XX1; [ 5-10*i/N1/2, 5+10*i/N1/2, -5]]; end
for i=1:N1, XX1 = [XX1; [-5+10*i/N1/2, 5+10*i/N1/2,  5]]; end
for i=1:N1, XX1 = [XX1; [ 5-10*i/N1/2, 5+10*i/N1/2,  5]]; end
for i=1:N1, XX1 = [XX1; [-5+10*i/N1, -5, -5]]; end
for i=1:N1, XX1 = [XX1; [-5+10*i/N1, -5,  5]]; end
for i=1:N1, XX1 = [XX1; [-5, -5, -5+10*i/N1]]; end
for i=1:N1, XX1 = [XX1; [ 5, -5, -5+10*i/N1]]; end
for i=1:N1, XX1 = [XX1; [-5,  5, -5+10*i/N1]]; end
for i=1:N1, XX1 = [XX1; [ 5,  5, -5+10*i/N1]]; end
for i=1:N1, XX1 = [XX1; [ 0, 10, -5+10*i/N1]]; end
XX1=XX1'; % 転地
[m,n]=size(XX1); % nは数
XX1h = [XX1;ones(1,n)]; % 同次座標に

thx = -15*pi/180; thy = 30*pi/180; thz = -5*pi/180;
RX = [1,0,0;0,cos(thx),-sin(thx);0,sin(thx),cos(thx)];
RY=[cos(thy),0,sin(thy);0,1,0;-sin(thy),0,cos(thy)];
RZ=[cos(thz),-sin(thz),0;sin(thz),cos(thz),0;0,0,1];
R=RX*RY*RZ; 
Tz = 500; % 物体とカメラとの距離
T = [0;0;Tz]; 
M=[[R,T];0,0,0,1]; % 回転と並進を示す行列
XXh = M*XX1h;
XX = [XXh(1,:);XXh(2,:);XXh(3,:)];

% Plot 3D object
% figure;
% plot3(XX(1,:), XX(2,:), XX(3,:),'.');
% view(20, 70);

Pp = [1 0 0 0; 0 1 0 0; 0 0 1 0];
xx1 = Pp*XXh;
plot(xx1(1,:) ./ xx1(3, :), xx1(2, :) ./ xx1(3, :), 'b.');

Pa = [1/Tz 0 0 0; 0 1/Tz 0 0; 0 0 0 1];
xx2 = Pa*XXh;
hold on;
plot(xx2(1,:) ./ xx2(3, :), xx2(2, :) ./ xx2(3, :), 'r.');
hold off;
