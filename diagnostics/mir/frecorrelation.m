function [yc_out, yco_out, freq_out] = frecorrelation(shotnum, t1,t2,chn1,chn2,fs, nfft)
% XSD New encapsulation csd function
% SYNTAX
% [yc, yco, freq] = XSD(X, Y, NFFT, FS, FRANGE, TITLE, WRAPOPTION)
%
% INPUT PARAMETERS
%    X, Y: two 1D series
%    nfft: fft windows length, default: 1024
%    fs: sampling frequency (unit: kHz), default fs=1.
%    frange: frequency range (unit: kHz), default frange = [0 fs/2]
%    title: the title for this figure, default title = 'Cohere analysis'
%    wrapoption: if this option is not empty, then excecute unwrap routine on cross phase. By default, the cross phase is wraped.

% OUTPUT PARAMETERS
%    yc: complex value for the cross power between X and Y;
%    yco: the related coherence
%    freq: output frequency
if (nargin <6) || isempty(fs), fs = 1e5; end
if (nargin <7) || isempty(nfft), nfft = 1024; end
datatime = [num2str(t1), ':', num2str(t2), ':', num2str(1/fs)];
[x, ~] = downloaddata(shotnum, chn1, datatime, 0, 0);
[y, ~] = downloaddata(shotnum, chn2, datatime, 0, 0);



frange=[0,1/(fs/2)];
noverlap = floor(nfft/2);

[yc, ~] = csd(x, y, nfft, fs, hanning(nfft), noverlap, 'mean');
warning off
[yco, freq] = cohere(x, y, nfft, fs, hanning(nfft), noverlap, 'mean');
yco = sqrt(yco); % pay attention to this line

if nargout >=1       % if exist output varibles...
    yc_out   = yc;
    yco_out  = yco;
    freq_out = freq;
    return
end

waveform{1} = {freq/1e3, 10*log10(abs(yc)), 'Cross-power(dB)'};  % DB
waveform{2} = {freq/1e3, yco, 'Coherency'};
waveform{3} = {freq/1e3, (unwrap(angle(yc))/pi*180),'dtheta '};
figure('Color',[1 1 1]); stackplot(waveform,[num2str(t1),':',num2str(t2),'s'],'f (kHz)')
end
