%% Algorithm 1 - Take the averages of the signal for each time slot, 
% predefined and estimates if the decission made was correct or wrong

clear, clc

load('data.mat');

thr = -110;             % Threshold value for decission make
time_frame = 100;       % Time slot for decission
nspms = 10;             % Number of RSRP samples per milisecond
m = 1000;               % Number of simulations

num_ch = zeros(1, m);                           % Number of times the mode changes
num_c = zeros(1,m);
num_w = zeros(1,m);
accuracy = zeros(1,m);
mse = zeros(1,m);
                                                
% Randomize the starting point
[data] = rnd_start(meas_pico_dbm,m);

n = floor(length(data)/(time_frame/nspms));     % Number of averages computed
N = n-1;

avrg_data = zeros(m, n);
decisions = zeros(m, n);                        % 0 -> Resources from pico station not available
                                                % 1 -> Resources from pico
                                                % station available

for i=1:m
    
    % Signal is averaged over time_frame ms to make decisions
    avrg_data(i,:) = averaging(data(i,:), time_frame, nspms);
    
    % Make decisions for all generated signals
    [decisions(i,:)] =  make_decision(avrg_data(i,:), thr);
    
    % For each simulation the number of mode changes is stored
    num_ch(i) = num_changes(decisions(i,:));
    
    % Accuracy of the algorithm. Number of correct and wrong decisions. For
    % wrong decisions MSE is obtained
    [num_c(i), num_w(i), pos_w] = performance(data(i,:), decisions(i,:), thr, time_frame, nspms);
    
    accuracy(i) = (num_c(i)/(num_c(i) + num_w(i)))*100;
    
    % Mean Square Error
    mse(i) = mean((data(i,pos_w) - thr).^2);
    
    clear pos_w;
     
end



str1 = ['Accuracy of the algorithm: ', num2str(mean(accuracy))];
str2 = ['Number of mode changes: ', num2str(mean(num_ch))];
str3 = ['Number of signal samps correct: ', num2str(mean(num_c))];
str4 = ['Number of signal samps wrong: ', num2str(mean(num_w))];
str5 = ['MSE: ', num2str(mean(mse))];
disp(str1);
disp(str2);
disp(str3);
disp(str4);
disp(str5);
