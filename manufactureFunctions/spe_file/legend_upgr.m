function legend_str=legend_upgr(time,unit)
   
    for i = 1:length(time)
        legend_str{i} = ['time','=' num2str(time(i)),unit];
        if max(time)>100
            legend_str{i} = ['R','=' num2str(time(i)),unit];    
        end
    end
    set(legend,'EdgeColor',[1 1 1]);
%     set(legend,'FontSize',10)
%     legend(legend_str)
% keyboard