function [X,XX]=branch(x,N,no_of_var)
    t = 1;
    x_copy = x;
    X = zeros(no_of_var,2);
    XX = zeros(no_of_var,2);
    for i=1:no_of_var
        if ismember(i,N)
            x(i,1) = ceil(x(i,1)) + 1;
            x(i,2) = floor(x(i,2));
        end
        if x(i,2) - x(i,1) > x(t,2) - x(t,1)
            t = i;
        end
    end
    mid = (x_copy(t,2) - x_copy(t,1))/2;
    if ismember(t,N)
        for i=1:no_of_var
            if i==t
                X(i,1) = x_copy(i,1);
                X(i,2) = min(x(i,2),floor(mid));
                XX(i,1) = max(x(i,1),ceil(mid));
                XX(i,2) = x_copy(i,2);
            else
                X(i,1) = x(i,1);
                X(i,2) = x(i,2);
                XX(i,1) = x(i,1);
                XX(i,2) = x(i,2);
            end
        end
    else
        for i=1:no_of_var
            if i==t
                X(i,1) = x_copy(i,1);
                X(i,2) = mid;
                XX(i,1) = mid;
                XX(i,2) = x_copy(i,2);
            else
                X(i,1) = x(i,1);
                X(i,2) = x(i,2);
                XX(i,1) = x(i,1);
                XX(i,2) = x(x,2);
            end
        end
    end
end