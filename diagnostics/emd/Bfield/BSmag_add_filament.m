function [BSmag] = BSmag_add_filament(BSmag,Gamma,I,dGamma,direction)
%---------------------------------------------------
%  NAME:      BSmag_add_filament.m
%  WHAT:      Adds a filament to the BSmag analysis.
%  REQUIRED:  BSmag Toolbox 20150407
%  AUTHOR:    20150407, L. Queval (loic.queval@gmail.com)
%  COPYRIGHT: 2015, Loic Qu�val, BSD License (http://opensource.org/licenses/BSD-3-Clause).
%
%  USE:
%  [BSmag] = BSmag_add_filament(BSmag,Gamma,I,dGamma)
%
%  INPUTS:
%    BSmag      = BSmag data structure
%    Gamma      = Filament points coordinates (x,y,z), one point per line [m,m,m]
%    I          = Filament current (flows from first point towards last point) [A]
%    dGamma     = Filament max discretization step [m]
%
%  OUTPUTS:
%    BSmag      = Updated BSmag data structure
%      BSmag.Nfilament              = Number of filaments
%      BSmag.filament(*).*          = Filament structure
%      BSmag.filament(*).Gamma      = Filament points coordinates (x,y,z), one point per line [m,m,m]
%      BSmag.filament(*).I          = Filament current (flows from first point towards last point) [A]
%      BSmag.filament(*).dGamma     = Filament max discretization step [m]
%----------------------------------------------------

n = BSmag.Nfilament+1;
BSmag.filament(n).Gamma = Gamma;
BSmag.filament(n).I = I;
BSmag.filament(n).dGamma = dGamma;
BSmag.Nfilament = n;

%Plot P (where there is a current source)
plot3(Gamma(:,1),Gamma(:,2),Gamma(:,3),'.-r')
startIdx=25;
endIdx=100;
X=Gamma(:,1);
Y=Gamma(:,3);
if direction > 0 % ˳ʱ��
    quiver(X(startIdx), Y(startIdx), X(endIdx)-X(startIdx), Y(endIdx)-Y(startIdx), 'MaxHeadSize', 0.5, 'AutoScale', 'on', 'Color', 'r');
else % ��ʱ��
    quiver(X(endIdx), Y(endIdx), X(startIdx)-X(endIdx), Y(startIdx)-Y(endIdx), 'MaxHeadSize', 0.5, 'AutoScale', 'on', 'Color', 'r');
end



axis tight