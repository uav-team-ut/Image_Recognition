% readVideo.m
function readVideo()
clear; clc
vid = VideoReader('/Users/Mark/Documents/MATLAB/wavelets/images/SUASvideo/UAVtest2.mov');
% vid = VideoReader(fullfile(workingDir,'images','SUASvideo','UAVtest2.mp4'));
% vwidth = vid.Width;
% vheight = vid.Height;

% mov = struct('cdata',zeros(vheight,vwidth,3,'uint8'),'colormap',[]);

frate = vid.FrameRate;
dur = vid.Duration;

ii = 1;

while hasFrame(vid)
   img = readFrame(vid);
   filename = [sprintf('%03d',ii) '.jpg'];
   fullname = strcat('/Users/Mark/Documents/MATLAB/wavelets/images/competition/',filename);
   imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
   ii = ii+1;
   if (vid.CurrentTime + 2-(1/frate)) <= dur
        vid.CurrentTime = (vid.CurrentTime + 2-(1/frate));
   end
end
end
% dt = 1/frate;
