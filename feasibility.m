function feasible=feasibility(f,x,d,N)
    feasible = 1;
    %integer check
    for i=1:length(N)
        if rem(x(N(i)),1) ~=0
            feasible = 0;
        end
    end
    for i=2:length(f)
        result = subs(f(i),x(1));
        for j=2:length(x)
            result = subs(result,x(j));
        end
        result = double(result);
        if result > 0
            feasible = 0;
            break
        end
    end
end