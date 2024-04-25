function [S,f,t] = aspectrogram(x,Fs,overlap,window,flat_start,flat_end,showFig)
% This fuction gives the time-frequncy coherence and cross-phase of x and y.
% Gramma: 
% [S,f,t] =autoSpectroscopy(ep01,1024,1e6,1,1.1,1); 
%  
% x       :Two input time series, which should have the same length and sample
%          ratio; 
% window  : The width of time window; 
% showFig : A plot flag; only when showFig is set to be 1, the program will
%           show the pcolor figure. 
%
% S       : Coherence between x and y; 
% f       : Frequency. It is determined by window and dividor, that is, the 
%           window width in crossSpectrum.m  
% t       : Time axis. 
%
% Example: 
% autoSpectroscopy(tip11,2048, 0, 0.5, 1);
% 
% Fs=1e6;
% window=1024*4;
% overlap=0.5;
x  = x(flat_start * Fs+1:flat_end * Fs-1) ;  

if overlap <0 && overlap >= 1
    error('The overlap ratio between neighbour windows should belong to [0,1). ');
end

N_window = 0;
for i = 1: floor(window* (1-overlap)): length(x) - window
    N_window = N_window + 1;
end

NFFT = 2^nextpow2(window);
f    = Fs/2*linspace(0,1,NFFT/2+1);
t    = flat_start *1e3+(window/2/Fs + (0:N_window-1)*window*(1-overlap)/Fs)*1000;  % Unit: ms
S    = zeros(NFFT/2 +1,N_window);

N_window = 0; 
for i = 1: floor(window* (1-overlap)): length(x) - window
    N_window = N_window + 1;
    Y = fft(x(i:i+window-1)-mean(x(i:i+window-1)),NFFT)/window;
    S(:,N_window) = abs(Y(1:NFFT/2+1).*conj(Y(1:NFFT/2+1))); 
end

if showFig == 1
    h=pcolor (t/1000,f/1000, log(S)); shading interp;
    setlayer(h,inf)
%     title(inputname(1),'fontsize',14)
    xlabel('$\rm t(s)$',  'fontname','Times New Roman','fontsize',12, 'fontweight','bold','interpreter','LaTex');
    ylabel('$\rm f(kHz)$', 'fontname','Times New Roman','fontsize',12, 'fontweight','bold','Interpreter','LaTex');
    set(gca, 'FontWeight', 'normal', 'FontSize', 15, 'LineWidth', 3, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on')
    colormap('JET');
    colorbar;
    autoClim
end