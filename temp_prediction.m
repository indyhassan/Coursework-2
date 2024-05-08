% Documentation:
% This function aims to monitor and display the change rate of temperature
% by giving an estimate of the temperature 5 minutes into the future - ultimatly 
% allowing the cabin to be conditioned correctly for passenger comfort.
% - A green light will show when temperature change is steady and safe.
% - A yellow light will show when the temperature is dropping at unsafe levels
% - A red light will show when the temperature is rising at unsafe levels

function temp_prediction(a, v0, Ct) % Creating a function called 'temp_prediction' and listing inputs

temp_array = [] ;  % Creating empty arrays to add temperature and time values during data acquisition
time_array = [] ;

for time = 1:inf    % Loop will follow 'time' 1 to infinity 

% MONITORING SECTION

    v_out = readVoltage(a,'A1') ; % 'v_out' = Voltage output from sensor read using readVoltage, 'a' is an input and should be the arduino
    temp = ( v_out - v0 ) / Ct ; % 'temp' = Ambient temperature - found using equation v_out = (Ct * temp) + v0

    time_array(end+1) = time ;  % Empty time and temp arrays are added upon each iteration to find changes in temp and time
    temp_array(end+1) = temp ;

% DISPLAYING SECTION
    
   % Rate of change can not be found on the first data point, so temperature is printed, and loop is continued to next iteration after a 1s pause 
    if time<2 
        fprintf('Time: %g s\nTemperature                             %4.2f C \nEstimate for temperature in 5 minutes   - C\n\n', time, temp) ;
        pause(1)
        continue
    end
 
   % When finding change rate of temp, I chose to use 30s as change in time. For any temperature taken up to 30s, the change in
   % time will be equal to the time which has passed -1 (as there is no temperature at time=0)
    if time>=2 && time<=30 
        d_time = time-1 ;  % d_time is the change in time, and is used to find rate of temperature change.
    else 
        d_time = 30 ;   
    end
    
    d_temp = temp - temp_array(end-d_time) ; % change in temperature = current temperature - temperature 30s (or any other d_time) ago
    temp_change_rate_s = d_temp / d_time ;  % Temperature change rate in seconds = change in temp / change in time

    fivemin_temp = temp + 300*temp_change_rate_s ; % Temperature in 5 minutes = Current temp + 300 (300 seconds) * Temperature change rate
     
   % Printing time, current temperature and 5 min estimate temparature using fprintf 
    fprintf('Time: %g s\nTemperature                             %4.2f C \nEstimate for temperature in 5 minutes   %4.2f C\n\n', time, temp, fivemin_temp) ;

% LED SECTION    
    
    temp_change_rate_m = temp_change_rate_s * 60 ; % Converting temperature change rate from seconds to minutes 

    if temp_change_rate_m <= 4 && temp_change_rate_m >= -4 % If temperature change rate is safe 
        writeDigitalPin(a, 'D10', 1);                      % Turn on green LED    (green = digital port 10)
        writeDigitalPin(a, 'D9', 0);                       % Turn off yellow LED  (yellow = digital port 9)
        writeDigitalPin(a, 'D8', 0);                       % Turn off red LED     (red = digital port 8)
    elseif temp_change_rate_m < -4                         % If temperature is declining too fast
        writeDigitalPin(a, 'D10', 0);                      % Turn off green LED
        writeDigitalPin(a, 'D9', 1);                       % Turn on yellow LED
        writeDigitalPin(a, 'D8', 0);                       % Turn off red LED
    elseif temp_change_rate_m > 4                          % If temperature is increasing too fast
        writeDigitalPin(a, 'D10', 0);                      % Turn off green LED
        writeDigitalPin(a, 'D9', 0);                       % Turn off yellow LED
        writeDigitalPin(a, 'D8', 1);                       % Turn on red LED
    end          

    pause(1)                                     % The cycle will equal 1 second 
end

end
