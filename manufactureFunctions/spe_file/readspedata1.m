function readspedata1()
close all;clear all;clc;
shot=20418;
[data, header] = readSPE([cd,'\rawdata\'], ['shot- ',num2str(shot),'.spe']);
[ax,bx,cx]=size(data);
spedata(1:ax,1:bx,1:cx)=0;
for i=1:cx
    spedata(:,:,i)=data(:,:,i)';
    z(:,:,i) = remove_spikes(spedata(:,:,i),1.3);
end
spedatatem=spedata;
spedata=spedatatem;
spedata=z;
[ax,bx,cx]=size(spedata);
sp = loadSPE([cd,'\rawdata\','data  ',num2str(shot),'.spe']);
spe=sp.int;
% keyboard
clear data
frame=8;
fra=16;%7:9;
pix=653;%557:574;%690:705;
sumspe1=sum(spedata(:,:,fra),3);
figure(2)
plot(sum(sumspe1(:,pix),2));hold on;
% keyboard
 figure(11);
% subplot(2,1,1)
image(spe(:,:,12),'CDataMapping','scaled');hold on;
colormap(lines);
figure(1);
% subplot(2,1,1)
image(sumspe1','CDataMapping','scaled');hold on;
colormap(lines);
% subplot(2,1,2)
% image(z','CDataMapping','scaled');hold on;
% colormap(lines);
% figure(2)
% plot(z(:,pix),'--')
% Diam=250;%%fiber diameter um
% pixsize=11;%%um,pixel size um
% pixnum=floor(Diam/pixsize);
% cent=700;
% i=2;
% fibercent(1)=cent;fiber=cent-1;
% while fiber<cent&&fiber>pixnum
%     fibercent(i)= fibercent(i-1)-pixnum;
%     fiber=fibercent(i);
%     i=i+1;
% end
% i=2;
% fibercentL(1)=cent;fiber=cent+1;
% while fiber>cent&&fiber<1140
%     fibercentL(i)= fibercentL(i-1)+pixnum;
%     fiber=fibercentL(i);
%     i=i+1;
% end
% bs=[fibercent fibercentL];
% bs=unique(bs);
% 

bs=[1 16 39 60 82 103 125 147 168 190 217 235 256 278 300 322 343 365 387 409 431 453 475 496 ...
    518 540 562 583 605 627 650 671 694 715 736 758 781 802 824 846 868 890 911 933 955 977 ...
    999 1021 1042 1063 1086 1108 1130];
be=[12 32 56 77 99 120 142 163 185 207 230 251 273 295 317 339 360 382 404 426 448 470 492 ...
    513 535 557 579 601 623 645 667 688 709 731 754 776 798 819 841 863 886 907 929 951 973 995 ...
    1016 1038 1061 1082 1103 1125 1147];
for i=1:length(bs)
    figure(1);plot([1 1200],[(bs(i)+be(i))/2 (bs(i)+be(i))/2],'--','LineWidth',1);hold on;
end
for i=1:length(bs)
    for j=1:cx
        spe(:,i,j)=sum(spedata(:,bs(i):be(i),j),2);
    end
end
frame=6:13;
channel=26;
delpixel=590:620;
base=2300;
for i=1:length(bs)
    for j=1:cx
        sumspe(i,j)=sum(spe(delpixel,i,j));
    end
end
sumspe(23,:)=(sumspe(22,:)+sumspe(24,:))/2;
sumspe(25,:)=(sumspe(24,:)+sumspe(26,:))/2;
for fr=1:length(frame)
    figure(3);
    plot(1:ax,spe(:,channel,frame(fr)));hold on;
end
% % xlim([delpixel(1) delpixel(end)])
figure(4);
plot(1:ax,(spe(:,20:32,8)-base)./(max(spe(:,20:32,8)-base)));hold on;
% xlim([delpixel(1) delpixel(end)])
R=[1:20 53:-1:21];
[xtemp,index]=sort(R);
R=R(index);
sumspe=sumspe(index,:);
sumspe(21:53,:)=sumspe(21:53,:).*sumspe(20,:)./sumspe(21,:);
keyboard  




