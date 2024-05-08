
%Function used to collect the voltage from arduino and find the
%temperature. Use of LED's shows if the temperature is above 24 degrees or
%below 18 degrees
function [Temperature] = temp_monitor (a,AV)
    
    %Temperature coefficient
    Tc = 0.01;

    %Zero voltage level
    V0 = 0.5;

    %Equation used to find the temperature at given voltage
    Temperature = (AV - V0)/Tc;

    %if statement used to turn on LED's depending on the temperature

    if (18<=Temperature) && (Temperature<=24) %Temperature is between 18 and 24 degrees

        %Connection to the LED's
        writeDigitalPin(a,'D13',1); %Turn green LED on
        writeDigitalPin(a,'D12',0); %Turn Red LED off
        writeDigitalPin(a,'D11',0); %Turn Yellow LED off
    
    elseif Temperature < 18 %Temperature is below 18 degrees
        writeDigitalPin(a,'D13',0); %Turn green LED off
        writeDigitalPin(a,'D11',0); %Turn Red LED off
        writeDigitalPin(a,'D12',1); %Turn yellow LED on
        pause(0.5) %Wait 0.5 seconds
        writeDigitalPin(a,'D12',0); %Turn yellow LED off
        pause(0.5) %Wait0.5 seconds
  
    else %If temperature is greater than 24 degrees
        writeDigitalPin(a,'D13',0); %Turn Green LED off
        writeDigitalPin(a,'D12',0); %Turn Yellow LED off
        writeDigitalPin(a,'D11',1); %Turn red LED on
        pause(0.25) %Wait 0.25 seconds
        writeDigitalPin(a,'D11',0); %Turn Red LED off
        pause(0.25) %Wait 0.25 seconds 
    end
end

    