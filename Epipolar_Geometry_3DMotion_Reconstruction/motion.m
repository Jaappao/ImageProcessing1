% 3D object 
XX = [-5,-5,-5;-5,5,-5;0,10,-5;5,5,-5;5,-5,-5;-5,-5,-5;-5,-5,5;-5,5,5;0,10,5;5,5,5;5,-5,5;-5,-5,5;-5,5,5;-5,5,-5;0,10,-5;0,10,5;5,5,5;5,5,-5;5,-5,-5;5,-5,5];
for i=1:20, XX(i,:) = XX(i,:)+[0,0,30]; end; % 原点から移動

% camera parameters
thx = -5*pi/180; thy = -170*pi/180; thz = 170*pi/180;
Rx = [1, 0, 0;0, cos(thx), -sin(thx);0, sin(thx), cos(thx)];
Ry = [cos(thy), 0, sin(thy);0, 1, 0;-sin(thy), 0, cos(thy)];
Rz = [cos(thz), -sin(thz), 0;sin(thz), cos(thz), 0;0, 0, 1];
R = Rx*Ry*Rz; % 1に対する2の回転行列
T = [-2; -1; 6]; % 並進ベクトル


% camera matrix
Pf = [1,0,0,0;0,1,0,0;0,0,1,0]; % 第一カメラ
M = [R,T;[0,0,0,1]]; % 第二カメラ
PP1 = Pf; % 第一カメラ
PP2 = Pf*M;  % 第二カメラ(第一カメラに対して回転並進）

% projection
tmp = PP1*[XX';ones(1,20)];
xx1 = [tmp(1,:)./tmp(3,:);tmp(2,:)./tmp(3,:)]'; % 第一カメラ投影点
tmp = PP2*[XX';ones(1,20)];
xx2 = [tmp(1,:)./tmp(3,:);tmp(2,:)./tmp(3,:)]'; % 第二カメラ投影点

% plot3D points and images
ax1 = subplot(2,2,1); plot3(XX(:,1),XX(:,2),XX(:,3)); hold on; 
plot3(XX(:,1),XX(:,2),XX(:,3),'o'); hold off;
ax2 = subplot(2,2,3); plot(xx1(:,1),xx1(:,2),'r'); hold on;  
plot(xx1(:,1),xx1(:,2),'ro'); hold off; axis([-1,1,-1,1]);
ax3 = subplot(2,2,4); plot(xx2(:,1),xx2(:,2),'g'); hold on;  
plot(xx2(:,1),xx2(:,2),'go'); hold off; axis([-1,1,-1,1]);

% Add your program after this line
% M(Matrix)を求める
Matrix = zeros(20, 9);
for i=1:20
    tmp = [xx2(i,:),1]'  * [xx1(i,:), 1];
    Matrix(i, :) = [tmp(1, :), tmp(2, :), tmp(3, :)];
end

% 固有値固有ベクトルを求める
MtM = Matrix'*Matrix;
[V, D] = eig(MtM);

% 固有値最小に対応する固有ベクトルfとF行列
f = V(:, 1)';
F = [f(1:3); f(4:6); f(7:9)];

% 回転と並進を抽出
[R1, R2, T1, T2] = compRT(F);
% R2とRがほぼ符号しているのを確認(差を取ると浮動点小数の誤差は出る)
T_check = T ./ T(3);
T1_check = T1 ./ T1(3);
T2_check = T2 ./ T2(3);
% T1, T2両方ともTと方向が一致するのを確認

% エピポールとエピポーラ線を求める
% 左側の図
ax2 = subplot(2,2,3); plot(xx1(:,1),xx1(:,2),'r'); hold on;  
plot(xx1(:,1),xx1(:,2),'ro'); 
for i=1:20
    x = [xx2(i, :), 1]';
    l = F'*x;
    hold on
    set(ax2,'NextPlot','add');
    wline(l)
    hold off
end
hold off; axis([-1,1,-1,1]);

FtF = F'*F;
[VF, DF] = eig(FtF);
e1 = VF(:, 1)';
hold on
set(ax2,'NextPlot','add');
plot(ax2, e1(1)/e1(3), e1(2)/e1(3), Marker="*", Color="blue");
hold off

% 右側の図
ax3 = subplot(2,2,4); plot(xx2(:,1),xx2(:,2),'g'); hold on;  
plot(xx2(:,1),xx2(:,2),'go'); 
for i=1:20
    x = [xx1(i, :), 1]';
    l = F*x;
    hold on
    set(ax3,'NextPlot','add');
    wline(l)
    hold off
end
hold off; axis([-1,1,-1,1]);

FFt = F*F';
[VFt, DFt] = eig(FFt);
e2 = VFt(:, 1)';
hold on
set(ax3,'NextPlot','add');
plot(ax3, e2(1)/e2(3), e2(2)/e2(3), Marker="*", Color="blue");
hold off
% 両図とも全ての直線がエピポールを通っていることを確認した
