% Code testing homebrew filter function  

% t = linspace(-pi,pi,100);
% rng default  %initialize random number generator
% x = sin(t) + 0.25*rand(size(t));

[audioSeq,fs] = audioread('chirp.wav');
tlen = length(audioSeq)/fs; % length of audio signal
    
t = 0:1/fs:tlen;  % Time Range
t = t(1:length(audioSeq));

%fs = 16000;
wc1 =1000; % cut off frequency 
fn = fs/2;
% specify in rads/sec
Wp = wc1/fn;
Ws = 150/fn;

[n,Wn] = buttord(Wp,Ws,3,50);
[b,a] = butter(n,Wn);

%plot(t,audioSeq)
Y = Filt(b,a,audioSeq);
y = filter(b,a,audioSeq);
% 
plot(t,y)
 hold on
plot(t,Y)


legend('Input Data','Filtered Data')
