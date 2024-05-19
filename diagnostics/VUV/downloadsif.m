function outputData = downloadsif(shotnum, type)
% DOWNLOADSIF Retrieves SIF data based on shot number and diagnostic type
% Input:
%   shotnum - The shot number to retrieve
%   type    - The type of diagnostics ('VUV' or 'vis')

% Determine the file path based on the type of diagnostics
fileflag=1;
if strcmpi(type, 'vuv')
    filepath = '\\192.168.20.30\data\diagnostic_platform\EXL-50U\VUV';
    outputData.description = 'VUV diagnostics to measure the';
elseif strcmpi(type, 'vis')
    filepath = '\\192.168.20.30\data\diagnostic_platform\EXL-50U\Visible Spectrometer\data';
    outputData.description = 'VIS diagnostics to measure the';
elseif strcmpi(type, 'cxrs')
    filepath = '\\192.168.20.30\data\diagnostic_platform\EXL-50U\Visible Spectrometer\data';
    outputData.description = 'CXRS diagnostics to measure the';
    fileflag=2;
else
    error('Unsupported diagnostic type.');
end

% Search for files with .sif extension in the determined directory
if fileflag==1
    fileList = searchFiles(filepath, '.SIF');
else
    fileList = searchFiles(filepath, '.spe');
end


% Initialize variable to track if a matching file is found
found = false;

% Find the file corresponding to the given shot number
for i = 1:length(fileList)
    [~, filename] = fileparts(fileList{i});
    sifnumber = str2double(filename);
    if isnan(sifnumber)
        sifnumber = 0; % Handle cases where conversion fails
    end
    if shotnum == sifnumber
        filepath = fileList{i};
        found = true;
        break;
    end
end

% Check if file was found; if not, throw an error and exit
if ~found
    error('No corresponding file found in NAS database. Please check.');
end

% Read data from the .sif file
try
    if fileflag==1
        [data_arr, sif_properties, xaxis, yaxis, zaxis] = sifread(filepath);
        % Structure the output data
        outputData.value = data_arr;
        outputData.Xaxis = xaxis;
        outputData.XaxisUnit = 'nm';
        outputData.Yaxis = yaxis;
        outputData.YaxisUnit = 'Count';
        outputData.Zaxis = zaxis;
        outputData.ZaxisUnit = 'Frame';
        outputData.harwareInfo = sif_properties; % Corrected typo: 'hardwareInfo'
    else
        sp= loadSPE(filepath);
        outputData.Value=sp.int; %提取所有数据
        outputData.wave=sp.wavelength;
    end
catch
    error('Failed to read SIF file.');
end
end
