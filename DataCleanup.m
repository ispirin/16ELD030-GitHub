

length(barray)
for i = 1:length(barray)-1
    check = barray(i+1) - barray(i);
    if (check < -20)
        barray(i+1) = 0;
    end
end

barray = barray(barray ~= 0);

t = 0:(length(barray)/50)/length(barray):(length(barray)/50)-(length(barray)/50)/length(barray);

length(rarray)
for i = 1:length(rarray)-1
    check = rarray(i+1) - rarray(i);
    if (check < -0.3)
        rarray(i+1) = 0;
    end
end

rarray = rarray(rarray ~= 0);

t = 0:(length(barray)/50)/length(barray):(length(barray)/50)-(length(barray)/50)/length(barray);

[envHigh, envLow] = envelope(barray,16,'peak');
envMean = (envHigh+envLow)/2;

figure
plot(t,envMean)
title('AC Wave (50FPS, 970 (useful) Frames, No Stabilization/Spat. Avg.)')
xlabel('Time (s)')
ylabel('Avg Intensity')
axis([0, max(t), 140, 170])

t = 0:(length(rarray)/50)/length(rarray):(length(rarray)/50)-(length(rarray)/50)/length(rarray);

[envHigh, envLow] = envelope(rarray,16,'peak');
envMean = (envHigh+envLow)/2;

figure
plot(t,envMean)
title('AC Wave (50FPS, 970 (useful) Frames, ROI Stabilization/Spat. Avg: 1/5)')
xlabel('Time (s)')
ylabel('Avg Intensity')
axis([0, max(t), 0.72, 0.78])

