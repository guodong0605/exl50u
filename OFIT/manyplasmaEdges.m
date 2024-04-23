function [a,b,lcfs,x]=manyplasmaEdges(shotnum,t1,t2,dt)
% Check if the parallel pool is active, if not, start one
pool = gcp('nocreate'); % Get the current parallel pool
if isempty(pool)
    parpool; % Start a new parallel pool with default settings
end

times=t1:dt:t2;
% Number of shots
nShots = numel(times);
outputs = cell(nShots, 1); % Preallocate cell array to store outputs
a=nan(nShots, 1);
b=a;
lcfs=a;
fit_x=nan(nShots, 100);
fit_y=nan(nShots, 100);
% Execute PlasmaEdgeDetect in parallel
parfor i = 1:nShots
    try
        outputs{i} = PlasmaEdgeDetect(shotnum, times(i));
    catch
        outputs{i} = nan;
    end

end

% Process or display results
for i = 1:nShots
    try
        a(i)=outputs{i,1}.a;
        b(i)=outputs{i,1}.b;
        lcfs(i)=outputs{i,1}.r2;
        fit_x(i,:)=outputs{i,1}.ellipse2(1,:);
        fit_y(i,:)=outputs{i,1}.ellipse2(2,:);
    catch
        a(i)=nan;
        b(i)=nan;
        lcfs(i)=nan;
        fit_x(i,:)=nan;
        fit_y(i,:)=nan;
    end

end
plasmParam.a=a;
plasmParam.b=b;
plasmParam.lcfs=lcfs;
plasmParam.ellipseX=fit_x;
plasmParam.ellipseY=fit_y;
end