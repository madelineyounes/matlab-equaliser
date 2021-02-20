%% Filter Function
function [filtaudio] = Filt(B,A,X)
    n = length(A); % get the number of coefficents
    Z(n) = 0; % initilise a vec
    
    % Normalise Paramaters 
    B = B / A(1);  
    A = A / A(1);
    
    Y = zeros(size(X));
    
    for m = 1:length(X)
        Y(m) = B(1)*X(m) + Z(1);
        for i = 2:n
            Z(i - 1) = B(i)*X(m) + Z(i) - A(i)*Y(m);
        end
    end
    filtaudio = Y;
end 