function ub=findUB(UB,LBk,N,f,x,x0,d,no_of_var)
    if isempty(N)
        ub = min(UB,LBk);
    else
        xmid = zeros(no_of_var,1);
        for i=1:no_of_var
            if ismember(i,N)
                xmid(i) = ( ceil(x(i,1))+1 + floor(x(i,2)) )/2;
            else
                xmid(i) = x0(i);
            end
        end
        disp(x0);
        UB1 = Inf;
        UB2 = Inf;
        feasible = feasibility(f,xmid,d,N);
        if feasible
            UB1 = subs(f(1),xmid(1));
            for i=2:length(xmid)
                UB1 = subs(UB1,xmid(i));
            end
            UB1 = double(UB1);
        end
        feasible = feasibility(f,x0,d,N);
        if feasible
            UB2 = subs(f(1),x0(1));
            for i=2:length(x0)
                UB2 = subs(UB2,x0(i));
            end
            UB2 = double(UB2);
        end
        UB12min = min(UB1,UB2);
        ub = min(UB,UB12min);
    end
end