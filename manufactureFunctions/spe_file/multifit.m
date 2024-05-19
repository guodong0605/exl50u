function F= multifit(beta)
%
global CIII
global Range

y=0;
for i=1:floor(length(beta)/3)
temp=beta(i*3-2)*exp(-(Range-beta(i*3-1)).^2/beta(i*3)^2);
y=y+temp;
end
y=y+beta(end);
F     = CIII-y;%-beta(end-1)*Range-beta(end);