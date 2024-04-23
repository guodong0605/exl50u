classdef cameraIR
    properties
        filePostion;
        coefficent=0.67;
        dt=0.5;
        Xpixel=4.78;
        Ypixel=4.78;
        Xcenter=327;
        Ycenter=260;
    end

    methods
        function obj = cameraIR()
            obj.filePostion='\\192.168.20.29\EXL50-Camera\exl50u\IRC-S2-150';
        end
        function [IRdata,time,camerainfo,cameraPath2] = downloadhcc(obj,shotnum,t1,t2,dframe)
            cameraPath='\\192.168.20.29\EXL50-Camera\exl50u\IRC-S2-150\';
            shotDate=shotdate(shotnum); %通过日期判断存放文件夹
            if shotnum<1e4
                shotname=[num2str(shotDate),'\0',num2str(shotnum),'\','0',num2str(shotnum),'.hcc'];
            else
                shotname=['\',num2str(shotnum),'\',num2str(shotnum),'.hcc']; %构建文件存储路径
            end
            cameraPath2=[cameraPath,shotname];
            [~, header] = readIRCam(cameraPath2, 'Frames', 1);
            camerainfo.framerate=double(header.AcquisitionFrameRate);
            camerainfo.width=double(header.Width);
            camerainfo.height=double(header.Height);
            camerainfo.exposuretime=double(header.ExposureTime);
            camerainfo.shottime=header.POSIXTime;
            try
                frame1=(t1+obj.dt)*camerainfo.framerate;
                frame2=(t2+obj.dt)*camerainfo.framerate;
                [data, header] = readIRCam(cameraPath2, 'Frames', frame1:dframe:frame2);
                IRdata = formImage(header(1), data);
                time = t1+double([header.POSIXTime])+double([header.SubSecondTime])*1e-7-double(header(1).POSIXTime)-double(header(1).SubSecondTime)*1e-7;
            catch
                [data, header] = readIRCam(cameraPath2);
                IRdata = formImage(header(1), data);
                time=linspace(0,size(data,3)/camerainfo.framerate,size(IRdata,3))-0.5;
            end
            IRdata = formImage(header(1), data);
            IRdata=IRdata-273.15;
            IRdata=IRdata/0.675;
        end
        function makeMovie(obj, shotnum, t1, t2, dframe, MinMaxScaling,  colormapName, videoFramerate,folderpath)
            if   nargin <3   t1  = 1; end
            if   nargin <4   t2  = 2; end
            if   nargin <5   dframe  = 1; end
            if   nargin <6   MinMaxScaling  = [20,50]; end
            if   nargin <7   colormapName  = 'telops'; end
            if   nargin <9   folderpath = fullfile(getenv('USERPROFILE'), 'Desktop');end

            % File and video setup
            videoFilename = fullfile(folderpath, sprintf('Shot_%d_Movie.mp4', shotnum));
            v = VideoWriter(videoFilename, 'MPEG-4');
            v.FrameRate = videoFramerate;
            open(v);

            % Download data
            try
                [irData, time,info] = obj.downloadhcc(shotnum, t1, t2, dframe);
            catch e
                error('Failed to download or process IR data: %s', e.message);
            end

            % Graphics setup
            R1=linspace(-obj.Xcenter*obj.Xpixel/1e3,(info.width-obj.Xcenter)*obj.Xpixel/1e3,size(irData,2));
            Z1=linspace(-obj.Ycenter*obj.Ypixel/1e3,(info.height-obj.Ycenter)*obj.Ypixel/1e3,size(irData,1));
            [RR,ZZ]=meshgrid(R1,Z1);

            fig = figure('Color', 'w', 'Units', 'Normalized', 'Position', [0.02, 0.02, 0.5, 0.6]);
            % Generate video frames

            for i = 1:size(irData, 3)
                img=reshape(irData(:,:,i),size(irData,1),size(irData,2));
                if i==1
                    pcolor(RR,ZZ,img);shading interp;
                    clim(MinMaxScaling)
                    colormap(colormapName);
                    colorbar
                    set(gca, 'FontWeight', 'bold', 'FontSize', 16, 'LineWidth', 1.5, 'XMinorTick', 'on', 'YMinorTick', 'on','ticklength',[0.02 0.02],'Xgrid','on','Ygrid','on','Box','on')
                    tx1=text(0.5,0.8,sprintf('Shot: %d @ %.2fs ', shotnum, time(i)), 'Color', 'w', 'FontSize', 14,'FontWeight','bold');

                else
                    figChildren = get(fig, 'Children');  % 获取图形中的所有子对象
                    pcolorObj = findobj(figChildren, 'Type', 'surface');
                    pcolorObj.CData=img;
                    clim(MinMaxScaling)
                    tx1.String=sprintf('Shot: %d @ %.2fs ', shotnum, time(i));
                end
                frame = getframe(fig);
                writeVideo(v, frame);
            end

            % Clean up
            close(v);
            close(fig);
            disp(['Movie created: ', videoFilename]);
        end

    end
end
