function video

% Setup video file and camera readers
videoSource = 'camera'; % options are 'file' or 'camera'
if isequal(videoSource,'file')
    % import video from a file using the vision.VideoFileReader System Object
    videoReaderObject = vision.VideoFileReader('rawVideo_640x480.avi');
    videoReaderObject.VideoOutputDataType = 'rgb';
elseif isequal(videoSource,'camera')
    % import video from camera using the imaq.VideoDevice System Object
    videoReaderObject = imaq.VideoDevice('winvideo'); 
    %videoReaderObject.VideoFormat = 'MJPG_640x480';
    %videoReaderObject.ReturnedDataType = 'uint8';
end

% Setup video player
videoPlayerObject = vision.VideoPlayer();
%set(videoPlayerObject,'Position',[250 700 657 510]);

folder = fullfile(cd, 'output');
%if  not existing 
if ~exist(folder, 'dir')
	%make directory & execute as indicated in opfolder variable
	mkdir(folder);
end

% Step the video reader to extract each frame and then visualize
dirData = dir('output');      %# Get the data for the output directory
  dirIndex = [dirData.isdir];  %# Find the index for directories
  fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
i=length(fileList);
while(i <= 1000) % run for X steps
    i = i + 1; % update iteration number
	pause(1); % pause before iterating (number of seconds between frames)
    frame = step(videoReaderObject);
    step(videoPlayerObject,frame);
	
	baseFileName = sprintf('%3.3d.png', i);
	fullFileName = fullfile(folder, baseFileName);
	imwrite(frame, fullFileName, 'png');   %saving as 'png' file
	%indicating the current progress of the file/frame written
	progIndication = sprintf('Wrote frame %4d.', i);
	disp(progIndication);
    
    pause(0.2); % give the video player time to display
end

% Release Video Objects
release(videoReaderObject)
release(videoPlayerObject)