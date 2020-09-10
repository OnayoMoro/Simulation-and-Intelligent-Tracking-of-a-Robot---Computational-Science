function Init_weights = Perceptron_training  
            thresh = (-0.5+rand*(0+5));
            w = [];
            net_sum = 0;
            
            for i = 0:2
                %net_sum = net_sum + input*init_weights[i]
                w = [w (-0.5+rand*(0+5))];
                disp(i)
                disp(w)
                disp(thresh)
            end
        end