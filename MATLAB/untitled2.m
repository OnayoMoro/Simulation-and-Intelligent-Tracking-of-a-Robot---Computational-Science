%Read in White Noise Results
filename = 'step2.txt'; 
delimiterIn = ' ';
headerlinesIn = 0;
A = importdata(filename,delimiterIn,headerlinesIn);
input1 = [];
input1 = [input1 (A(:, 3))];
%b = zeros(1,1);
input = [input1];

%Initialise the weights and threshold value for the given two inputs
weights = [];
R = [-0.5 0.5];
Threshold = rand(1,1)*range(R)+min(R);
for i = 0:2
    weights = [weights (rand(1,1)*range(R)+min(R))];
end

%start the perceptron
J = 1;
output = 0;
learning_Rate = 0.0001;
data = [];
Error = 0;
for r = 0:10
    for i = 1:length(input) -2
        x = [input(i) input(i + 1) 1];
        %Simulating the Perceptron
        net_sum = 0;
        for j = 1:length(x)
            net_sum = net_sum + x(j) * weights(j);
        end
        % Calculate the sigmoid ouput for the given net_sum calculated
        % whilst simulating the perceptron
        output = 1/(1 + (exp(1) ^ -net_sum));

        %Calculating the error of the perceptron
        data = [data (net_sum)];
        Target = input(i + 2);
        Delta = Target - net_sum;
        for k = 1:length(weights)
            weights(k) = weights(k) + (learning_Rate * Delta * x(k));
        end
        Error = Delta;
        J = 0.5 * ((Error)^2);
    end
end

disp(J)