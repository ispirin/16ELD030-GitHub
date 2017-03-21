function ippgsig = getippg(clnarray, framerate)


fc_lp = 4; % high cut-off
fc_hp = 0.5; % low cut-off
fs = framerate;

Wn = [fc_hp/(fs/2) fc_lp/(fs/2)]; % normalise with respect to Nyquist frequency

[b,a] = butter(5, Wn, 'bandpass'); 

ippgsig = filtfilt(b,a,clnarray);
