function [ num_c, num_w, pos_w ] = performance( data, decisions, thr, time_frame, nspms )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

    num_c = 0;
    num_w = 0;
    N = length(decisions)-1;

    for j=1:N

        for i= j*(time_frame/nspms)+1 : (time_frame/nspms)*(j + 1)

            if((decisions(j) == 1 && data(i) < thr) || (decisions(j) == 0 && data(i) > thr))
                num_c = num_c + 1;
            else
                num_w = num_w + 1;
                pos_w(num_w) = i;
            end

        end

    end

end

