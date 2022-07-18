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
% T = [0; 0; 0]; 

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


% カメラ行列を求める
Pc_1   = [1 0 0 0; 0 1 0 0; 0 0 1 0];
Pc_2_1 = [R1 T1];
Pc_2_2 = [R1 T2];
Pc_2_3 = [R2 T1];
Pc_2_4 = [R2 T2];

% 形状を復元する
XX1 = zeros(20, 3);
XX2 = zeros(20, 3);
XX3 = zeros(20, 3);
XX4 = zeros(20, 3);

for i=1:20
    % mの歪対称行列を求める
    m_1_skew = skew([xx1(i, :), 1]');
    m_2_skew = skew([xx2(i, :), 1]');
    
    % Qを求める
    Q_1 = m_1_skew * Pc_1;
    Q_2_1 = m_2_skew * Pc_2_1;
    Q_2_2 = m_2_skew * Pc_2_2;
    Q_2_3 = m_2_skew * Pc_2_3;
    Q_2_4 = m_2_skew * Pc_2_4;

    % QとQdashをくみわせてMを作る
    M_1 = [Q_1; Q_2_1];
    M_2 = [Q_1; Q_2_2];
    M_3 = [Q_1; Q_2_3];
    M_4 = [Q_1; Q_2_4];
    
    % MtMを求める
    M_1tM_1 = M_1' * M_1;
    M_2tM_2 = M_2' * M_2;
    M_3tM_3 = M_3' * M_3;
    M_4tM_4 = M_4' * M_4;

    % MtMの固有ベクトルを求める
    [eigV_M_1, eigD_M_1] = eig(M_1tM_1);
    [eigV_M_2, eigD_M_2] = eig(M_2tM_2);
    [eigV_M_3, eigD_M_3] = eig(M_3tM_3);
    [eigV_M_4, eigD_M_4] = eig(M_4tM_4);

    % 最小固有値に対応する固有ベクトルを取り出して、同次座標をもとの座標に戻す
    XX1(i, 1:3) = eigV_M_1(1:3, 1)' / eigV_M_1(4, 1);
    XX2(i, 1:3) = eigV_M_2(1:3, 1)' / eigV_M_2(4, 1);
    XX3(i, 1:3) = eigV_M_3(1:3, 1)' / eigV_M_3(4, 1);
    XX4(i, 1:3) = eigV_M_4(1:3, 1)' / eigV_M_4(4, 1);
end

% 新規figureにプロット
figure;
ax4 = subplot(2,2,1); plot3(XX1(:,1),XX1(:,2),XX1(:,3)); hold on; 
plot3(XX1(:,1),XX1(:,2),XX1(:,3),'o'); hold off;
ax5 = subplot(2,2,2); plot3(XX2(:,1),XX2(:,2),XX2(:,3)); hold on; 
plot3(XX2(:,1),XX2(:,2),XX2(:,3),'o'); hold off;
ax6 = subplot(2,2,3); plot3(XX3(:,1),XX3(:,2),XX3(:,3)); hold on; 
plot3(XX3(:,1),XX3(:,2),XX3(:,3),'o'); hold off;
ax7 = subplot(2,2,4); plot3(XX4(:,1),XX4(:,2),XX4(:,3)); hold on; 
plot3(XX4(:,1),XX4(:,2),XX4(:,3),'o'); hold off;

function y = skew(x)
    y = [0 -x(3) x(2); x(3) 0 -x(1); -x(2) x(1) 0];
end
