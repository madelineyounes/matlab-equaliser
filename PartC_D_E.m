% get audio from wav file
wavfile = input('Enter the file name in form of [filename.wav]: ','s');
[audSeq,fs] = audioread(wavfile);
%% Resampling
% Sample rate of 8kHz, 16kHz, 22.05kHz or 44.1kHz

% Note: FIR filters are used for rescaling to prevent distortions while 
% scaling. 
if fs == 8000
    % Interpolation (upscaling)
    L = 2;
    len = L*length(audSeq);
    audIN = zeros([1 len]);
    j = 1;
    for i = 1:len
        if mod(i,L) == 0 
            audIN(i) = audSeq(j);
            j = j + 1;
        else 
            audIN(i) = 0; % insert 0
        end 
    end 
    fn = fs/2; % Nquist frequency
    wc = pi/L; % cut off frequency 
    wn = wc/fn;
    n = 5;  % order of filter
    [b,a] = fir1(n,wn); % get filter coefficents 
    audIN = Filt(b,a,audIN); 
elseif fs == 22050
    L = 320; % upscaling factor 
    M = 441; % downscaling factor 
    % Low Pass Filter band from fn/M to fn
    fn = fs/2; % Nquist frequency
    wc = min(pi/L, pi/M); % get min cut off frequency 
    wn = wc/fn;
    n = 5;  % order of filter
    
    % Interpolation 
    len = L*length(audSeq);
    audInt = zeros([1 len]);
    j = 1;
    for i = 1:len
        if mod(i,L) == 0 
            audInt(i) = audSeq(j);
            j = j + 1;
        else 
            audInt(i) = 0;
        end 
    end 
    
    % Low pass Filter 
    [b,a] = fir1(n,wn);
    audFil = Filt(b,1,audInt); 
    
    % Decimation
    j = 1;
    finlen = ceil((L/M)*length(audSeq));
    audIN = zeros([1 finlen]); 
     for i = 1:len
        if mod(i,M) == 0 
            audIN(j) = audFil(i);
            j= j +1;
        end 
    end 
elseif fs == 44100
    L = 160; % upscaling factor
    M = 441; % downscaling factor 
    
    % Interpolation 
    len = L*length(audSeq);
    audInt = zeros([1 len]);
    j = 1;
    for i = 1:len
        if mod(i,L) == 0 
            audInt(i) = audSeq(j);
            j = j + 1;
        else 
            audInt(i) = 0;
        end 
    end     
    % Low pass Filter 
    fn = fs/2;
    wc = min(pi/L, pi/M);
    wn = wc/fn;
    n = 6;  % somehow get n 
    b = fir1(n,wn);
    audFil = Filt(b,1,audInt); 
    
    % Decimation
    j = 1;
    finlen = ceil((L/M)*length(audSeq));
    audIN = zeros([1 finlen]); 
     for i = 1:len
        if mod(i,M) == 0 
            audIN(j) = audFil(i);
            j = j + 1;
        end 
    end   
else 
    audIN = audSeq;
end 
%% Equaliser
% Pass through 5 channel Equaliser with variable gains
% Gains
G1 = 1;
G2 = 1;
G3 = 1;
G4 = 1;
G5 = 1;

% Audiable sound is from 20Hz - 20kHz

% IIR filters are faster computationally requires less order & coefficents 
% non linear phase filter, more distortions than FIR but the human ear can
% not percieve those phase distortions. Hence the advantage of using IIR 
% outweighs the negatives. 

% Butterworth was used over other IIR filters as it has the most linear
% phase response, therby has the least amount of distortion due to ripples,
% overshoot and a better group delay performance. 

fs = 16000;
fn = fs/2;

% Paramaters that are used for all channel filters
swid = 40; % stop bandwidth
% Ripple Thresholds
Rp = 10;     % max ripple passband 
Rs = 11;     % max ripple stopband  

% Filter 1: low pass filter range (Hz)
wc1 = 1000; % cut off frequency 
% specify in rads/sec
Wp = wc1/fn;    % Low Pass window 
Ws = 150/fn;    % Stop window 

[n,Wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(n,Wn);
C1 = Filt(b,a,audIN);

% Filter 2: band pass filter range (Hz)
wl2 = wc1; % lower cut off 
wu2 = 3000; % upper cut off 
wo2 = sqrt(wu2*wl2); % centre frequency 

Wp = [wl2 wu2]/fn;              % pass band 
Ws = [wl2-swid wu2+swid]/fn;    % stop band 

[n,Wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(n,Wn);

C2 = Filt(b,a,audIN);

% Filter 3: band pass filter range (Hz)
% Voice has the range between 100-300Hz 
wl3 = wu2; % lower cut off
wu3 = 5000; % upper cut off
wo3 = sqrt(wu3*wl3); % centre frequency 

Wp = [wl3 wu3]/fn;              % pass band 
Ws = [wl3-swid wu3+swid]/fn;    % stop band 

[n,Wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(n,Wn);

C3 = Filt(b,a,audIN);

% Filter 4: band pass filter range (Hz)
wl4 = wu3; % lower cut off 
wu4 = 6000; % upper cut off (cant be more than fs/2)
wo4 = sqrt(wu4*wl4); % centre frequency 

Wp = [wl4 wu4]/fn;              % pass band 
Ws = [wl4-swid wu4+swid]/fn;    % stop band 

[n,Wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(n,Wn);

C4 = Filt(b,a,audIN);
C4_2 = filter(b,a, audIN);

% Filter 5: High pass filter range (Hz)
wc5 = wu4; % upper cut off 
Wp = wc5/fn;    % Low Pass window 
Ws = 3050/fn;    % Stop window 

[n,Wn] = buttord(Wp,Ws,Rp,Rs); % get optimum order & cut off frequencies 
[b,a] = butter(n,Wn,'high');      % generate butter filter coefficents 

C5 = Filt(b,a,audIN); % pass audio signal through filter 

% Display using PartA_B script 
fig = uifigure;
Gmax = 5;  % max limit for gain
Gmin = 0; % min limit for gain
Gdef = 1;   % default value for gain 

% Channel 1 Gain Slider Setup
sld1 = uislider(fig, 'Position',[100 25 350 275]);
label1 = uilabel(fig,...
    'Position',[100 41 200 15],...
    'Text','Channel 1 Gain (<1kHz)');
sld1.Limits = [Gmin Gmax];
sld1.Value = Gdef;

% Channel 2 Gain Slider Setup
sld2 = uislider(fig, 'Position',[100 100 350 275]);
label2 = uilabel(fig,...
    'Position',[100 116 200 15],...
    'Text','Channel 2 Gain (1-3kHz)');
sld2.Limits = [Gmin Gmax];
sld2.Value = Gdef;

% Channel 3 Gain Slider Setup
sld3 = uislider(fig, 'Position',[100 175 350 275]);
label3 = uilabel(fig,...
    'Position',[100 191 200 15],...
    'Text','Channel 3 Gain (3-5kHz)');
sld3.Limits = [Gmin Gmax];
sld3.Value = Gdef;

% Channel 4 Gain Slider Setup
sld4 = uislider(fig, 'Position',[100 250 350 275]);
label4 = uilabel(fig,...
    'Position',[100 261 200 15],...
    'Text','Channel 4 Gain (5-6kHz)');
sld4.Limits = [Gmin Gmax];
sld4.Value = Gdef;

% Channel 5 Gain Slider Setup
sld5 = uislider(fig, 'Position',[100 325 350 275]);
label5 = uilabel(fig,...
    'Position',[100 341 200 15],...
    'Text','Channel 5 Gain (>6kHz)');
sld5.Limits = [Gmin Gmax];
sld5.Value = Gdef;

Realtime = input('Do you wish to process in realtime [y/n]?: ','s');

if Realtime == 'y'
     energy = []; % initalise energy vector
     audEng = [];
     audOut = [];
     Output = G1.*C1 + G2.*C2+ G3.*C3 + G4.*C4 + G5.*C5;
     
    % Display changes in Gains Settings 
    fs = 16000;
    tres = 0.05; % Time Resolution 
    N = 2^nextpow2(tres*fs); % Number of DFT points
    fwinSize = 500; % the size of the frequency window/frequency resolution 

    nfwin = floor(length(Output)/fwinSize); % number of frequency windows 
    tlen = length(Output)/fs; % length of audio signal

    t = 0:1/fs:tlen;  % Time Range 
    f = linspace(0, (fs/2)/1000, N); % Frequency Range 

    for i = 1:nfwin-1
        G1 = ceil(sld1.Value);
        G2 = ceil(sld2.Value);
        G3 = ceil(sld3.Value);
        G4 = ceil(sld4.Value);
        G5 = ceil(sld5.Value);
        Output = G1.*C1 + G2.*C2+ G3.*C3 + G4.*C4 + G5.*C5;
        
        inDFT  = Output(i*fwinSize:(i+1)*fwinSize); % get audio segment of len 
        audDFT = DFT(inDFT, N); % run DFT function and store in buffer
        audMag = abs(audDFT(1:N/2)); % get the magitude
        audEng = [audEng audMag']; % add to energy matrix
        audOut = [audOut inDFT']; % matrix storing time domain 

        % Displaying and playing sound in realtime
        sound(inDFT);
        figure(1);
        energy = 10.*log(flip(audEng)).^2; % calculate energy
        imagesc(t, f, energy);
        set(gca,'YDir','normal')
        c = colorbar;
        xlabel('Time [s]')
        ylabel('Frequency [kHz]')
        ylabel(c, 'Energy [J]')
        refresh;
        drawnow;
    end
    audiowrite('output.wav',audOut,fs); % Save as an audio file
else
    SetGain = input('Have you set the gains to the desired outputs[y]?: ','s');
    % Gains
    G1 = ceil(sld1.Value);
    G2 = ceil(sld2.Value);
    G3 = ceil(sld3.Value);
    G4 = ceil(sld4.Value);
    G5 = ceil(sld5.Value);

    Output = G1.*C1 + G2.*C2+ G3.*C3 + G4.*C4 + G5.*C5;
    audiowrite('output.wav',Output,fs); % Save as an audio file 
    % Display changes in Gains Settings 
    fs = 16000;
    tres = 0.05; % Time Resolution 
    N = 2^nextpow2(tres*fs); % Number of DFT points (needs to be above 2^9 for octave file)
    fwinSize = 1000; % the size of the frequency window/frequency resolution 

    nfwin = floor(length(Output)/fwinSize); % number of frequency windows 
    tlen = length(Output)/fs; % length of audio signal

    t = 0:1/fs:tlen;  % Time Range 
    f = linspace(0, (fs/2)/1000, N); % Frequency Range 
    
    energy = []; % initalise energy vector

    for i = 1:nfwin-1
        outSeg  = Output(i*fwinSize:(i+1)*fwinSize); % get audio segment of len 
        outDFT = DFT(outSeg, N); % run DFT function and store in buffer
        audMag = abs(outDFT(1:N/2)); % get the magitude
        energy = [energy audMag']; % add to energy matrix
    end
    
    % Displaying and playing the sound
    figure(1);
    energy = 10.*log(flip(energy)).^2; % calculate energy
    soundsc(Output,fs);
    imagesc(t, f, energy);
    set(gca,'YDir','normal');
    c = colorbar;
    xlabel('Time [s]')
    ylabel('Frequency [kHz]')
    ylabel(c, 'Energy [J]')
end 

