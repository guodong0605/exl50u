function y = filter_lowp(x, f1, Fs)
    % Convert passband frequency from kHz to Hz
    f1 = f1 * 1e3;
    
    % Define the stopband frequency (slightly higher than f1, but within limits)
    f2 = min(f1 + 500, Fs/2 - 100); % Ensuring it's less than Nyquist frequency

    % Design a lowpass filter using an elliptic design
    d = fdesign.lowpass('Fp,Fst,Ap,Ast', f1, f2, 0.5, 60);
    Hd = design(d, 'ellip');
    Hd = design(d,"equiripple");
    freqz(Hd.Numerator,1)

    % Check if the filter is stable
    if ~isstable(Hd)
        error('The designed filter is unstable.');
    end

    % Apply the filter to the input signal
    y = filter(Hd, x);
end
