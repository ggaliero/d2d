function [ data_out ] = rnd_start( data_in, num )
%rnd_start Reorder the vector representing the signal measured in time and 
%          generates a new vector where starting from a random element of
%          the input signal and continuing the sequence. It performs cyclic
%          ordering until reaching the original point.
%
%          data_in - Vector representing the signal values
%          num - Number of output vectors with random start
%          data_out - Matrix mxn where m is num and n is length of data_in
%

n = length(data_in);
rnd_pos = randi([1 n],1 , num);

data_out = zeros(num,n);

for i=1:num
    data_out(i,:) = [data_in(rnd_pos(i):n) data_in(1:rnd_pos(i)-1)];
end

end

