%Function is used to collect the voltage from the arduino and find
%temperature, rate of change of temperature during the entire proccess.
%Rate of change of temperature is then used to predict the temperature in 5
%minutes if rate of change is constant. 
%Also used to find if the temperature will be greater or less than 4
%degrees in one minute if the rate of change of temperature is constant.
%This is then submitted to an LED, depending on the colour represnts the
%temperature.
%Function returns the temperature, rate of change prediction of temperature
%in 5 minutes and 1 minute to store in arrays,

function [Temperature,RoC,Prediction,prediction60] = temp_prediction (a,x,AV,Time,Temperature,RoC,Prediction,prediction60)
%Arduino paramters
Tc = 0.01; %Temperature coefficient
V0 = 0.5; %Voltage at zero degrees


%Equation to calculate the temperature and store it into an array
Temperature(x) = (AV(x) - V0)/Tc;

%establishing the first rate of change of temperature
RoC(1) = 0;

%Establishing first temperature in the next 5 minutes
Prediction(1) = Temperature(1);

%If statement used to calculate the rate of change and prediciton in 5 minutes depending on how many
%volatge values are stored
if length(AV) > 1

%for loop used to calculate he rate of change and prediciton in 5 minutes depending on how many
%volatge values are stored
    for b = length(AV)

    %Equation used to find the next Rate of change of temperature and store it into an array    
    RoC(b) = (Temperature(b) - Temperature(1))/(Time(b)/Time(1));

    %Prediciting the temoerature in 5 minutes
    Prediction(b) = (RoC(b) * 300) + Temperature(b);
    end
end

%Equation used to see of the prediction is either +/-4 degrees a minute
prediction60(x) = RoC(x) * 60;


%if statement used to control LED;s dpending on the prediction is either +/-4 degrees a minute
if prediction60(x) >= 4
        writeDigitalPin(a,'D13',0); %Turn Green LED off
        writeDigitalPin(a,'D12',0); %Turn yellow LED off
        writeDigitalPin(a,'D11',1); %Turn Red LED on
elseif prediction60(x) <= -4
        writeDigitalPin(a,'D13',0); %Turn Green LED off
        writeDigitalPin(a,'D12',1); %Turn yellow LED on
        writeDigitalPin(a,'D11',0); %Turn Green LED off
else
        writeDigitalPin(a,'D13',1); %Turn Green LED on
        writeDigitalPin(a,'D12',0); %Turn yellow LED off
        writeDigitalPin(a,'D11',0); %Turn Green LED off
end