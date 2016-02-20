function [ num ] = num_changes( decisions )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    
    num = 0;
    
    for i=2:length(decisions)
        prev = i - 1;
        if(decisions(i) ~= decisions(prev))
            num = num + 1;
        end
    end

end

