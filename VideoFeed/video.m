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
    videoReaderObject.VideoFormat = 'MJPG_640x480';
    videoReaderObject.ReturnedDataType = 'uint8';
end

% Setup video player
videoPlayerObject = vision.VideoPlayer();
%set(videoPlayerObject,'Position',[250 700 657 510]);

% Step the video reader to extract each frame and then visualize
idx = 0;
while(idx<=1000) % run for X steps
    idx = idx + 1; % update iteration number
	pause(1); % pause before interating
    frame = step(videoReaderObject);
    step(videoPlayerObject,frame);
    
    pause(0.2); % give the video player time to display
end

% Release Video Objects
release(videoReaderObject)
release(videoPlayerObject)