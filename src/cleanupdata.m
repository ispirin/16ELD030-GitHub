function [clean, t] = cleanupdata(intarray)

for i = 1:length(intarray)-1
    check = intarray(i+1) - intarray(i);
    if (check < -0.5)
        intarray(i+1) = 0;
    end
end

clean = intarray(intarray ~= 0);

t = 0:(length(clean)/50)/length(clean): ...
(length(clean)/50)-(length(clean)/50)/length(clean);
