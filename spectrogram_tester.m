[song, fs] = audioread('octave.wav');
tmax = length(song)/fs;
song = song(1:fs*tmax);

%spectrogram(song, windowSize, windowOverlap, freqRange, fs, 'yaxis');

%Larger Window Size value increases frequency resolution
%Smaller Window Size value increases time resolution
%Specify a Frequency Range to be calculated for using the Goertzel function
%Specify which axis to put frequency

%%EXAMPLE
figure(2)
spectrogram(song, 256, [], [], fs, 'yaxis');
%Window Size = 256, Window Overlap = Default, Frequency Range = Default
%Feel free to experiment with these values