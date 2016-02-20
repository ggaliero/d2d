function [ pos_using_rsc ] = using_rsc_pos( start_pos, ttt_max, len_data )
%using_rsc_pos - This function takes as input the positions of the data
%signal corresponding to the instant at which the resources of the pico
%station are available, after ttt reaches ttt_max. Together with ttt_max
%calculates all positions of the vector signal for which the resources of
%the pico station are being used to check the performance.
%
%   start_pos - Vector storing the position of the signal corresponding a 
%   time instant for which the pico resources start to be available after
%   ttt reaches ttt_max.
%
%   ttt_max - Maximum time-to-trigger (TTT) for decision making.
%
%   pos_using_rsc - Vector storing all positions of the signal for which
%   the pico resources are bieng used.
%

    N = length(start_pos);              % Number of times the resources from pico bs are used
    pos = zeros(1, ttt_max);          % Positions of the measured signal for which the resources
                                        % from pico bs are used
    
    % Here a vector is reproduced containing all signal positions for which
    % pico resources are used.
    
    % First a matrix is generated, each row comprises values starting from
    % positions in start_pos vector
    for i=1:N
        if((start_pos(i) + ttt_max - 1) > len_data)
            indx = len_data - start_pos(i) + 1;
            pos(i,1:indx) = start_pos(i):len_data;
        else
            pos(i,:) = start_pos(i):start_pos(i)+ttt_max-1;
        end
        
    end
    
    % Converts the previous matrix to vector
    pos_using_rsc = reshape(pos', [1,N*ttt_max]);

end

