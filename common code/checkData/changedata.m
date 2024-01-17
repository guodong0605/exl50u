function changedata(str,num)
line= findobj(gco);
% 
% if class(line)~= 'matlab.graphics.chart.primitive.Line'
%     line=line.Line;
% end
x=line.XData;
y=line.YData;
if nargin<2
    str=['y2=',str,';'];
    eval(str);    
else
    y2=smooth(y,num);
end
my_style=line.LineStyle;
my_linewidth=line.LineWidth;
my_color=line.Color;
delete(line)
hold on;plot(x,y2,'Linewidth',my_linewidth,'Color',my_color,'LineStyle',my_style)
end