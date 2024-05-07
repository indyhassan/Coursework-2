% Documentation:
% This functions primary aim is to provide a visual aid to keep passangers comfortable in a cabin. It does this by: 
% 1) Monitoring and ploting temperature over time. 
%   - A motion graph displays the cabins temperature over time and should be used as visual aid to see change in temperature.  
% 2) Light/blink a green, red or yellow LED light to display which temperature range the cabin is in. 
%   - A constant green light -> Temperature is between 18°C and 24°C - safe and comfortable range. 
%   - A slow blinking yellow light: Temperature is below 18°C - cabin is too cold.
%   - A fast blinking red light: Temperature is above 24°C - cabin is too hot. 

function temp_monitor(a, v0, Ct, time_array, temp_array) % Creating a function called 'temp_monitor' and listing inputs

for time = 1:inf    % Loop will follow 'time' 1 to infinity 

    % Monitoring

    v_out = readVoltage(a,'A1') ; % 'v_out' = Voltage output from sensor read using readVoltage, 'a' is an input and should be the arduino
    temp = ( v_out - v0 ) / Ct ; % 'temp' = Ambient temperature - found using equation v_out = (Ct * temp) + v0

    % Plotting

    time_array(end+1) = time ; % Empty time and temp arrays ar added upon each iteration to plot a live graph
    temp_array(end+1) = temp ;

    plot(time_array, temp_array) ;  % Time (x axis) and temperature (y axis) plot 
    xlabel('Time (s)') ;            % x axis labelled
    ylabel('Temperature (°C)') ;    % y axis labelled
    title('Temperature Monitor')    % Graph given title 

    xlim([time-15 time+15]); % x axis range spans from the previous 15 seconds to future 15 seconds
    ylim([15, 30]);          % y axis shows a range of 15C to 30C
    grid on;                 % Displays grid on graph 
  
    drawnow                  % Will plot the most recent time and temperature onto the graph

    % LED section
   
    if (18 <= temp) && (temp<= 24)      % Is the temperature safe?
        writeDigitalPin(a, 'D10', 1);   % Yes - turn on Green LED (green LED connected to digital channel 10)
        pause(1)                        % Pause iteration for 1s, return to monitoring
                         
    elseif temp < 18                    % Is temperature too cold?
        writeDigitalPin(a, 'D10', 0);   % Turn off green light if on 
        writeDigitalPin(a, 'D9', 1)     % Blink yellow LED at 0.5 intervals (yellow LED connected to digital channel 9)     
        pause(0.5);                     % Two 0.5s pause make up a 1s pause - continue to monitoring
        writeDigitalPin(a, 'D9', 0);    
        pause(0.5);
    elseif temp > 24                    % Is temperature too hot?
        writeDigitalPin(a, 'D10', 0);   % Turn off green light if on 
        writeDigitalPin(a, 'D8', 1);    % Blink red LED at 0.25 intervals (red LED connected to digital channel 8)     
        pause(0.25);                    % Four 0.25s pauses make up a 1s pause - continue to monitoring
        writeDigitalPin(a, 'D8', 0);  
        pause(0.25);
        writeDigitalPin(a, 'D8', 1);  
        pause(0.25);                   
        writeDigitalPin(a, 'D8', 0);  
        pause(0.25);  
    end 

    
end
end  % Encompasses function






