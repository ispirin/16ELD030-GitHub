function getface(sourcedir, destdir, startFrame, endFrame, skip)
% function getface: parses through a file of frames of human face
%                    detects and crops out the face box
%
% sourcedir  - directory containing frames, format: 
%              <path>\<frame folder>\*.<extension>
%
% destdir    - destination directory to store frames in
%              <path>\<frame folder>\*.<extension>
%
% startFrame - start from a particular frame
%
% endFrame   - end with a particular frame
%
% skip       - set to "1" to process every frame
%              otherwise same face box will be used 
%              for "skip" number of frames

skipCount = 0;

framesDir = dir(sourcedir); % 'C:\Users\Igor\Desktop\Frames\*.bmp'
facesDir  = dir(destdir);

detector = vision.CascadeObjectDetector('FrontalFaceCART');

for i = (startFrame) : (endFrame - 1) 
    filename = fullfile(framesDir(1).folder, framesDir(i).name);
    
    frame = imread(filename);
    
    if skipCount == 0 || skipCount == skip
        skipCount = 0;
        faceBox = step(detector, frame);
    end
    
    skipCount = skipCount + 1;
    
    try
        face = imcrop(frame, faceBox);
    catch       
        warning('Problem detecting face. Skipping frame %s.', ...
            framesDir(i).name);
    end
    
    imageName = sprintf('%d.bmp', i);  
    
    fullDistFaces = fullfile(facesDir(1).folder, imageName);
    
    imwrite(face, fullDistFaces, 'bmp');
end

