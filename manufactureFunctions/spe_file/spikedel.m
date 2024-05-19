function [spe]= spikedel(spec)
diff_spec=(abs(diff(spec,3)));
[~,locs,w,~]=findpeaks(diff_spec,'minpeakheight',400,'minpeakwidth',...
                         2,'widthreference','halfheight');
%ç¡®å®šæ›¿æ¢èŒƒå›´
range=cell(1);
Range1=cell(1);
for i=1:length(locs)
    ind=locs(i)-ceil(w(i)):1:locs(i)+ceil(w(i));
    eval(['range{',num2str(i),'}=ind;'])
end
z=1;
loc=[];
for j=1:length(locs)
    if j==length(locs)
        continue
    else
        for k=j+1:length(locs)
            eval(['aa=intersect(range{',num2str(j),'},range{',num2str(k),'});']);
            if isempty(aa)
                continue
            else
                eval(['comb=[range{',num2str(j),'} range{',num2str(k),'}];']);
                eval(['range{',num2str(j),'}=unique(comb);']);
                loc(z)=k;
                z=z+1;
            end
        end
    end
end
if ~isempty(loc)
    for l=1:length(loc)
        eval(['range{',num2str(loc(l)),'}=[];'])
    end
end
z=1;
for i=1:length(range)
    a=range{i};
    if ~isempty(a)
       eval(['Range1{',num2str(z),'}=a;']) 
       z=z+1;
    end
end
% æ›¿æ¢æ’å??,çº¿æ?§å·®å€¼ã?‚ã?‚ã??
spe=spec;
if ~isempty(locs)
for i=1:length(Range1)
    aa=Range1{i}+2;
    if min(aa)<1
        aa(aa<1)=[];
    elseif max(aa)>1024
        aa(aa>1024)=[];
    end
    spe(aa)=linspace(spe(aa(1)),spe(aa(end)),length(aa));
end
end
% figure(2);plot(1:1024,spe,'o',1:1024,spec,'-')
% pause(3)
% keyboard
