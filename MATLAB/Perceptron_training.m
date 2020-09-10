classdef Perceptron_training
    methods 
        
        %Start
        function start(obj)
            %Variables                      
            net_sum = 0;                    
            weights = [];                   
            thresh = 0.5;                       
            J = 0;                          
            output_sig = 0;                 target = 0;
            %output_step = 0;               
            error = 0;                      %Both Error & Delta
            learning_Rate = 0.0001;           Itterations = 10;
            bt = 1; %Bias Term          
            data = [];
            x = [];
            
            %Read in White Noise Results
            filename = 'step2.txt'; 
            delimiterIn = ' ';
            headerlinesIn = 0;
            A = importdata(filename,delimiterIn,headerlinesIn);
            input = (A(:, 3));
            
            %Initialise Weights
            weights = init_weights(obj, thresh, weights);
            
            %Begin Training
            for a = 1:Itterations
                data = [];
                for i = 1:length(input)-3
                    x = [];
                    for q = i:i+2
                       x = [x input(q,1)]; 
                    end
               
                    [output_sig, data] = perceptron(obj, net_sum, weights, output_sig, bt, thresh, data, x);
                    %[output_step, data] = perceptron(obj, net_sum, x1, x2, x3, weights, output_step, bt, thresh, data, x);
               
                    %Calculate Error
                    target = input(i+3,1);
                    error = abs(target - data(1,i));
                    ip = i;
                    for j = 1:length(weights)
                        delta = learning_Rate * input(ip,1)* error;
                        weights(1,j) = weights(1,j) + delta;
                        ip = ip+1;
                    end
                    
                    %Cost Function
                    J = 0.5*((error)^2);
                end
            end
            disp("Cost Function: "+J);
        end

        %Perceptron
        function [output, data] = perceptron(obj, net_sum, weights, output, bt, thresh, data, x)
            net_sum = 0;
            for i = 1:length(x)
               net_sum = net_sum + x(1,i)*weights(1,i); 
            end
            net_sum = net_sum + (bt*weights(1,4));
            data = [data net_sum];
            output = abs((log_sig(obj, net_sum)));
            %output = [output (act(obj, net_sum, thresh))];
            %data = [data output];
        end
        
        %Logistic Sigmoid
        function [output] = log_sig(obj, net_sum)
            output = 1/(1 + exp(1)^-net_sum);
        end
        
        %Activation
        function [output] = act(obj, net_sum, thresh)
            if net_sum >= thresh
                output = 1;
            else
                output = 0;
            end
        end
        
        %Initialise Weights for Perceptron
        function [weights] = init_weights(obj, thresh, weights)
            for i = 0:3
                R = [-0.5 0.5];
                num = rand(1,1)*range(R)+min(R);
                weights = [weights num];
            end
        end
    end
end