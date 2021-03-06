% filename = 'ForeheadSnip.avi';
% hVideoSource = vision.VideoFileReader(filename, 'ImageColorSpace', 'Intensity',...
%                                       'VideoOutputDataType', 'double');

hTM = vision.TemplateMatcher('ROIInputPort', true, ...
                            'BestMatchNeighborhoodOutputPort', true);

facesDir = dir('C:\Users\Igor\Desktop\Faces\*.bmp');                        
                        
% hVideoOut = vision.VideoPlayer('Name', 'Video Stabilization');
% hVideoOut.Position(1) = round(0.4*hVideoOut.Position(1));
% hVideoOut.Position(2) = round(1.5*(hVideoOut.Position(2)));
% hVideoOut.Position(3:4) = [650 350];

pos.template_orig = [100 15]; % [x y] upper left corner
pos.template_size = [123 123];  % [width height]
pos.search_border = [0 0];    % max horizontal and vertical displacement
pos.template_center = floor((pos.template_size-1)/2);
pos.template_center_pos = (pos.template_orig + pos.template_center - 1);
% fileInfo = info(hVideoSource);
W = 700; %fileInfo.VideoSize(1); % Width in pixels
H = 700; %fileInfo.VideoSize(2); % Height in pixels
BorderCols = [1:pos.search_border(1)+4 W-pos.search_border(1)+4:W];
BorderRows = [1:pos.search_border(2)+4 H-pos.search_border(2)+4:H];
sz = [700, 700]; %fileInfo.VideoSize;
TargetRowIndices = ...
  pos.template_orig(2)-1:pos.template_orig(2)+pos.template_size(2)-2;
TargetColIndices = ...
  pos.template_orig(1)-1:pos.template_orig(1)+pos.template_size(1)-2;
SearchRegion = pos.template_orig - pos.search_border - 1;
Offset = [0 0];
Target = zeros(18,22);
firstTime = true;
farray = [];
rarray = [];
crsmallest = [Inf, Inf];
v = VideoWriter('ForeheadStabil.avi','Uncompressed AVI');
i = 0;

while ~isDone(hVideoSource)
    i = i + 1;
    
    imgin = fullfile(facesDir(1).folder, facesDir(i).name); %step(hVideoSource);
    input = imread(imgin); %imsharpen(imgin,'Radius',2,'Amount',2);

    % Find location of Target in the input video frame
    if firstTime
      Idx = int32(pos.template_center_pos);
      MotionVector = [0 0];
      firstTime = false;
    else
      IdxPrev = Idx;

      ROI = [SearchRegion, pos.template_size+2*pos.search_border];
      Idx = step(hTM, input, Target, ROI);

      MotionVector = double(Idx-IdxPrev);
    end

    [Offset, SearchRegion] = updatesearch(sz, MotionVector, ...
        SearchRegion, Offset, pos);

    % Translate video frame to offset the camera motion
    Stabilized = imtranslate(input, Offset, 'linear');

    Target = Stabilized(TargetRowIndices, TargetColIndices);

    % Add black border for display
    Stabilized(:, BorderCols) = 0;
    Stabilized(BorderRows, :) = 0;

    TargetRect = [pos.template_orig-Offset, pos.template_size];
    SearchRegionRect = [SearchRegion, pos.template_size + 2*pos.search_border];

    % Draw rectangles on input to show target and search region
    input = insertShape(input, 'Rectangle', [TargetRect; SearchRegionRect],...
                        'Color', 'white');
    % Display the offset (displacement) values on the input image
    txt = sprintf('(%+05.1f,%+05.1f)', Offset);
    input = insertText(input(:,:,1),[191 215],txt,'FontSize',16, ...
                    'TextColor', 'white', 'BoxOpacity', 0);
    figure; imshow(input)
    % Display video
    %step(hVideoOut, [input(:,:,1) Stabilized]);
    ROI = imcrop(input(:,:,1), SearchRegionRect);
    farray = cat(3, farray, ROI);
    crsize = [sum(Stabilized(:,4)~=0.0016), sum(input(1,:)~=0.0016)];
    if crsmallest(1) > crsize(1); crsmallest(1)=crsize(1); end
    if crsmallest(2) > crsize(2); crsmallest(2)=crsize(2); end
    %pause(0.5)
end

open(v);
for idx = 1:length(farray(:,:,:))
    %imout = imcrop(farray(:,:,idx), [50, 20, 100, 20]);
    imout = farray(:,:,idx);
    Reduced = imresize(imout, [31/5, 150/5]);
    rarray = cat(2, rarray, mean2(imout));
    writeVideo(v,imout) 
end
close(v);
release(hVideoOut);