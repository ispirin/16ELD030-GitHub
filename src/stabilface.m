function stabilface(sourcedir, startFrame, endFrame)
% blah

facesDir = dir(sourcedir); % 'C:\Users\Igor\Desktop\Frames\*.bmp'
% stabilDir  = dir(destdir);

for i = (startFrame) : (endFrame - 1) 
    filename = fullfile(facesDir(1).folder, facesDir(i).name);
    
    face = imread(filename);
    
    ptThresh = 0.1;
    
    ptsOut = detectFASTFeatures(face, 'MinContrast', ptThresh);
    length(ptsOut)

end