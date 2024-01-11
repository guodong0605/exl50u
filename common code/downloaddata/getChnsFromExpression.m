function Outputchn=getChnsFromExpression(chns)
Seriesstr='-';                   %判断是否是连续的通道
Numberstr='[0-9]';          %从字符串中剥离出数字部分
Outputchn=[];
list=1;
if iscell(chns)                   %判断是否是元胞类型的输入，如果是，那就是混合输入
    for i=1:length(chns)
        temp=chns{i};
        temp=lower(temp);
        SeriesPosition=regexp(temp,Seriesstr);        %看字符串中是否有字符  '-'
        if ~isempty(SeriesPosition)
            NumPosition=regexp(temp,Numberstr);
            ChnNamestr=temp(1:NumPosition(1)-1);        %诊断名称字符串部分
            NumberLength=length(temp(NumPosition(NumPosition<SeriesPosition)));  %判断通道中数字部分的长度，可能涉及补0操作
            NumberStart=str2double(temp(NumPosition(NumPosition<SeriesPosition))); %诊断通道起始位置
            NumberEnd=str2double(temp(NumPosition(NumPosition>SeriesPosition)));  %诊断通道结束位置
            %---------------------通道名称后缀----------------------------------
            midleStr=temp(NumPosition(1):length(temp));  %通道后面是否有字符串
            p=regexp(midleStr,'[a-z]');
            if ~isempty(p)
                if length(p)>1
                    if strcmp(midleStr(p(1)),midleStr(p(2)))
                        postStr=midleStr(p(1));
                    else
                        msgbox('Wrong Input chn names!!!, The pos-Str should be the same');
                        break;
                    end
                else
                    postStr=midleStr(p(1));
                end
            else
                postStr='';
            end
            %--------------------------------------------------------------------------------
            
            for k=NumberStart:NumberEnd  %从开始数字到结束数字拼接诊断通道名称
                switch NumberLength
                    case 1
                        part2Str=num2str(k);
                    case 2
                        if k<10
                            part2Str=['0',num2str(k)];
                        else
                            part2Str=num2str(k);
                        end
                    case 3
                        if k<10
                            part2Str=['00',num2str(k)];
                        elseif k<100
                            part2Str=['0',num2str(k)];
                        else
                            part2Str=num2str(k);
                        end
                end
                Outputchn{list}=[ChnNamestr,part2Str,postStr];
                list=list+1;
            end
        else
            Outputchn{list}=temp;
            list=list+1;
        end
    end
else
    temp=chns;
    SeriesPosition=regexp(temp,Seriesstr);        %看字符串中是否有字符  '-'
    if ~isempty(SeriesPosition)
        NumPosition=regexp(temp,Numberstr);
        ChnNamestr=temp(1:NumPosition(1)-1);        %诊断名称字符串部分
        NumberLength=length(temp(NumPosition(NumPosition<SeriesPosition)));  %判断通道中数字部分的长度，可能涉及补0操作
        NumberStart=str2double(temp(NumPosition(NumPosition<SeriesPosition))); %诊断通道起始位置
        NumberEnd=str2double(temp(NumPosition(NumPosition>SeriesPosition)));  %诊断通道结束位置
        %---------------------通道名称后缀----------------------------------
        midleStr=temp(NumPosition(1):length(temp));  %通道后面是否有字符串
        p=regexp(midleStr,'[a-z]');
        if ~isempty(p)
            if length(p)>1
                if strcmp(midleStr(p(1)),midleStr(p(2)))
                    postStr=midleStr(p(1));
                else
                    msgbox('Wrong Input chn names!!!, The pos-Str should be the same');
                    return;
                end
            else
                postStr=midleStr(p(1));
            end
        else
            postStr='';
        end
        %--------------------------------------------------------------------------------              
        for k=NumberStart:NumberEnd  %从开始数字到结束数字拼接诊断通道名称
            switch NumberLength
                case 1
                    part2Str=num2str(k);
                case 2
                    if k<10
                        part2Str=['0',num2str(k)];
                    else
                        part2Str=num2str(k);
                    end
                case 3
                    if k<10
                        part2Str=['00',num2str(k)];
                    elseif k<100
                        part2Str=['0',num2str(k)];
                    else
                        part2Str=num2str(k);
                    end
            end
            Outputchn{list}=[ChnNamestr,part2Str,postStr];
            list=list+1;
        end
    else
        Outputchn=temp;
    end
end
end
