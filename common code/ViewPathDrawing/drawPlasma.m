function [plasma_handle,plasmaR]=drawPlasma(filepath,name,flag)

switch name
    case 'EXL-50U'
        if flag==1
            PlasmaX=xlsread(filepath,3,'R4:R40');
            PlasmaZ=xlsread(filepath,3,'S4:S40');
        else
            PlasmaX=xlsread(filepath,3,'Y4:Y40');
            PlasmaZ=xlsread(filepath,3,'Z4:Z40');
        end

    case 'GLOBUS-M2'
        PlasmaX=xlsread(filepath,3,'AE4:AE40');
        PlasmaZ=xlsread(filepath,3,'AF4:AF40');
    case 'MSAT-U'
        PlasmaX=xlsread(filepath,3,'AK4:AK40');
        PlasmaZ=xlsread(filepath,3,'AL4:AL40');
    case 'NSTX-U'
        PlasmaX=xlsread(filepath,3,'AW4:AW40');
        PlasmaZ=xlsread(filepath,3,'AX4:AX40');
    case 'COMPASS-U'
        PlasmaX=xlsread(filepath,3,'BC4:BC40');
        PlasmaZ=xlsread(filepath,3,'BD4:BD40');
    case 'NSTX-U'
        PlasmaX=xlsread(filepath,3,'AW4:AW40');
        PlasmaZ=xlsread(filepath,3,'AX4:AX40');
    case 'ST40'
        PlasmaX=xlsread(filepath,3,'BI4:BI40');
        PlasmaZ=xlsread(filepath,3,'BJ4:BJ40');
    case 'JT-60SA'
        PlasmaX=xlsread(filepath,3,'BO4:BO40');
        PlasmaZ=xlsread(filepath,3,'BP4:BP40');
    case 'QUEST'
        PlasmaX=xlsread(filepath,3,'BU4:BU40');
        PlasmaZ=xlsread(filepath,3,'BV4:BV40');
end
plasmaColor=[167, 9, 245]/255;
plasma_handle=patch(PlasmaX(2:end)/1e3,PlasmaZ(2:end)/1e3,plasmaColor);
set(plasma_handle,'FaceAlpha',0.2)
% plot(PlasmaX(1)/1e3,PlasmaZ(1)/1e3,'--ko','MarkerSize',12,'MarkerEdgeColor','k','MarkerFaceColor','k')
plasmaR=PlasmaX(1)/1e3;

end