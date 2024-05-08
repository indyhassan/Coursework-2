% Indigo Hassan
% egyih5@nottingham.ac.uk

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]
clear

% GitHub:
% - GitHub repository created "Matlab-Coursework-2"
% - Repository linked with matlab coursework working folder
% - Implemented version control for this .m file
% - Changes commited to repository at end of sessions

% Arduino Communication: Establishes communication between MATLAB and Arduino through variable a
a = arduino('COM3','UNO');	 
% 'COM3 = port the Arduino is connected to, 'UNO' = type of Arduino

for i = 1:10                      % For loop with 10 iterations 
    writeDigitalPin(a, 'D9', 1);  % Turns LED on, with the defined arduino used, a, and D9 as the connected digital bus
    pause(0.5);                   % Keeps LED on for half a second
    writeDigitalPin(a, 'D9', 0);  % Turns LED off 
    pause(0.5);                   % keeps LED off for half a second
end                               % Repeats process to blink at 0.5s intervals

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
clear

a = arduino('COM3','UNO') ; % Establish communication with Arduino through variable a 

duration = 0:600 ;   % Acquisition time, created as an array, from 0 to 600 seconds (10 minutes)
v0 = 0.5 ;           % 'v0', V = Output voltage at 0 C (500mV)
Ct = 0.01 ;          % Ct, V = Temperature coefficient (10mv/C)
temp_array = [] ;    % Creates an empty array to add temperature values during data acquisition - used for finding min, max, mean temperatires + printing data in cabin_temperature file.

% This section displays date and location using sprintf command using string 'date_location'
date = ('06/05/2024') ;      
location = ('Nottingham') ;
date_location = sprintf("Data logging initiated - %s \nLocation - %s \n\n", date, location) ; % use of \n to create new lines
disp(date_location)

% Data acquisition section: 
for t = duration                  % t increases by 1 each iteration (due to pause(1)) and can be seen as the second in the data acquisition duration.
                                  % Loop will continue to iterate though the 'duration' stopping at 600
    v_out = readVoltage(a,'A1') ; % 'v_out' = Voltage output from sensor read using readVoltage, specifying arduino 'a' and analog port
    temp = ( v_out - v0 ) / Ct ;  % 'temp' = Ambient temperature - found using equation v_out = (Ct * temp) + v0
    temp_array(end+1) = temp ;    % temp_array is added to with a new temperature each iteration

    % This section in the loop displays data in real time each minute
    minute = t/60 ;               % Create a variable that defines the minute - t(second) / 60
    if floor(minute) == minute    % If the minute is an integer (minutes 0 -> 10 are the only integers in the sequence)
        min_and_temp = sprintf("Minute         %g \nTemperature    %4.2f C \n\n", minute, temp) ; 
        disp(min_and_temp) ;      %  % string 'min_and_temp' displays the temperature at x minute in correct format
    end
        
    pause(1)                      % loop is paused for 1 second  
end

% This section will find the minimum, maximum and average temperatures from 'temp_array' using 'min' 'max' 'mean' functions
temp_max = max(temp_array) ;      
temp_min = min(temp_array) ;
temp_mean = mean(temp_array) ;
temp_range = sprintf("Max temp       %4.2f C \nMin temp       %4.2f C \nAverage temp   %4.2f C \n\nData logging terminated", temp_max, temp_min, temp_mean) ; 
disp(temp_range) % Temperature data is displayed using string ' temp_range' in correct format with the use of \n

% This section creates a graph with time ('duration') and Temperature ('temp_array') on the y axis
graph = plot(duration, temp_array) ; 
 title('Temperature against Time')
 xlabel('Time(s)')
 ylabel('Temperature(°C)')

% This section opens 'cabin_temperature.txt', prints formated data and closes 'cabin_temperature.txt'
file_identifier = fopen('cabin_temperature.txt', 'w') ; % File identifier (FileID) opens file 'cabin_temperature.txt', 'w' permits writing

% Using 'fprintf' and the file identifier, date and location is printed to the file
fprintf(file_identifier, "Data logging initiated - %s \nLocation - %s \n\n", date, location) ;

% Using 'fprintf' and the file identifier, Minute and Temperature is printed to the file
temps_at_min0to10 = temp_array([1, 61, 121, 181, 241, 301, 361, 421, 481, 541, 601]) ;% Temperatures at specific minutes (0-10) are taken from 'temp_array' and put into a new array ' temps_at_min0to10'
minutes_0to10 = 0:10 ; % An array of the minutes (0 to 10) being printed is created 
for index = 1:length(minutes_0to10) % This loop iterates through the two arrays, in order to match the minute to the temperature, and prints the minutes and temperatures.
   fprintf(file_identifier, "Minute         %g \nTemperature    %4.2f C \n\n", minutes_0to10(index), temps_at_min0to10(index)) ;  
end

% Using 'fprintf' and the file identifier, the mean, max and average temperatures are printed to the file
fprintf(file_identifier,"Max temp       %4.2f C \nMin temp       %4.2f C \nAverage temp   %4.2f C \n\nData logging terminated", temp_max, temp_min, temp_mean) ; 

% The file is closed through specifying the file identifier and printing is stopped.
fclose(file_identifier) ;
%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
clear 

% 1) Preliminary flow chart submitted into repository

% 2) temp_monitor.m contains a function 'temp_monitor'

% - Calling the function 
temp_monitor(arduino('COM3','UNO'), 0.5, 0.01, [], []) %(function temp_monitor(a, v0, Ct, time_array, temp_array))
% (a, v0, Ct, time_array, temp_array) are inputs for the function. i.e 'a' = arduino('COM3','UNO')

%% 
% 3) Documentation
doc temp_monitor

% 4) Final flow chart submitted into repository

%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]
clear

% Preliminary flow chart submitted into repository

% temp_prediction.m contains a function 'temp_prediction'
temp_prediction(arduino('COM3','UNO'), 0.5, 0.01) % - Calling the function 
% (a, v0, Ct) are inputs for the function

%%
% temp_prediction documentation
doc temp_prediction

%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here