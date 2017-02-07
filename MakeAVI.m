workingDir = 'C:\Users\Igor\Desktop';
mkdir(workingDir)
mkdir(workingDir,'im2avi')

imageNames = dir(fullfile(workingDir,'Frames','*.bmp'));
imageNames = {imageNames.name}';

outputVideo = VideoWriter(fullfile(workingDir,'FacefulOfDollars.avi'));
outputVideo.FrameRate = 50;
open(outputVideo)

for ii = 300:1300
   img = imread(fullfile(workingDir,'Frames',imageNames{ii}));
   writeVideo(outputVideo,img)
end

close(outputVideo)

