function mypcolor(fig,xx,yy,zz)

figure(fig);p1=pcolor(xx,yy,zz);shading interp; colormap('Gray')
setlayer(p1,inf)
handletype = get(fig,'Type');
if strcmpi(handletype, 'figure')
    ax=fig.Children;
    if length(ax)>1
        ax=ax(2);
    end
else
    ax=fig;
end
alllayerstype = get(ax.Children,'Type'); 

surface_layer=find(strcmpi(alllayerstype,'surface'));
layer2delete=sort(surface_layer,'descend');
n=length(surface_layer);
if n>1
    for k=2:n
       temp=ax.Children(layer2delete(k));
       delete(temp);
    end
end

end