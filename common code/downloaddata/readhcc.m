function [IRdata,time,camerainfo] = readhcc(filename,t1,t2,dframe,isframe)
            
            [~, header] = readIRCam(filename, 'Frames', 1);
            camerainfo.framerate=double(header.AcquisitionFrameRate);
            camerainfo.width=double(header.Width);
            camerainfo.height=double(header.Height);
            camerainfo.exposuretime=double(header.ExposureTime);
            camerainfo.shottime=header.POSIXTime;
            try
                if isframe
                    frame1=floor(t1);
                    frame2=floor(t2);
                else
                    frame1=t1*camerainfo.framerate;
                    frame2=t2*camerainfo.framerate;
                end
                [data, header] = readIRCam(filename, 'Frames', frame1:dframe:frame2);
                IRdata = formImage(header(1), data);
                time = t1+double([header.POSIXTime])+double([header.SubSecondTime])*1e-7-double(header(1).POSIXTime)-double(header(1).SubSecondTime)*1e-7;
            catch
                [data, header] = readIRCam(filename);
                IRdata = formImage(header(1), data);
                time=linspace(0,size(data,3)/camerainfo.framerate,size(IRdata,3))-0.5;
            end
            IRdata = formImage(header(1), data);
            IRdata=IRdata-273.15;
            IRdata=IRdata/0.675;
        end