function stabilface(sourcedir, stabildir, startFrame, endFrame)
% function stabilface: removes motion artifacts from a set of images
%                      of human face extracted from a set of frames
%
% sourcedir  - directory containing frames, format: 
%              <path>\<frame folder>\*.<extension>
%
% stabildir  - destination directory to store frames in
%              <path>\<frame folder>\*.<extension>
%
% startFrame - start from a particular frame
%
% endFrame   - end with a particular frame

hTM = vision.TemplateMatcher('ROIInputPort', true, ...
                            'BestMatchNeighborhoodOutputPort', true);

% Set up directories for source (face) and output (stabil)
facesDir = dir(sourcedir);
stabilDir = dir(stabildir);
                        
% Set up search region
pos.template_orig = [285 340]; % [x y] from upper left corner
pos.template_size = [60 60];   % [width height] size of search region
pos.search_border = [0 0];     % limit search box displacement
pos.template_center = floor((pos.template_size-1)/2);
pos.template_center_pos = (pos.template_orig + pos.template_center - 1);

% Maximum size of image, set to the capture resolution
W = 1280; 
H = 1024; 

% Set stabilized image properties
targetRowIndices = ...
  pos.template_orig(2)-1:pos.template_orig(2)+pos.template_size(2)-2;
targetColIndices = ...
  pos.template_orig(1)-1:pos.template_orig(1)+pos.template_size(1)-2;
searchRegion = pos.template_orig - pos.search_border - 1;

% Allocate memory and set up flags
Offset = [0 0];
Target = zeros(60,60);
firstTime = true;

for i = startFrame : endFrame - 1 
    filename = fullfile(facesDir(1).folder, facesDir(i).name); %step(hVideoSource);
    face = imread(filename); %imsharpen(imgin,'Radius',2,'Amount',2);
    [w, h] = size(face);
    face = padarray(face, [W-w, H-h], 'post');
    sz = size(face);

    % Find location of the search region
    if firstTime
      Idx = int32(pos.template_center_pos);
      MotionVector = [0 0];
      firstTime = false;
    else
      IdxPrev = Idx;

      ROI = [searchRegion, pos.template_size+2*pos.search_border];
      Idx = step(hTM, face, Target, ROI);

      MotionVector = double(Idx-IdxPrev);
    end
    
    [Offset, searchRegion] = updatesearch(sz, MotionVector, ...
        searchRegion, Offset, pos);

    % Translate frame to offset motion artifacts
    Stabilized = imtranslate(face, Offset, 'linear');
    Target = Stabilized(targetRowIndices, targetColIndices);
                
    %imshowpair(face, Stabilized, 'montage');
    
    imageName = sprintf('%d.bmp', i);  
    fullDistStabil = fullfile(stabilDir(1).folder, imageName);
    imwrite(Stabilized, fullDistStabil, 'bmp');    
end
