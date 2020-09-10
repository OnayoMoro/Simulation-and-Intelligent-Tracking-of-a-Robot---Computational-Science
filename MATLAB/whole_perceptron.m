Inputs_Weights = 3;

h_test = 0.1
h_train = 0.1

create_data(h_train);
train(Inputs_Weights);
create_data(h_test);
test(Inputs_Weights);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Train Data Set
function [] = train(Inputs_Weights)
    %Read in White Noise Results
    filename = 'step2.txt';
    delimiterIn = ' ';
    headerlinesIn = 0;
    A = importdata(filename,delimiterIn,headerlinesIn);
    input = (A(:, 3));
    input = rescale(input);

    %Variables
    Iterations = 200;          weights = [];
    R = [-0.5 0.5];            data = [];
    output = 0;                net_sum = 0;
    error = 0;
    learning_Rate = 0.00001;

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
                x = [input(q,1) x];
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
    data = rescale(data);
    disp("Iterations: " + Iterations)
    disp("Number of Inputs and Weights - Constant: " + Inputs_Weights);
    disp("Cost Function After Every Itteration: " + J)

    hold on;
    plot(input,'DisplayName','Data Set Train');
    plot(data(4:end),'DisplayName','Predictions Train');
    hold off;
    legend;
    xlabel("Time");
    ylabel("x(t)")
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Test Data Set
function [] = test(Inputs_Weights)
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
    Inputs = Inputs_Weights;

    %Begin Testing
    for i = 1:length(input)-Inputs

        %Create Inputs With Bias
        x = 1;
        for q = i:i+Inputs_Weights-1
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
    disp("Number of Inputs and Weights - Constant: " + Inputs);

    hold on;
    plot(input,'DisplayName','Data Set Test');
    plot(data(4:end),'DisplayName','Predictions Test');
    hold off;
    legend;
    xlabel("Time");
    ylabel("x(t)")
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create Data Set
function [] = create_data(h)
    %Step 1 variables
    k = 1;
    x = [];
    x(k) = 0;
    U = 0;
    time = 0.000;
    %h = 0.01;
    count = 0;

    %Adding random numbers variables Step 2
    it = 0;
    S = 0.01;
    M = 0;
    Xn = [];

    %Create txt file for non-noisy numbers Step 1
    fileID1 = fopen('step1.txt', 'w');
    format1 = '%1.2f %1.3f %1.0f\n';

    %Create txt file for noisy numbers Step 2
    fileID2 = fopen('step2.txt','W');
    format2 = '%1.2f %1.3f %1.3f %1.0f\n';

    while time <= 15
        if (0 < time) && (time <= 5)
            U = 2;
        elseif (5 < time) && (time <= 10)
            U = 1;
        elseif (10 < time) && (time <= 15)
            U = 3;
        end

        x(k+1) = x(k)+h*(-2*x(k)+2*U);
        k = k + 1;

        %Write non-noisey results to file Step 1
        fprintf(fileID1, format1, time, x(k), U);

        %Adding Random Numbers Step 2
        if (count == 0)
            count = 1;
            fprintf(fileID2, format2, time, x(k), 0.000, U);
        end
        if (it == 0)
            z1 = 0+rand*(2*pi-0);
            temp1 = 0+rand*(1-0);
            temp = sqrt(-2*log(temp1));
            b = S * temp;
            z2 = b*sin(z1)+M;
            z3 = b*cos(z1)+M;
            Xn = [Xn (x(k) + z2)];

            %Write noisy numbers to file Step 2
            fprintf(fileID2, format2, time, x(k), Xn(k - 1), U);
            it = 1;
        else
            it = 0;
            Xn = [Xn (x(k) + z3)];

            %Write to step 2 file
            fprintf(fileID2, format2, time, x(k), Xn(k - 1), U);

        end
        time = time + h;
    end

    fclose(fileID1);
    fclose(fileID2);
end
