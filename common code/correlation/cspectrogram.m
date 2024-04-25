function [t_out, f_out, cpower_out] = cspectrogram(x, y, fs,nfft, overlap)
% CSPECTROGRAM Cspectrogram using csd to get time evolution of cross-power
% SYNTAX
% [T, F, CPOWER] = CSPECTROGRAM(X, Y, NFFT, OVERLAP, FS, FRANGE, NENSEMBLE, ITITLE)
%
% INPUT PARAMETERS
%   x, y:     two 1D series
%  nfft:     fft windows legnth, default: 1024
%   overlap:  overlap of the windows, default: 0
%  fs:       sampling frequency (unit: kHz), default: 2000
%   frange:   frequency range of the output (unit: kHz), default: [0 fs/2]
%   nensemble: ensemble number, default: 4
%   ititle:   the title of this figure, default: 'Cross-power time evolution(a.u.)'
%
%
% OUTPUT PARAMETERS
% t: output time (start from 0)
% f: output frequency
%  cpower: cross power in time and frequency
%
% DESCRIPTION
% This is a function for time evolution of cross-power using csd.
%
% Examples:
% >> [t, f, cpower] = cspectrogram(x1, x2, 1024, 0, 2e3, [10 1000], 10);
% also:
% >> cspectrogram(x1, x2, 1024, 0, 2e3, [10 1000], 10);
%
% See also:
% csd, xsd, spectrogram

fs_default = 1e5;  % default sampling rate
nfft_default = 1024; % default nfft
nensemble = 4; % default ensemble number
frange=[0,fs_default/2];
iTitle = 'Cross-power time evolution(a.u.)'; % default title

narginchk(2, 5);

if (nargin <3) || isempty(fs), fs = fs_default; end
if (nargin <4) || isempty(nfft), nfft = nfft_default; end
if (nargin <5) || isempty(overlap), overlap = 0.5*nfft; end


[~, f] = csd(x, y, nfft, fs);

findex = (f<=frange(2) & f>=frange(1));

% initialize cpower and t at first
ncsd = (nensemble-1)*(nfft-overlap)+nfft;
tlen = floor((length(x)-ncsd)/(nfft-overlap)) + 1;
cpower = zeros(sum(findex), tlen);
t = zeros(tlen,1);
tindex = 1:ncsd;
for it=1:tlen
    yc = csd(x(tindex), y(tindex), nfft, fs, hanning(nfft), overlap, 'mean');
    cpower(:,it) = yc(findex);
    t(it) = mean(tindex-1)/fs;
    tindex = tindex + (nfft-overlap);
end

f = f(findex);

if nargout >= 1
    t_out = t;
    f_out = f;
    cpower_out = cpower;
    return
end

cp1 = 10*log10(abs(cpower));

figure('Color',[1 1 1]);
set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
pcolor(t,f/1e3,cp1);
shading interp;
xlabel('Time(ms)');
ylabel('Frequency(kHz)');
title(iTitle);

% improve colormap
nbins =100;
[no,xo] = hist(cp1(:), nbins);
cthreshold = 25;
xo1 = xo(no>max(no)/cthreshold); 
clim([min(xo1) max(xo1)]);
colormap('jet')
colorbar;
set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 2, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')


end