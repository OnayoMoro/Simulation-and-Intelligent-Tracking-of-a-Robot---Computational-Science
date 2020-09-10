%Read in White Noise Results
filename = 'step2.txt';
delimiterIn = ' ';
headerlinesIn = 0;
A = importdata(filename,delimiterIn,headerlinesIn);
input = (A(:, 3));
input = rescale(input);

%Variables
Iterations = 1000;          weights = [];
R = [-0.5 0.5];            data = [];
output = 0;                net_sum = 0;
Inputs_Weights = 3;        error = 0;
learning_Rate = 0.00005;    thresh = 0.5;

j_val = [];

%Initialise weights
for i = 0:Inputs_Weights
    num = rand(1,1)*range(R)+min(R);
    weights = [weights num];
end

%Begin Training
for t = 1:Iterations
    data = [];
    %j_val = [];
    for i = 1:length(input)-Inputs_Weights
        
        %Create Inputs With Bias
        x = 1;
        for q = i:i+Inputs_Weights-1
            if (input(q,1) == 0.0)
                x = [0.000 x];
            else
                x = [input(q,1) x];
            end
        end
        
        %Calculate Net Sum and Output
        net_sum = 0;
        for j = 1:length(x)
            net_sum = net_sum + x(1,j)*weights(1,j);
        end
        
        output = 1/(1 + exp(1)^-net_sum);
        
        data = [data output];
        
        target = input(i+Inputs_Weights,1);
        
        error = target - output;
        
        %Update Weights
        ip = i;
        for o = 1:length(weights)
            delta = learning_Rate * input(ip,1)* error;
            weights(1,o) = weights(1,o) + delta;
            ip = ip+1;
        end
        
    end
    J = 0.5*((error)^2);
    j_val = [j_val J];
end

writematrix( weights, "weights");

data = data';
data = rescale(data);
disp("Iterations: " + Iterations)
disp("Number of Inputs and Weights - Constant: " + Inputs_Weights);
disp("Cost Function After Every Itteration: " + J)

hold on;
plot(input,'DisplayName','Data Set');
plot(data(4:end),'DisplayName','Predictions');
hold off;
legend;
xlabel("Time(Hundredths of a Second)");
ylabel("x(t)")
title("Train: h = 0.01")

if net_sum >= thresh
    output = 1;
else
    output = 0;
end



