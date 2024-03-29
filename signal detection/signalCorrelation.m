function signalCorrelation(shotnum,chns,Tstart,Tend,Fs,isShift)

Tstart_default=-1;
Tend_default=5;
Fs_default=1e-2;
isShift_default=0;
smoothnum=10;

if (nargin <3) || isempty(Tstart), Tstart = Tstart_default; end
if (nargin <4) || isempty(Tend), Tend = Tend_default; end
if (nargin <5) || isempty(Fs), Fs = Fs_default; end
if (nargin <6) || isempty(isShift), isShift = isShift_default; end
if (nargin <7) || isempty(figtype), figtype = figtype_default; end


if (nargin <3) || isempty(datatime), datatime = datatime_default; end
if (nargin <4) || isempty(showfig), showfig = showfig_default; end
if (nargin <5) || isempty(dshift), dshift = dshift_default; end


try
    CurrentChannel=extractMultipleStrings(chns);  % change the input string to channel names
catch
    CurrentChannel=chns;
end
[dataArray]=downloaddata(shotnum,chns)
end