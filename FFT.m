t = 0:(length(envMean)/50)/length(envMean):(length(envMean)/50)-(length(envMean)/50)/length(envMean);
Fs = 1/0.02;           
T = 0.02;            
L = length(envMean*100);           
t = (0:L-1)*T;      

Y = abs(fft(envMean*100));

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

[b, a] = butter(4, [0.1, 0.2]);

f = Fs*(0:(L/2))/L;
plot(f,P1)
title('Frequency Domain Spectrum')
axis([0, 25, 0, 0.2]) 
xlabel('f (Hz)')
ylabel('|P1(f)|')

H = freqz(b, a, floor(length(envMean)/2));
% plot([0:25/(length(envMean)/2 -1):25], abs(H));

filtered = filter(b, a, envMean);
yaxis = 0:max(f)/944:max(f)-max(f)/944;

figure
plot(yaxis,filtered)
axis([0, max(f), -0.2, 0.2])
title('Frequency Domain Spectrum (Butterworth filter ~0.8-5Hz)') 
xlabel('f (Hz)')
ylabel('|P1(f)|')