function xcoords = liney(n, hfig, linecolor, linestyle)

error(nargchk(0,4,nargin));   % check input arguments

if nargin<2, hfig = gcf;   xrange=get(gca,'XLim');end  % default = gcf
if nargin<1, n = 1; end   % default = 1

if ~ishandle(hfig)
    error('first input argument should be figure handle!');
end

% linecolor
if nargin <3, linecolor = 'r'; end

% linestyle
if nargin<4, linestyle = '--'; end

% linewidth
linewidth = 1;

x1=min(xrange);
x2=max(xrange);


    figure(hfig); % focus on fig
    ii = 1;
    while ii <= n
        [~, y(ii), button] = ginput(1);
      
        if button==27   % if button  = Escape button, then break
            ii = ii + 1;
            break;
        end
               
        if button==3   % if button = right button, then redraw
            if ii > 1
                ii = ii - 1;
                for jj=1:length(allaxes)
                    delete(hlineall(jj,ii));
                end
            end
           continue
        end
        
        XX = [x1 x2];
        YY = [y(ii)  y(ii)];
        liney(1,ii)=line(XX, YY, 'linestyle', linestyle, 'color',linecolor, 'linewidth', linewidth, 'handlevisibility','off','tag','liney');

        ii = ii + 1;
    end        


