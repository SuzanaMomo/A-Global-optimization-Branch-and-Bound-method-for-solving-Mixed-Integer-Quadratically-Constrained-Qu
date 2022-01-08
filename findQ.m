function [Q,c0] = findQ(f,symbols, no_of_var)
    Q = zeros(no_of_var,no_of_var);
    c0 = zeros(no_of_var,1);
    for i=1:length(symbols)
        [list_coeffs, power] = coeffs(f,symbols(i));
        if length(power) == 3
            Q(i,i) = double(list_coeffs(1));
            try
                val = double(list_coeffs(2));
                c0(i) = val;
            catch
                sub_sym = symvar(list_coeffs(2));
                val = subs(list_coeffs(2),0);
                for j=2:length(sub_sym)
                    val = subs(val,0);
                end
                c0(i) = double(val);
            end
        else
            val = double(subs(list_coeffs(1),0));
            c0(i) = val;
        end
    end
    for i=1:length(symbols)
        for j=i+1:no_of_var
            list = flip(coeffs(f,[symbols(i) symbols(j)]));
            try 
                if ~ismember(double(list(2)),c0)
                    val = double(list(2))/2;
                    Q(i,j) = val;
                    Q(j,i) = val;
                end
            catch   
            end
        end
    end
end