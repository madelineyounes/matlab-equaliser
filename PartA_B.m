%% Part A & B of Project 
% Madeline Younes (z5208494)
clear; clc; 

AudMic = input('Would you like to use the mic as audio input [y/n]?: ','s');
if AudMic == 'y'
    fs = 44100;   % Sampling Frequency 
    % usually 44100 is the standard since 20kHz is the highest audible freq
    % Nyquist–Shannon sampling theorem states that sampling freq 2*max 
    
    % To increase the resolution of the frequency decrease the window size
    % To increase the resolution of time then increase tres to increase N 
    tres = 0.005; % Time Resolution 
    N = 2^nextpow2(tres*fs); % Number of DFT points
    fwinSize = 500; % the size of the frequency window/frequency resolution 
    nfwin = floor(fs/fwinSize); % number of frequency windows
    
    f = linspace(0, (fs/2)/1000, N); % Frequency Range 
    % audible sound range is from 20 Hz to 20 kHz. 
    
    energy = []; % initalise energy vector
    t = 0:1/fs:10; % initalise time range
    count = 0; % initalise counter
    
    % initilise audio recording device from microphone
    AudInDevice = audioDeviceReader;
    AudIn = AudInDevice();

    while AudMic == 'y'
        tStart = tic;
        AudIn = AudInDevice();
        
        % get engergy 
        inDFT  = AudIn(fwinSize:(2)*fwinSize); % crops signal to freq window size
        audioDFT = DFT(inDFT, N);
        audioMag = abs(audioDFT);
        audioEng = 10.*log(flip(audioMag)).^2;
        energy = [energy; audioEng];
        
        if count <= 10
            % for the first 10 frames so that the display isnt empty at
            % start
            figure(1);
            imagesc(t, f, energy(1:count,:)');
            set(gca,'YDir','normal');
            c = colorbar;
            xlabel('Time [s]')
            ylabel('Frequency [Hz]')
            ylabel(c, 'Energy [J]')
        else
            % for every other frame 
            t = [(count-1):1/fs:count];
            figure(1);
            imagesc(t, f, energy(count-9:count-1, :)');
            set(gca,'YDir','normal');
            c = colorbar;
            xlabel('Time [s]')
            ylabel('Frequency [Hz]')
            ylabel(c, 'Energy [J]')
        end 
        tpass = toc(tStart); %time passed while running loop
        count = ceil(count + tpass); 
        refresh;
    end 
    release(AudInDevice)
else
    % get audio from wav file
    wavfile = input('Enter the file name in form of [filename.wav]: ','s');
    [audioSeq,fs] = audioread(wavfile);
    Realtime = input('Do you wish to process in realtime [y/n]?: ','s');
    
    % To increase the resolution of time then increase tres to increase N 
    % To increase the resolution of the frequency decrease the window size
    tres = 0.05; % Time Resolution 
    N = 2^nextpow2(tres*fs); % Number of DFT points (needs to be above 2^9 for octave file)
    fwinSize = 1000; % the size of the frequency window/frequency resolution 
    
    nfwin = floor(length(audioSeq)/fwinSize); % number of frequency windows 
    
    tlen = length(audioSeq)/fs; % length of audio signal
    
    t = 0:1/fs:tlen;  % Time Range 
    f = linspace(0, (fs/2)/1000, N); % Frequency Range 
    
    energy = []; % initalise energy vector
    audEng = [];
    if Realtime == 'y' 
        for i = 1:nfwin-1
            inDFT  = audioSeq(i*fwinSize:(i+1)*fwinSize); % get audio segment of len 
            audDFT = DFT(inDFT, N); % run DFT function and store in buffer
            audMag = abs(audDFT(1:N/2)); % get the magitude
            audEng = [audEng audMag']; % add to energy matrix
            
            % Displaying and playing sound in realtime
            sound(inDFT);
            figure(1);
            refresh
            energy = 10.*log(flip(audEng)).^2; % calculate energy
            imagesc(t, f, energy);
            set(gca,'YDir','normal')
            c = colorbar;
            xlabel('Time [s]')
            ylabel('Frequency [kHz]')
            ylabel(c, 'Energy [J]')
        end
        imagesc(t, f, energy);
    else
        for i = 1:nfwin-1
            inDFT  = audioSeq(i*fwinSize:(i+1)*fwinSize); % get audio segment of len 
            audDFT = FFT,m n(inDFT, N); % run DFT function and store in buffer
            audMag = abs(audDFT(1:N/2)); % get the magitude
            energy = [energy audMag']; % add to energy matrix
        end
        % Displaying and playing the sound
        figure(1);
        energy = 10.*log(flip(energy)).^2; % calculate energy
        %power = 20.*log(flip(energy)).^2;;
        soundsc(audioSeq,fs);
        imagesc(t, f, energy);
        set(gca,'YDir','normal');
        c = colorbar;
        xlabel('Time [s]')
        ylabel('Frequency [kHz]')
        ylabel(c, 'Energy [J]')
    end   
end 
    