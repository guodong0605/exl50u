function multiCamera(shotnum,t1,t2,chnNames)
    % Step 1: Load data
    [img, time_img] = downloadcine(shotnum);
    [img2, time_img2] = downloadhcc(shotnum);

    % Step 2: Create figure and set up layout
    fig = figure('Position', [100, 100, 1200, 600]);
    leftAxes1 = subplot(2, 2, 1);
    leftAxes2 = subplot(2, 2, 3);
    rightAxes = subplot(1, 2, 2);

    % Step 3: Set up video writer
    writerObj = VideoWriter('experiment_video.mp4', 'MPEG-4');
    writerObj.FrameRate = 10; % Adjust according to data timing
    open(writerObj);

    % Assume all data have the same number of points for simplicity
    numFrames = length(time_img); % Or some other relevant measure

    % Loop through each time step
    for i = 1:numFrames
        % Update image data
        axes(leftAxes1);
        imshow(img(:, :, i), 'Parent', leftAxes1);
        title(leftAxes1, ['Time: ', num2str(time_img(i)), 's']);

        axes(leftAxes2);
        imshow(img2(:, :, i), 'Parent', leftAxes2);
        title(leftAxes2, ['Time: ', num2str(time_img2(i)), 's']);

        % Update plot data
        axes(rightAxes);
        hold off;
        plotData(shotnum, time_img(i)); % A function to plot data up to time_img(i)
        hold on;
        xline(time_img(i), 'r', 'LineWidth', 2); % Reference line

        % Capture frame
        frame = getframe(fig);
        writeVideo(writerObj, frame);
    end

    % Close video writer
    close(writerObj);
    close(fig);
end

function plotData(shotnum, currentTime)
    % This function would use your parameter function logic to plot data
    % up to currentTime. It's simplified here.
    t1 = -2; % Start time for data
    t2 = currentTime; % Current time for partial data plotting
    waveform = {{'ipf09','ipf10'},{'ipf05','ipf06'},{'ipf07','ipf08'}};
    Fs = 1e5; % Sampling frequency

    parameter(shotnum, t1, t2, waveform, Fs); % Reusing your existing function
end
