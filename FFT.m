% DFT Note N must be to the pow of 2
function [audioFFT] = FFT(audioData, N)
    audiolen = length(audioData);
    
    if mod(log2(audiolen), 1) ~= 0
        crop = nextpow2(audiolen)-1;
        audCrop = audioData(1:end-crop);
        audiolen = length(audCrop);
    end 
    
    if mod(log2(audiolen), 1) ~= 0
       audiolen
    end 

    % if N < 32 O[N^2] DFT on all length-N_min sub-problems at once 
    N_min = min(audiolen,32);
   
    n = 0:1:N_min-1;
    k = n';
    M = exp(-2j.*pi.*n.*k./N_min);
    audReshape = reshape(audCrop, [], N_min)';
    if (size(audReshape,2) < N_min)
        diff = N_min - size(audReshape,1);
        audReshape = [audReshape zeros(N_min, diff)];    
    end 
    size(audReshape)
    X = dot(M,audReshape);

    
   for n=1:audiolen
       X_even = X(:, 1:length(X)/2);
       X_odd = X(:, length(X)/2:end);
       factor = exp(-1j * pi * (1:size(X,1))/size(X,1))';
       audioFFT = [(X_even + factor*X_odd); (X_even - buff*X_odd)];
   end 
end