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
 ttt_max = 100/nmsps;   % Time to trigger timer [ms]
 ttt = 0;               % Initial status of the timer
 m = 1000;              % Number of random iterations for data measured
 
 
 betha = 0.1:0.05:0.9;           % Forgetting factors     
 alpha = 1 - betha;     % Weight of the average of previous measured values
 
 p = length(betha);
 num_ch = zeros(p, m);  % Number of times the mode changes
 num_c = zeros(p,m);
 num_w = zeros(p,m);
 accuracy = zeros(p,m);
 mse = zeros(p,m);
 me = zeros(p,m);
 
 mse_avg = zeros(p,1);
 me_avg = zeros(p,1);
 accuracy_avg = zeros(p,1);
 num_ch_avg = zeros(p,1);
 num_c_avg = zeros(p,1);
 num_w_avg = zeros(p,1);
 
 % Randomize the starting point
 n = length(meas_pico);
 [data] = rnd_start(meas_pico_dbm,m);
 
 % Creates a vector of average power within a time frame of time_frame ms
 % for testing purposes
 
 for k=1:p
    
    for i=1:m
      
      yes_dec_count = 0;
     
      for j=1:n

      % In the beginning of the algorithm the first measured value of RSRP
      % is taken for average RSRP. For the rest of cases the weight for
      % previous measurement RSRP values 
         if (j == 1)        
             avg = data(i,1);
         else
             avg = avg*alpha(k) + data(i,j)*betha(k);
         end

         if(avg < thr)
            % Condition for utilizing pico station resources must remain at
            % least for ttt_max ms
            ttt = ttt + 1;

            if (ttt == ttt_max) 
                % Resources from pico cell are available for the next ttt_max
                % ms
                ttt = 0;                            % TTT is reset. No more decisions within the next ttt_max ms.
                if(j < n)
                    avg = data(i,j+1);                  % Reset the average value of the signal to the instantaneous value of RSRP
                end
                yes_dec_count = yes_dec_count + 1;  % Counter how many times resources from pico cell can be used
                yes_pos(yes_dec_count) = j+1;         % Stores the position of the measured signal to study the performance
            end
         else
            % At least for the next ttt_max ms there will not be a yes
            % decision
            ttt = 0;                              % TTT is reset. No more decisions within the next ttt_max ms.
            if(j < n)
                avg = data(i,j+1);                  % Reset the average value of the signal to the instantaneous value of RSRP
            end

         end

     end

     % Performance
     % This way only the time intervals for which the pico resources are
     % available, are checked

     % Position of the measured signal values for which the pico resources are used
     pos_yes_rsc = using_rsc_pos (yes_pos, ttt_max, n);
     pos_yes_rsc(pos_yes_rsc == 0) = [];

     % Position of the measured signal values for which the pico resources are
     % not used
     pos_no_rsc = not_using_rsc_pos(data(i,:), pos_yes_rsc);

     % Number of mode changes
     num_ch(k,i) = num_changes(pos_no_rsc);

     % It accounts the number of correct and wrond decision for the whole
     % measured signal
    %  [num_c, num_w, mse] = performance(data, thr, pos_yes_rsc, pos_no_rsc);

     [num_c(k,i), num_w(k,i), pos_w] = performance2(data(i,:), thr, pos_yes_rsc, pos_no_rsc);

     pos_w = sort(pos_w);

     mse(k,i) = mean((data(i,pos_w) - thr).^2);
     me(k,i) = mean(abs(data(i,pos_w) - thr));

     accuracy(k,i) = (num_c(k,i)/(num_c(k,i) + num_w(k,i)))*100;
     
     clear pos_yes_rsc
     clear pos_no_rsc
     clear yes_pos
     clear pos_w

    end
    
    mse_avg(k,1) = mean(mse(k,:));
    me_avg(k,1) = mean(me(k,:));
    accuracy_avg(k,1) = mean(accuracy(k,:));
    num_ch_avg(k,1) = mean(num_ch(k,:));
    num_c_avg(k,1) = mean(num_c(k,:));
    num_w_avg(k,1) = mean(num_w(k,:));
    
 end
 
 
 