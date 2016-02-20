 %% Algorithm 3 - Forgetting factor for HO
 % Tests the RSRP < threshold, if true the Time to Trigger Timer (TTT)
 %  starts to count until a predefined value. Make decision for a fixed 
 %  time during which the algorithm is still running.
 %  Giving the current measurement a weight of betha and the average of
 %  previous measured values a weight of alpha
 
 clear, clc
 
 load('data.mat');
 
 nmsps = 10;            % Number of ms per sample
 thr = -110;            % Threshold
 ttt_max = 150/nmsps;   % Time to trigger timer [ms]
 ttt = 0;               % Initial status of the timer
 m = 1;                 % Number of random iterations for data measured
 yes_dec_count = 0;
 
 betha = 0.7;           % Forgetting factor        
 alpha = 1 - betha;     % Weight of the average of previous measured values
 

 % Randomize the starting point
 n = length(meas_pico);
 data = rnd_start(meas_pico_dbm,m);
 
 % Creates a vector of average power within a time frame of time_frame ms
 % for testing purposes
 
 for i=1:length(data)
     
     % In the beginning of the algorithm the first measured value of RSRP
     % is taken for average RSRP. For the rest of cases the weight for
     % previous measurement RSRP values 
     if (i == 1)        
         avg = data(1);
     else
         avg = avg*alpha + data(i)*betha;
     end
     
     if(avg < thr)
        % Condition for utilizing pico station resources must remain at
        % least for ttt_max ms
        ttt = ttt + 1;
        
        if (ttt == ttt_max) 
            % Resources from pico cell are available for the next ttt_max
            % ms
            ttt = 0;                            % TTT is reset. No more decisions within the next ttt_max ms.
            if(i < length(data))
                avg = data(i+1);                  % Reset the average value of the signal to the instantaneous value of RSRP
            end
            yes_dec_count = yes_dec_count + 1;  % Counter how many times resources from pico cell can be used
            yes_pos(yes_dec_count) = i+1;         % Stores the position of the measured signal to study the performance
        end
     else
        % At least for the next ttt_max ms there will not be a yes
        % decision
        ttt = 0;                              % TTT is reset. No more decisions within the next ttt_max ms.
        if(i < length(data))
            avg = data(i+1);                  % Reset the average value of the signal to the instantaneous value of RSRP
        end

     end
 
 end
 
 % Performance
 % This way only the time intervals for which the pico resources are
 % available, are checked
 
 % Position of the measured signal values for which the pico resources are used
 pos_yes_rsc = using_rsc_pos (yes_pos, ttt_max, length(data));
 pos_yes_rsc(pos_yes_rsc == 0) = [];
 
 % Position of the measured signal values for which the pico resources are
 % not used
 pos_no_rsc = not_using_rsc_pos(data, pos_yes_rsc);
 
 % Number of mode changes
 num_ch = num_changes(pos_no_rsc);
 
 % It accounts the number of correct and wrond decision for the whole
 % measured signal
%  [num_c, num_w, mse] = performance(data, thr, pos_yes_rsc, pos_no_rsc);
 
 [num_c, num_w, pos_w] = performance2(data, thr, pos_yes_rsc, pos_no_rsc);
 
 pos_w = sort(pos_w);
 
 mse = mean((data(pos_w) - thr).^2);
 me = mean(abs(data(pos_w) - thr));
 

 accuracy = (num_c/(num_c + num_w))*100;
 
 str1 = ['Accuracy of the algorithm: ', num2str(accuracy)];
 str2 = ['Number of mode changes: ', num2str(num_ch)];
 str3 = ['Number of signal samps correct: ', num2str(num_c)];
 str4 = ['Number of signal samps wrong: ', num2str(num_w)];
 str5 = ['Mean Square Error: ', num2str(mse)];
 str6 = ['Mean Error:', num2str(me)];
 disp(str1);
 disp(str2);
 disp(str3);
 disp(str4);
 disp(str5);
 disp(str6);
