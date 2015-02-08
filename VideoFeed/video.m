function video

% Setup video file and camera readers
videoSource = 'camera'; % options are 'file' or 'camera'
if isequal(videoSource,'file')
    % import video from a file using the vision.VideoFileReader System Object
    videoReaderObject = vision.VideoFileReader('rawVideo_640x480.avi');
    videoReaderObject.VideoOutputDataType = 'uint8';
elseif isequal(videoSource,'camera')
    % import video from camera using the imaq.VideoDevice System Object
    videoReaderObject = imaq.VideoDevice('winvideo'); 
    videoReaderObject.VideoFormat = 'MJPG_640x480';
    videoReaderObject.ReturnedDataType = 'uint8';
end

% Setup video player
videoPlayerObject = vision.VideoPlayer();
set(videoPlayerObject,'Position',[9 594 657 510]);

% Step the video reader to extract each frame and then visualize
idx = 0;
while(idx<=100000) % run for 10 steps
    idx = idx + 100; % update iteration number
    frame = step(videoReaderObject);
    step(videoPlayerObject,frame);
    
    pause(0.2); % give the video player time to display
end

% Release Video Objects
release(videoReaderObject)
release(videoPlayerObject)