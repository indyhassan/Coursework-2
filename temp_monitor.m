%kjdfgndfjvbkfdjvb

clear

a = arduino('COM3','UNO') ;

v0 = 0.5 ;         
Ct = 0.01 ;

time_array = [] ;
temp_array = [] ;

for time = 1:inf    

    v_out = readVoltage(a,'A1') ;
    temp = ( v_out - v0 ) / Ct ;

    time_array(end+1) = time ;
    temp_array(end+1) = temp ;

    plot(time_array, temp_array) ;  % time and temp plot 
    xlabel('Time (s)') ; % x and y axis labelled
    ylabel('Temperature (°C)') ;
    title('Temperature Monitor')

    xlim([time-15 time+15]); % x axis gives a range of values for the past 8s and an added second
    ylim([15, 30]); % variable y axis shown from 15C to 30C
    grid on; % grid for graph activated 
  
    drawnow 
   
    if (18 <= temp) && (temp<= 24) 
        writeDigitalPin(a, 'D10', 1);
        pause(1)
    elseif temp < 18
        writeDigitalPin(a, 'D10', 0);    
        writeDigitalPin(a, 'D9', 1);  
        pause(0.5);                   
        writeDigitalPin(a, 'D9', 0);   
        pause(0.5);
    elseif temp > 24 
        writeDigitalPin(a, 'D10', 0);
        writeDigitalPin(a, 'D8', 1);  
        pause(0.25);                   
        writeDigitalPin(a, 'D8', 0);  
        pause(0.25);
        writeDigitalPin(a, 'D8', 1);  
        pause(0.25);                   
        writeDigitalPin(a, 'D8', 0);  
        pause(0.25);  
    end 

    
end







