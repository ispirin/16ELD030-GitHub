function intensity ...
    = getforehead(sourcedir, forehdir, startFrame, endFrame)

% Set up directories for source (face) and output (stabil)
stabilDir = dir(sourcedir);
forehDir = dir(forehdir);
barray = [];

for i = startFrame:endFrame - 1
    filename = fullfile(stabilDir(1).folder, stabilDir(i).name); %step(hVideoSource);
    faceStabil = imread(filename); %imsharpen(imgin,'Radius',2,'Amount',2);
 
    forehead = [200, 25, 300, 70];
    
    imgOut = imcrop(faceStabil, forehead);
    
%     imshow(imgOut)

    barray(i) = mean(imgOut(:)); 
end
intensity = barray;
