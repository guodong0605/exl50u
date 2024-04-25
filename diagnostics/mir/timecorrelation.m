function [coherence, phaseDiff, crossPower, time] = timecorrelation(shotnum, t1, t2, chn1, chn2, Fs, windowSize, NFFT, overlap)
% CALCULATESPECTRALRELATIONSHIPS Calculates coherence, phase difference, and cross-power spectrum
% between two time series from shot number and channel information.
%
% Inputs:
%   shotnum - Shot number for data download.
%   t1, t2 - Start and end times for data download.
%   chn1, chn2 - Channel numbers for the two time series.
%   Fs - Sampling frequency, default 100 kHz.
%   windowSize - Size of each segment of x and y to window, default 1024.
%   NFFT - Number of FFT points, default 1024.
%   overlap - Fraction of overlap between segments, default 0.5.
%
% Outputs:
%   coherence - Coherence between the two time series.
%   phaseDiff - Phase difference between the two time series.
%   crossPower - Cross power spectrum of the two time series.
%   time - Time vector corresponding to the middle of each window.

% Handle default parameters
if nargin < 6 || isempty(Fs), Fs = 1e5; end
if nargin < 7 || isempty(windowSize), windowSize = 1024; end
if nargin < 8 || isempty(NFFT), NFFT = windowSize/2; end
if nargin < 9 || isempty(overlap), overlap = 0.5; end
phase_region = 50;
f_low=0;
f_high=Fs/2;
% Calculate actual number of overlap samples
overlap = round(overlap * NFFT);
% Data retrieval
datatime = [num2str(t1), ':', num2str(t2), ':', num2str(1/Fs)];
[x, t] = downloaddata(shotnum, chn1, datatime, 0, 0);
[y, ~] = downloaddata(shotnum, chn2, datatime, 0, 0);

% Define the window function
window = hamming(NFFT);
dx=1;
j=1;
while dx < length(x) - windowSize 
    % Calculate the Cross Power Spectrum
    warning off;
    [Pxy, f] = csd(x(dx:dx+windowSize-1), y(dx:dx+windowSize-1), NFFT, Fs, window, overlap, 'mean');
    % Calculate the Coherence
    [Cxy, freq] = cohere(x(dx:dx+windowSize-1), y(dx:dx+windowSize-1), NFFT, Fs, window, overlap, 'mean');
    
    % Calculate the phase difference
    f_select = (f >= f_low &  f<= f_high);  % Frequency mask
    Pxy_select=Pxy(f_select);
    Cxy_select=sqrt(Cxy(f_select));
    
    phaseDiff(j) = mean(angle(Pxy_select));
    % Convert cross power spectrum to dB
    crossPower(j)  = mean(10 * log10(abs(Pxy_select)));
    coherence(j) = mean(Cxy_select); 
    time(j) = mean(t(dx:dx+windowSize/2));
    % Output the coherence
    dx=dx+windowSize-overlap;
    j=j+1;
end
% Visualization
waveform{1} = {time, crossPower, 'Cross-power (dB)'};  % dB
waveform{2} = {time , coherence, 'Coherency'};
waveform{3} = {time , phaseDiff / pi * 180, 'dtheta (degrees)'};
figure('Color', [1 1 1]);
stackplot(waveform, 'Coherence Analysis', 'Time (s)');

end
