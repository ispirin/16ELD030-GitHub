global VID

if isempty(VID)
    disp('Reading video...')
    vfile = 'Face.avi';
    VID = VideoReader(vfile);
    fnum = VID.NumberOfFrames;
    disp('Video read!');
end

disp('Creating array...')
barray = zeros(1, 1001);
farray = [];
disp('Arrays created...')
disp('Processing frames...')
v = VideoWriter('ForeheadSnip.avi');
open(v);
m1 = 0;
n1 = 0;
z1 = 0;

for i = 1:1000
    frame  = read(VID, i);
    
    detector = vision.CascadeObjectDetector('FrontalFaceCART');
    
    face = step(detector, frame);
 
    forehead = [face(1)+(0.2*face(3)), face(2)*1.3, 0.6*face(3), 0.10*face(3)];
    
    imgOut = imcrop(frame, forehead);

    barray(i) = mean2(imgOut); 
    [m,n,z] = size(imgOut);
    imgOut = padarray(imgOut, [300-m, 600-n], 'post');
    
    if n1 == 0
        n1=n;
    elseif (n - n1) < 10 && (n - n1) > -10
        n1 = n;
        writeVideo(v,imgOut)
    end
    %farray = cat(4, farray, imgOut);  
end

figure
plot(barray)
axis([0, 96, 0, 200])

disp('Frames processed...')
disp('Cleaning up noise and creating video...')

for i = 1:1000
    check = barray(i+1) - barray(i);
    if (check < -20)
        barray(i+1) = 0;
    end
end

barray = barray(barray ~= 0);

close(v);
figure
plot(barray)
axis([0, 96, 0, 200])