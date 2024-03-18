function newimg=img_process(img)
img(img>10^4)=5*10^4;
if max(max(img))>1
    img=img/max(max(img));
end
img2=img./(1-img);
newimg=zeros(size(img2));
modifyA=padarray(img,[1 1]);
window_x=[1:3]';
window_y=[1:3]';
for i=1:size(modifyA,1)-2
    for j=1:size(modifyA,2)-2
        %VECTORIZED METHOD
        window=reshape(modifyA(i+window_x-1,j+window_y-1),[],1);
        %FIND THE MINIMUM VALUE IN THE SELECTED WINDOW
        newimg(i,j)=min(window);
    end
end
end