function [RR, f] = autoSpectrum(xx,Fs,window,flat_start, flat_end,showFig)
%  This fucntion returns the auto-spectrum of input time series. 
%  Gramma: 
%  [RR, f] = autoSpectrum(ep01,1e6,1024, 0.1,1.1,1)
% 
%  xx         : Input time series; 
%  flat_start : Flat region start time, unit: sec; 
%  flat_end   : Flat region end time, unit: sec;
%  window     : Window width for FFT, better to be the pow of 2; 
%  overlap    : Overlap ratio between neighbour windows; 
%  Fs         : Sample ratio, unit: sps; 
%  showFig    : Flag of showing figure, only when set to be 1, the spectrum
%               will be shown; 
% 
%  RR         : AutoSpectrum of x; 
%  f          : Frequency series; 
%
% Example: 
% [RR,f]=autoSpectrum(tip01, 3, 4.5,1);
% flat_start=1/1e6;
% flat_end=length(xx)/1e6;

% window=124;
overlap=0.5;
% Fs=1e6;
x  = xx(flat_start * Fs+1:flat_end * Fs) ;  

NFFT       = 2^nextpow2(window);
f          = Fs/2*linspace(0,1,NFFT/2+1);
R          = zeros(NFFT,1);

N_window   = 0;
i = 1;
while i <= length(x)-window +1
%     Y = fft(x(i:i+window-1),NFFT)/window;                        %原始数据
    Y = fft(x(i:i+window-1)-mean(x(i:i+window-1)),NFFT)/window;  %湍流分量
    R = R + Y .* conj(Y);
    N_window = N_window + 1; 
    i = i + floor((1 - overlap) * window);
end
RR = 2 * abs(R(1:NFFT/2+1))/N_window; 

if showFig == 1
    figure('Color',[1 1 1]);
    loglog(f/1000, RR,'k', 'linewidth',2.5);
%     loglog(f/1000, RR,'k', 'linewidth',2.5);
%     xlim([1 100]);
    title(inputname(1))
    ylabel('{\it power Spectrum} (a.u.)','fontsize',15, 'fontname', 'Times New Roman', 'fontweight','bold');
    xlabel('{\it f} (kHz)','fontsize',15, 'fontname', 'Times New Roman', 'fontweight','bold');
    set(gca, 'fontsize',15, 'fontname', 'Times New Roman', 'fontweight','bold');
%     axis([f(2)/2000,f(NFFT/2+1)/500,min(RR(2:NFFT/2+1))/2,max(RR)*2]);
    set(gca, 'FontWeight', 'bold', 'FontSize', 15, 'LineWidth', 3, 'XMinorTick', 'on', 'YMinorTick', 'on')
%     grid on;
end