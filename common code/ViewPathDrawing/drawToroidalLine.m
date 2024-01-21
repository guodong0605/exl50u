function [toroidalLine_handle,tx_handle,toroidalPoints]=drawToroidalLine(x,angle,theta1,theta2,linenum)
toroidalPoints=horizontalViewlines(x,angle,theta1,theta2,linenum);
for i=1:size(toroidalPoints,1)
    hold on;
    toroidalLine_handle{i}=plot([x*cosd(angle)/1e3,toroidalPoints(i,1)],[x*sind(angle)/1e3,toroidalPoints(i,2)],'--ro','MarkerSize',8,'MarkerEdgeColor','g','MarkerFaceColor','g');
end
tx_handle=text(x*cosd(angle)/1e3+0.04,x*sind(angle)/1e3,['(',num2str(round(theta1,1)),'$^\circ$',' ',num2str(round(theta2,1)),'$^\circ$',')']);
set(tx_handle,'interpreter','Latex','FontSize',14,'Color','b','FontWeight','bold')
xlim([-2.5,2.5]);
ylim([-2.5,2.5]);
end