function legend_str=legend_upgrs(time,unit,name)
   
    for i = 1:length(time)
        legend_str{i} = [name,'=' num2str(roundn(time(i),-2)),unit];
    end
    set(legend,'EdgeColor',[1 1 1]);
%     legend(legend_str)