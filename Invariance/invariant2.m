% image points of 16 objects
xx = cat(3, [0.000526535, 0.653307; 0.23326, 0.182039; 0.707545, 0.947836; 0.137512, 0.657524; 0.186419, 0.98902], [0.685513, 0.507295; 0.338342, 0.907856; 0.19567, 0.99983;  0.767736, 0.174762; 0.767932, 0.782546], [0.930829, 0.974338; 0.0175106, 0.475526; 0.0753418, 0.1637; 0.404117, 0.0190708; 0.504249, 0.478385], [0.325131, 0.218833; 0.449363, 0.10544; 0.482137, 0.0623862; 0.208537, 0.276662; 0.397151, 0.210765], [0.363713, 0.228906; 0.364849, 0.137464; 0.251359, 0.207403; 0.115247, 0.250161; 0.24421, 0.237264], [0.437637, 0.454369; 0.117138, 0.132524; 0.994695, 0.606629; 0.496398, 0.784299; 0.55228, 0.412196], [0.395121, 0.000222861; 0.178066, 0.115369; 0.436886, 0.18652; 0.389283, 0.0536248; 0.480338, 0.0599848], [0.262874, 0.0912452; 0.349902, 0.239163; 0.154613, 0.334025; 0.385878, 0.230582; 0.409722, 0.0908468], [0.251558, 0.250448; 0.329554, 0.131283; 0.326529, 0.206895; 0.404012, 0.0506811; 0.225558, 0.165637], [0.749249, 0.646641; 0.394578, 0.614714; 0.547431, 0.300185; 0.563154, 0.0126622; 0.614281, 0.277775], [0.45172, 0.297395; 0.385108, 0.524111; 0.0086294, 0.880282; 0.112863, 0.375846; 0.365744, 0.46794], [0.247503, 0.180779; 0.335029, 0.141197; 0.467397, 0.00319792; 0.275208, 0.0530689; 0.315029, 0.139621], [0.431502, 0.224283; 0.322014, 0.00820973; 0.15036, 0.0425646; 0.0985857, 0.198766; 0.317587, 0.178033],[0.704305, 0.264222; 0.354423, 0.535354; 0.633474, 0.509798; 0.132772, 0.701057; 0.38867, 0.253893], [0.181818, 0.346456; 0.831424, 0.602052; 0.93315, 0.0224093; 0.858849, 0.74844; 0.269858, 0.742421], [0.309545, 0.161916; 0.134169, 0.065615; 0.347914, 0.267666; 0.409181, 0.152356; 0.294165, 0.196793]);

% plot image points of 16 objects
for i=1:16
    subplot(4,4,i);
    plot([xx(:,1,i); xx(1,1,i)], [xx(:,2,i); xx(1,2,i)]); 
end;

% Add your program after this line

% 交点を求める
crossPoints = zeros(2, 2, 16, 'like', xx);
for i=1:16
    x1 = xx(1, :, i);
    x2 = xx(2, :, i);
    x3 = xx(3, :, i);
    x4 = xx(4, :, i);
    x5 = xx(5, :, i);
    xc_1 = crosspoint(x1, x3, x2, x5);
    xc_2 = crosspoint(x1, x4, x2, x5);
    crossPoints(:, :, i) = [xc_1; xc_2];
%     figure
%     hold on
%     plot([xx(:,1,i); xx(1,1,i)], [xx(:,2,i); xx(1,2,i)]);
%     plot([xc_1(1, 1) xc_2(1, 1)], [xc_1(1, 2) xc_2(1, 2)], '.r');
%     hold off
end

% 不変量を求める
invariantValues = zeros(16, 1, 'double');
for i=1:16
    x1 = xx(1, :, i);
    x2 = xx(2, :, i);
    x3 = xx(3, :, i);
    x4 = xx(4, :, i);
    x5 = xx(5, :, i);
    x6 = crossPoints(1, :, i); % x1-x3 cross x2-x5
    x7 = crossPoints(2, :, i); % x1-x4 cross x2-x5
    l26 = norm(x6-x2);
    l27 = norm(x7-x2);
    l56 = norm(x6-x5);
    l57 = norm(x7-x5);
    invariantValues(i) = (l57/l56) / (l27/l26);
end

% 一致評価
flagMatrix = zeros(16, 16, 'logical');
for i=1:16
    invariantValue_i = invariantValues(i);
    for j=i+1:16
        invariantValue_j = invariantValues(j);
        diff_ij = abs(invariantValue_i - invariantValue_j);
        threshold = (abs(invariantValue_i) + abs(invariantValue_j)) * 0.001;
        if diff_ij < threshold
            flagMatrix(i, j) = true;
            disp([i j])
        end
    end
end


