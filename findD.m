function d=findD(f,symbols)
    if length(symbols) == 1
        if subs(f,0)==0
            d = 0;
        else
            c = children(f);
            if double(subs(c(1),1)) < 0
                d = double(c(2));
            else
                d = -1*double(c(2));
            end
        end
    else
        d = subs(f,0);
        for i=2:length(symbols)
            d= subs(d,0);
        end
        d = -1*double(d);
    end
end