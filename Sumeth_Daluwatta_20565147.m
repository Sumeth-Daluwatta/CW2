% Sumeth Daluwatta
%  egysd6@nottingham.ac.uk


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]

a = arduino('COM5','Uno'); %Variable to store type of Ardino and Port used

%for loop used to make LED blink every 0.5 seconds to infinity
for x = 1:10
    writeDigitalPin(a,'D2',1); %Turn LED on
    pause(0.5); %Wait 0.5 seconds
    writeDigitalPin(a,'D2',0); %Turn LED off
    pause(0.5); %Wait 0.5 seconds
end

clear;
%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
doc temp_monitor
% Define communication parameters
a = arduino('COM5','Uno');  % Connect to Arduino Uno on COM5

% Define variables
duration = 600;  % Time in seconds

time = 1:1:duration; %counting the time every second until it has reached the duration set

Tc = 0.01; %Temperature coefficent set by the arduino 
V0 = 0.5; %Zero voltage set by the arduino 

AV = zeros(0,duration); %store the volatge calculated in an array

Temperature = []; %Empty temperature array, which will grow with as temperature is calculated

%for loop that that runs for the length of duration that has been set
for x = 1:duration 
    %Using arduino to find the voltage, "A0" is the connection to arduino
    AV(x) = readVoltage(a , 'A0'); 

    %Calculating the temperature from the the voltage found by arduino
    Temperature = (AV - V0)/Tc; 
end

%Plotting the data
figure;

%Data: Time against the temperature 
plot(time,Temperature)

%X-axis label
xlabel ("Time, Seconds")

%Y-axis label
ylabel ("Temperature, Degrees")

%Defining the original paramters

%Start and end of the loop
Start = 1;
End = 60;

MT = zeros(1,9);
%Defining the date
day = 5; %day
month = 3; %month
year = 2024; %year

%The starting time 
b = 0;

%Storing the data that will be outputed in a txt file
file_one = fopen('cabin_temperature.txt','w');

%Storing the title.date and location into the txt file
fprintf(file_one,'Data logging initiated - %d/%d/%d \nLocation - Nottingham  \n', day,month,year);

%displaying title, date and location into command window
fprintf('Data logging initiated - %d/%d/%d \nLocation - Nottingham  \n\n', day,month,year);

%Storing the first temperature at time of 0 into the txt file
fprintf (file_one,"Miniute: \t\t0  \nTemperature: \t%.2fC\n\n",Temperature(1));

%Displaying the first temperature at time of 0 into the command window
fprintf ("Miniute: \t\t0  \nTemperature: \t%.2fC\n\n",Temperature(1));


%For loop used to show the temperature at 1 minute to 10 minutes
for i = 1:10

    %Used to find the temperature at the next minute
    b = b + 60;

    %Storing the temperature and minute at that temperature in the text
    %file
    fprintf(file_one,"Miniute: \t\t%d \nTemperature: \t%.2fC \n\n",i ,Temperature(b));

    %Displaying the temperature and minute at that temperature into the command window
    fprintf("Miniute: \t\t%d \nTemperature: \t%.2fC \n\n",i ,Temperature(b));
    
end

%Code used to find the max, min and average tmperature during the duration
%that temperature is measured and stored into a text file
fprintf(file_one,"Max Temp: \t\t%.2fC\nMin Temp: \t\t%.2fC\nAverage Temp: \t%.2fC\n",max(Temperature),min(Temperature),mean(Temperature));

%Store final line into text file
fprintf(file_one,"Data Logging terminated");

%Code used to find the max, min and average tmperature during the duration
%that temperature is measured and displayed into command window
fprintf("Max Temp: \t\t%.2fC\nMin Temp: \t\t%.2fC\nAverage Temp: \t%.2fC\n\n",max(Temperature),min(Temperature),mean(Temperature));

%Display final line into command window
fprintf("Data Logging terminated");

%close the file that the data has been stored in
fclose(file_one);


clear;
%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Connect to Arduino Uno on COM5 
a = arduino('COM5','Uno');

%Starting time 
Time = 0;


%Graph to show how the temperature fluctuates with the  time
figure;
x = animatedline; %Line to connect all the point together
b = gca;

%x-axis label
xlabel("Time,Seconds")

%y-axis label
ylabel("Temperature,Degrees")

%Limits on graph in the form of (xlim, x max, ylim, ymax)
axis([0,100,20,30])

%while loop that is used to run indefinitely
while true

    %Used to find the voltage from arduino
    AV = readVoltage(a , 'A0');

    %Function: Temperature are outputs of the function, the voltage and
    %arduino are inputs for function
    [Temperature] = temp_monitor(a,AV);

    %Adding points onto the figure for every temperature measured at the
    %time
    addpoints(x,Time,Temperature)

    %Used to find the next second
    Time = Time + 1;

    %Allows graph to stay, isntead of making a new one every time
    hold on;
end

clear;
%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

% Insert answers here

%Connection from Arduino to computer
a = arduino('COM5','Uno');


%Storing data:

%Duration that code needds to run for into an array
duration = 300;

%Store the voltage from the arduino into an array
AV = zeros(0,duration);

%Store the time at each temperature measured into an array
Time = zeros(1,duration-1);

%Store the rate of change of temperature into an array
RoC = zeros(1,duration);

%Store the predicted temperature in 5 minutes into an array
Prediction = zeros(1,duration);

%Store the temperature measured from the arduino into anarray
Temperature = zeros(1,duration);

%Data to find if the rate of change is +/- 4 degreees a minute. This is
%stored into an array 
prediction60 = zeros(1,duration);

%Starting time identified
Time(1) = 1;

%for loop used to find the temperature, rate of change of temperature, and
%if the temperature is +/-4 degrees a minute for LED's.
for x = 1:duration

    %Find the voltage from arduino
    AV(x) = readVoltage(a , 'A0');
    pause(0.5)

    %function called temp_prediction. Inputs are the arduino, Voltage,
    %Temperature array, Rate of change of temperature array, Prediction of
    %temperature in 5 minutes array, and les array. Output is the
    %Temperature, Rate of change of temperature, prediction of temperature
    %in 5 minutes.
    [Temperature,RoC,Prediction,prediction60] = temp_prediction (a,x,AV,Time,Temperature,RoC,Prediction,prediction60);

    %Print statement Time, the current temperature, temperature prediction in 5
    %minutes
    data = sprintf("Time: %.2fs  \nCurrent Temperature: %.2f Degrees \nTemperature in 5 minutes: %.2f Degrees \n\n" ,Time(x),Temperature(x),Prediction(x));
   
    %Display the print statement
    disp(data)
    
    %Used to find the next time and store it in the array
    Time(x+1) = 1 +Time(x);
    pause(0.5)
end

clear;
%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

%During this Coursework I felt I was very strong in my coding ability.
%Ibelieve this was very strongly reflected in my ability to answer the
%preliminary, first and second question where I was able to quicklyfindany
%problems with my code and fix them accordingly. However, I felt that in
%Q3, I was struggling a lot to find the rate ofchange of temperature.
%However, after some time and researching I finally got my code to work.
%I found connecting the arduini more complicated than writing the code for
%the most part. I spent quite a while on task 1 trying to connect the
%arduino properly so I didn't have very high temperature. Furthermore, in
%task 2, I found it diffult to connect it to the LED's and therminstor
%withour running out of jumper cables. Netherless, after quite a bit of
%research I found a way to put them together for them to finally work. 
% Since I had to do some research to find what to do, it also helped me
% runmy code better.
%My code mostly has afew parts that repeat that repeats very often 
% (a = arduinio, find the voltage,calcualting the temperature), so if
%I had a specific part that could run that instead of writing that out in
%every individual piece it would help save some time.