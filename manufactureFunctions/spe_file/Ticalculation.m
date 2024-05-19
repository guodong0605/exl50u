function Ticalculation()
amu=11;
x0=282;
FWHM=0.07;%%nm
% Inst=0.038;
Inst=0;
FWHM=sqrt(FWHM^2-Inst^2);
lambda_Doppler=FWHM/sqrt(4*log(2));
[TikeV] = Doppler2TikeV(lambda_Doppler,amu,x0);
TieV=TikeV*1000
keyboard




