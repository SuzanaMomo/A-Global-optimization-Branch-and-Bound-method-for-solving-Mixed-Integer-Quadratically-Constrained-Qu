function [a,b,c,d] = EIQQP(f,r,no_of_var,no_of_fun,all_symbols)
    a = zeros(no_of_var,max(r),no_of_fun);
    b = zeros(no_of_var,max(r),no_of_fun);
    c = zeros(no_of_var,no_of_fun);
    d = zeros(no_of_fun-1,1);
    for i=1:length(f)
        if i==1
            [Q,c0] = findQ(f(i),all_symbols,no_of_var);
            [V,D] = eig(Q);
            for j=1:r(i)
                a(:,j,i) = V(:,j);
                b(:,j,i) = V(:,j);
                c(:,i) = c0;
            end
        else
            sym_list = symvar(f(i));
            max_power = 2;
            for l=1:length(sym_list)
                [list_coeffs, power] = coeffs(f(i),sym_list(l));
                if length(power)>max_power
                   max_power = length(power);
                end
            end
            if max_power>2
                [Q,cc] = findQ(f(i),sym_list,no_of_var);
                [V,D] = eig(Q);
                for j=1:r(i)
                    a(:,j,i) = V(:,j);
                    b(:,j,i) = V(:,j);
                    c(:,i) = cc;
                end
            else
                Q = zeros(no_of_var,no_of_var);
                cc = findC(f(i),sym_list,no_of_var,all_symbols);
                [V,D] = eig(Q);
                for j=1:r(i)
                    a(:,j,i) = V(:,j);
                    b(:,j,i) = V(:,j);
                    c(:,i) = cc;
                end
            end
            dd = findD(f(i),sym_list);
            d(i-1) = dd;
        end
    end
end