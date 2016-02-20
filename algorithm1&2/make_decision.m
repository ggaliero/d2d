function [ decisions ] = make_decision( input, thr )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    
    n = length(input);
    decisions = zeros(1,n);
    for i=1:n
        if(input(i) < thr)
            decisions(i) = 1;
        end
    end

end

