function [RR1,RR2,TT1,TT2] = compRT(FF)

[UU, DD, VV] = svd(FF);
ZZ = [0, 1, 0;-1, 0, 0;0, 0, 0];
WW = [0, -1, 0;1, 0, 0;0, 0, 1];
SS = UU*ZZ*UU';
RR1 = UU*WW*VV';
RR2 = UU*WW'*VV';
if det(RR1) < 0 RR1 = -RR1; end;
if det(RR2) < 0 RR2 = -RR2; end;
    
TT1 = [SS(3,2); SS(1,3); SS(2,1)];
TT2 = -TT1;
