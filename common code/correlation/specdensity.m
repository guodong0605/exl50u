function [K,F,Sxy,CSxy,Pxx,Pyy]=specdensity(x,y,nfft,N,deltaD,Fs,overlay)
%Calculates Power Spectral Density of x,y
%Syntax:
% [K,F,Sxy, CSxy, Pxx,Pyy]=specdensity(x,y,nfft,N,deltaD,Fs,overlay)
% the phase is angle(y.conj(x))
%
%In:
% x,y are time series
% nfft is the window length, should be 2^n
% 2*N+1 is the number of k-spectrum grid
% deltaD is the distance of the two point x, y
% Fs is the sample rate
%
%Out:
% K is the k-vector
% F is the f-vector
% Sxy is the power spectral density
% CSxy is the conditional spectral density. CSxy(k|f) = Sxy(k,f)./S(f)
% Pxx is the power of x
% Pyy is the power of y
%
% Note: we use a hanning window in fft as default

% Tao Lan
% $Revision: 1.7 $  $Date: 2014/04/20$
%           1.8) Add conditional s(k,f) output.
%           1.7) Use pcolor_all to plot 2d figure
%           1.6) Add Pxx and Pyy output, embed the inline detrend method for
%                the requirement of speed instead of detrend function;
%           1.5) Fixed the weight to (tempX.*conj(tempX)+tempY.*conj(tempY))/2
%           1.4) Fixed the length of frequency vector from nfft/2 to nfft/2+1
%           1.3) Fixed the max letters in one line, 75;
%                Using function detrend to remove the mean value of data.
%           1.2) Correct the Phase differ, which is the same as function ...
%               csd etc. : Y.*conj(X)


if nargin < 7
    overlay = nfft/2;
end

deltak=2*pi/(deltaD*(2*N+1));

x=x(:);          % Make sure x is a column vector
y=y(:);          % Make sure y is a column vector

win = hanning(nfft);    % nfft Hanning window
win = win(:);
k = floor((length(x)-overlay)/(nfft-overlay));  % number of window

KMU = k*norm(win)^2;	% Normalizing scale factor ==> asymptotically unbiased
% KMU = k*sum(win)^2;% alt. Nrmlzng scale factor ==> peaks are about right

dflag = 'linear';    % detrend by linear method

index = 1:nfft;
Weight = zeros(nfft/2+1, k);
k_wavenumber = zeros(nfft/2+1,k);
findex = 1: (nfft/2+1);

Pxx = zeros(nfft/2+1,1);
Pyy = zeros(nfft/2+1,1);

linear_factors = ones(nfft,2, class(x));
linear_factors(1:nfft,1) = (1:nfft)'/nfft;

for i=1:k
    %     x((i-1)*nfft+1:i*nfft)=x((i-1)*nfft+1:i*nfft) ...
    %         -mean(x((i-1)*nfft+1:i*nfft));
    %     y((i-1)*nfft+1:i*nfft)=y((i-1)*nfft+1:i*nfft) ...
    %         -mean(y((i-1)*nfft+1:i*nfft));
    %xw = win.*detrend(x(index),dflag);
    %yw = win.*detrend(y(index),dflag);
    switch lower(dflag)
        case {'linear','l', 1}
            xw = win.*(x(index)-linear_factors*(linear_factors\x(index)));
            yw = win.*(y(index)-linear_factors*(linear_factors\y(index)));
        case {'constant', 'mean', 'c', 0}
            xw = win.*(x(index)-meam(x(index)));
            yw = win.*(y(index)-meam(y(index)));
        otherwise
            % do nothing
            xw = win.*x(index);
            yw = win.*y(index);
    end
    %     k_wavenumber(:,i)=angle(fft(y((i-1)*nfft+1:i*nfft) ...
    %         .*win)./fft(x((i-1)*nfft+1:i*nfft).*win))/deltaD;
    %     Cxy(:,i)=fft(y((i-1)*nfft+1:i*nfft).*win) ...
    %         .*conj(fft(x((i-1)*nfft+1:i*nfft).*win));
    tempX = fft(xw);
    tempY = fft(yw);
    tempX = tempX(findex);
    tempY = tempY(findex);
    temp = tempY.*conj(tempX);
    k_wavenumber(:,i) = angle(temp)/deltaD;

    %     Cxy(:,i) = (tempX.*conj(tempX) + tempY.*conj(Y))/2;
    Weight(:,i)=(tempX.*conj(tempX)+tempY.*conj(tempY))/2;
    Pxx = Pxx + tempX.*conj(tempX);
    Pyy = Pyy + tempY.*conj(tempY);
    index = index + nfft - overlay;
end

S=zeros(nfft/2+1,2*N+1);
inc = -N* deltak + deltak/2;
%ones_inc = ones(size(k_wavenumber));
for i=1:2*N+1
    %    temp= (Indication(inc - k_wavenumber,deltak));
    %    S(:,i) =  sum(double(temp).*Weight,2);
    S(:,i) = sum(Weight.*double((Indication(inc - k_wavenumber,deltak))),2);
    inc = inc + deltak;
end
S=S/(KMU);          % expect value
Pxx = Pxx/(KMU);
Pyy = Pyy/(KMU);

% conditional s(k,f)
CS = zeros(size(S));
for i=1:nfft/2+1
    CS(i,:) = S(i,:)/sum(S(i,:));
end

% set up output parameters
if nargout > 0
    [K,F]=meshgrid((-N:N)*deltak,(0:nfft/2)*Fs/nfft);
    Sxy=S;
    CSxy=CS;
elseif nargout == 0   % do a plot
    newplot;
    [kk,ff]=meshgrid((-N:N)*deltak,(0:nfft/2)*Fs/nfft);
    pcolor_all(kk,ff,S);
    shading flat
    colorbar
    xlabel('k(wavenumber)'), ylabel('Frequency(Hz)');
    
    figure % conditional S(k|f)
    pcolor_all(kk,ff,CS)
    shading flat
    colorbar
    xlabel('k(wavenumber)'), ylabel('Frequency(Hz)');title('Conditional S(k,f)')
    
else
    error('Error output pars!');
end

function y=Indication(X,h)
% 指示函数 y=Ind(x,h)，如果0<= x <= h，那么y=1，其他y=0
y=(X>=0)&(X<=h);