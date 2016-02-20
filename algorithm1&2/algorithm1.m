%% Algorithm 1 - Take the averages of the signal for each time slot, 
% predefined and estimates if the decission made was correct or wrong

clear, clc

load('data.mat');

thr = -110;             % Threshold value for decission make
time_frame = 100;       % Time slot for decission
nspms = 10;
m = 1;

% Randomize the starting point
[data] = rnd_start(meas_macro_dbm,m);

% Decisions
avrg_data = averaging(data, time_frame, nspms);

decision = zeros(1,length(avrg_data));      % 0 -> Resources from pico station not available
                                            % 1 -> Resources from pico
                                            % station available                                    
for i=1:length(avrg_data)
    if(avrg_data(i) < thr)
        decision(i) = 1;
    end
end


% Performance is checked. We check always how many sample values are
% correct

% Number of times the mode changes
num_ch = num_changes(decision);

% Accuracy of the algorithm. Number of correct and wrong decisions. For
% wrong decisions MSE is obtained

N = length(decision)-1;
num_c = 0;
num_w = 0;

for j=1:N
    
    for i= j*(time_frame/nspms)+1 : (time_frame/nspms)*(j + 1)
    
        if((decision(j) == 1 && data(i) < thr) || (decision(j) == 0 && data(i) > thr))
            num_c = num_c + 1;
        else
            num_w = num_w + 1;
            pos_w(num_w) = i;
        end
        
    end
    
end

accuracy = (num_c/(num_c + num_w))*100;

% Mean Square Error
mse = mean((data(pos_w) - thr).^2);

str1 = ['Accuracy of the algorithm: ', num2str(accuracy)];
str2 = ['Number of mode changes: ', num2str(num_ch)];
str3 = ['Number of signal samps correct: ', num2str(num_c)];
str4 = ['Number of signal samps wrong: ', num2str(num_w)];
str5 = ['MSE: ', num2str(mse)];
disp(str1);
disp(str2);
disp(str3);
disp(str4);
disp(str5);
