function [ pos_no_rsc ] = not_using_rsc_pos( data, pos_yes_rsc )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    
    pos = 1:length(data);
    members = ismember(pos, pos_yes_rsc);
    counter = 0;
    
    for i=1:length(data)
        if(members(i) == 0)
            counter = counter + 1;
            pos_no_rsc(counter) = i;
        end
    end

end

