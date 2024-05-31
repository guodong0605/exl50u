function pt
port = 41234;
shotpath = '/home/det/kstarxcs/';
shotno = input('Please input the shotno:');
dec038ip = '172.17.102.114'; 
dec039ip =  '172.17.102.149';
dec119ip = '172.17.102.108';

dec038 = tcpip(dec038ip,port);
%dec039 = tcpip(dec039ip,port);
dec119 = tcpip(dec119ip,port);

fopen(dec038);
fopen(dec119);
command = cat(2,'dcb_init',char(10));
fwrite(dec038,command);
%fwrite(dec039,command);
fwrite(dec119,command);
clear command;
pause(10);

command = cat(2,'setthreshold uhighg 2200',char(10));
fwrite(dec038,command);
%fwrite(dec039,command);
fwrite(dec119,command);
clear command;
pause(10);

command = cat(2,'nimages 10',char(10));
fwrite(dec038,command);
%fwrite(dec039,command);
fwrite(dec119,command);
clear command;
command = cat(2,'expperiod 0.020',char(10));
fwrite(dec038,command);
%fwrite(dec039,command);
fwrite(dec119,command);
clear command;
command = cat(2,'exptime 0.016',char(10));
fwrite(dec038,command);
%fwrite(dec039,command);
fwrite(dec119,command);
clear command;
%command = cat(2,'thread',char(10));
%fwrite(dec038,command);
%clear command;
command = cat(2,'imgpath ',shotpath,int2str(shotno),char(10));
fwrite(dec038,command);
%fwrite(dec039,command);
fwrite(dec119,command);
clear command;
pause(0.5);

command = cat(2,'exposure ', int2str(shotno),'_.tif',char(10));
fwrite(dec038,command);
%fwrite(dec039,command);
fwrite(dec119,command);
clear command

fclose(dec038); 
%fclose(dec039);
fclose(dec119);











