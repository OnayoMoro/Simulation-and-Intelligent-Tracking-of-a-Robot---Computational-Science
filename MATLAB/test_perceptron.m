%Read in White Noise Results
filename = 'step2.txt';
delimiterIn = ' ';
headerlinesIn = 0;
A = importdata(filename,delimiterIn,headerlinesIn);
input = (A(:, 3));
input = rescale(input);

%Read in Weights
filename = 'weights.txt';
delimiterIn = ',';
headerlinesIn = 0;
weights = importdata(filename,delimiterIn,headerlinesIn);

%Variables            
data = [];      net_sum = 0;
Inputs = length(weights)-1;              
       
%Begin Testing
for i = 1:length(input)-length(weights)
    
    %Create Inputs With Bias
    x = 1;
    for q = i:i+Inputs-1
        x = [input(q,1) x];
    end
    
    %Calculate Net Sum
    net_sum = 0;
    for j = 1:length(x)
        net_sum = net_sum + x(1,j)*weights(1,j);
    end
    
    data = [data net_sum];
    
end
data = rescale(data);
disp("Number of Inputs and Weights Without Constant: " + Inputs);

hold on;
plot(input,'DisplayName','Data Set');
plot(data(4:end),'DisplayName','Test Predictions');
hold off;
legend;
xlabel("Time(Hundredths of a Second)");
ylabel("x(t)")
title("Test: h = 0.01");


