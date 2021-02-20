%% DFT function
function [audioDTFT] = DFT(audioData,N)
    audiolen = length(audioData); 
    w = linspace(-pi,pi,N);
    audioDTFT = 0;
    for n=1:audiolen
        audioDTFT = audioDTFT + audioData(n).*exp(-1j*n*w);
    end
end 