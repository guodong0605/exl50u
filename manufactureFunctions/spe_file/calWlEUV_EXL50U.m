%EUVL的波长计算程序, , 前两个输入参数是炮号和横向像素位置,调用方式: lambda=calWlEUV_EXL50U(2741,818,'L1');
function [lambda]=calWlEUV_EXL50U(CCDPos,pixNum,Spectrometer,varargin)
% calculate wavelength of EUV spectrometers on EXL-50U
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% CCDPos: CCD position(mm) or shot number (e.g., 2741)
% Spectrometer: EUVS:EUVShort, EUVL:EUVLong
% pixNum: pixel indice
% varargin: {'sifInfo',sifInfo}
% ;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

p = inputParser;
% 定义参数及其默认值和验证函数
addParameter(p, 'sifInfo', struct(), @isstruct);
% 解析输入参数
parse(p, varargin{:});
% 从解析结果中获取参数值
sifInfo = p.Results.sifInfo;


dfocal= 235   ;%%distance from grating center to focal plane,mm


if ~exist('Spectrometer','var')
    Spectrometer='L1';
end
Spectrometer=upper(Spectrometer);
switch Spectrometer
    case {'SHORT','EUVSHORT','EUVS','EUVS1','S1'}
        pixSz=26.*10.^(-3);%pixel size
        dGroove=10.^(-3)/2400*10.0^(10);%groove spacing,angstrom
        pixNumF=pixNum;

        CCDPos=nan;
        
        dOffset=10.7;%change beta to beta+.5degree
        alpha=deg2rad(88.6);%incidence angle
        beta=atan(dfocal./(CCDPos+dOffset+(pixNumF-0.5)*pixSz))+deg2rad(0.5);


    case {'LONG','EUVLONG','EUVL','EUVL1','L1'}
        
        pixSz=13.*10.^(-3);%pixel size
        dGroove=10.^(-3)/1200*10.0^(10);%groove spacing,angstrom
        pixNumF=1025-pixNum;

        if ~isempty(fieldnames(sifInfo))
            if strcmpi(sifInfo.HeadModel,'DO934P_BN')
                pixSz=13.*10.^(-3);%pixel size
                if str2double(sifInfo.FlipX)==0
                    %For normal installation on EUV spectrometers, X axis should be flipped
                    pixNumF=1025-pixNum;
                end
            end

        end

        if (mod(CCDPos,1) == 0) &&  (CCDPos > 100 )
            CCDPos=getDetPosEUVL_EXL50U(CCDPos);
        end
        dOffset=12.985;
        alpha=deg2rad(87.0);%*!dtor;incidence angle
        beta=atan(dfocal./(CCDPos+dOffset+(pixNumF-0.5)*pixSz))+deg2rad(0.5);
    otherwise

        disp('Invalid name for a spectrometer! ')
end

lambda=dGroove.*(sin(alpha)-sin(beta));

end
function [ccdpos]=getDetPosEUVL_EXL50U(shotnum)

filedir		=	fullfile('\\192.168.20.25\sxr\EUV','EUV.xlsx');
if ~exist(filedir,'file')
    error('No record file!')
    %     return
end
% temp_V 		= load(filedir);
opts = detectImportOptions(filedir);
opts.SelectedVariableNames = opts.VariableNames([1, 6]);
opts.VariableNamingRule='preserve';
temp_V=readtable(filedir,opts);temp_V=table2array(temp_V);
temp_V(isnan(temp_V(:,1)),:)=[];

shot_start=temp_V(1:end,1);shot_end=[temp_V(2:end,1)-1;inf];ccdpos_V=temp_V(:,end);
ind			=	find((shot_start <= shotnum) & (shot_end >= shotnum));
if ~isempty(ind)
    if length(ind) > 1
        disp(['The list of exact EUVS2 CCD positions has duplicate items. ',filedir]);
        ccdpos=[];
        return
    end
    ccdpos	= ccdpos_V(ind);
end
end
