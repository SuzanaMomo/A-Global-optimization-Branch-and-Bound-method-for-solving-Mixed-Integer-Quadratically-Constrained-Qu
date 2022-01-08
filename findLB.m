function LBk = findLB(f,x0)
    LBk = subs(f,x0(1));
    for i=2:length(x0)
        LBk = subs(LBk,x0(i));
    end
    LBk = double(LBk);
end
