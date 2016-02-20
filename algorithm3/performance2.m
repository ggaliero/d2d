function [ num_c, num_w, pos_w ] = performance2( data, thr, pos_yes_rsc, pos_no_rsc )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    num_c = 0;
    num_w = 0;
    
    for i=1:length(pos_yes_rsc)
        if(data(pos_yes_rsc(i)) < thr)
            num_c = num_c + 1;
        else
            num_w = num_w + 1;
            pos_w(num_w) = pos_yes_rsc(i);
        end
    end
    
    for j=1:length(pos_no_rsc)
        if(data(pos_no_rsc(j)) >= thr)
            num_c = num_c + 1;
        else
            num_w = num_w + 1;
            pos_w(num_w) = pos_no_rsc(j);
        end
    end

end

