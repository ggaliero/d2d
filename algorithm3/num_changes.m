function [ num ] = num_changes( pos_no_rsc)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    num = 0;

    if (length(pos_no_rsc) > 1)
        
        prev = pos_no_rsc(1);
    
        for i=2:length(pos_no_rsc)
            
            if(prev ~= pos_no_rsc(i) - 1)
                
                num = num +2;
                
            end
            prev = pos_no_rsc(i);
        end
    end
    

end

