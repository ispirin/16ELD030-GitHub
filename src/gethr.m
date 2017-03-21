function hr = gethr(ippgarray)

fft_data = abs(fft(ippgarray));
[~, peak_pos] = max(fft_data);
peak_f = f_axis(peak_pos);
hr = round(peak_f*50);