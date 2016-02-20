function [ avrg ] = averaging( data, time_frame, nspms )
%UNTITLED4 Summary of this function goes here
%   time_frame Time interval of the averaging [ms]
     
    m = time_frame/nspms;
    n = floor(length(data)/m);
    aux1 = zeros(m,n);
    
    for i=0:n-1
        a = i*m+1;
        b = i*m+m;
        aux2 = data(a:b);
        aux1(:,i+1) = aux2;
    end
    
    avrg = mean(aux1);

end

