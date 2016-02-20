function [ num_c, num_w, mse ] = performance( data, thr, pos_yes_rsc, pos_no_rsc )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    
    num_c = 0;
    num_w = 0;
    
    for i=1:length(pos_yes_rsc)
        if(data(pos_yes_rsc(i)) < thr)
            num_c = num_c + 1;
        else
            num_w = num_w + 1;
            sqerr(num_w) = (data(pos_yes_rsc(i)) - thr)^2;
        end
    end
    
    for j=1:length(pos_no_rsc)
        if(data(pos_no_rsc(j)) >= thr)
            num_c = num_c + 1;
        else
            num_w = num_w + 1;
            sqerr(num_w) = (data(pos_no_rsc(j)) - thr)^2;
        end
    end
    
    mse = mean(sqerr);
    
end

