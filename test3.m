% i : no of functions
% j : rank
% k : no of variables
clear all
syms x1 x2 x3 x4 x5 x6;
epsilon = 1e-8;
K = 0;
N = [1,2,3];
UB = Inf;
n = 100;
% f = [6*x1^2-x2^2,
%     -x1^2+x1*x2+x1+x2-4,
%     5*x1^2-x2^2+2*x1*x2+x1-x2+1,
%     -2*x1+x2,
%     x1+x2-8,
%      x1-8,
%     0-x1,
%     0-x2,
%     x2-15];
f = [7*x1^2+6*x2^2-15.8*x1-93.2*x2+8*x3^2-6*x1*x3+4*x2*x3-63*x3,
    9*x1^2+10*x1*x2+8*x2^2+5*x3^2+6*x1*x3+10*x2*x3-1000,
    6*x1^2+8*x1*x2+6*x2^2+4*x3^2+2*x1*x3+2*x2*x3-440,
    9*x1^2+6*x2^2+8*x3^2-2*x1*x2-2*x2*x3-340,
    x1-200,
    1-x1,
    1-x2,
    x2-200,
    1-x3,
    x3-200];
% f=[-16*x1^2-7*x2^2-18*x1+12*x2,
%     6*x1-x2-100,
%     x1+2*x2-150000,
%     x1-99999,
%     0-x1,
%     0-x2,
%     x2-99999];
all_symbols = symvar(f(1));
no_of_fun = length(f);
no_of_var = length(all_symbols);
r = zeros(no_of_fun,1);
for i=1:no_of_fun
    r(i) = rank(f(i));
end
%%
[a,b,c,d] = EIQQP(f,r,no_of_var,no_of_fun,all_symbols);
%%
x = zeros(no_of_var,2);
for i=2:no_of_fun
    only = 1;
    for j=1:no_of_var
        if c(j,i) ~=0
            for k=1:no_of_var
                if k~=j && c(k,i) ~= 0
                    only = 0;
                    break
                end
            end
            if only
                if x(j,1)==0
                    x(j,1)=d(i-1);
                else
                    x(j,2)=d(i-1);
                end
            end
        end
    end
end

for i=1:length(x)
    x(i,:)=sort(x(i,:));
end
Set{1} = x;
%%
LRQQPResult = LRQQP(no_of_var,no_of_fun,a,b,c,d,r,x);
%%
x0 = LRQQPResult(1:end-1,1);
%%
feasible = feasibility(f,x0,d,N);
if feasible
    disp('first feasible');
    disp(x0);
    disp(findLB(f(1),x0));
else
    LB = findLB(f(1),x0);
    UB = findUB(UB,LB,N,f,x,x0,d,no_of_var);
    if UB-LB<epsilon
        disp('first check');
        disp(UB);
    else
        [X,XX] = branch(cell2mat(Set(1)),N,no_of_var);
        Set{1} = X;
        Set{2} = XX;
        for i=1:length(Set)
            x = cell2mat(Set(i));
            LRQQPResult = LRQQP(no_of_var,no_of_fun,a,b,c,d,r,x);
            if ~isempty(LRQQPResult)
                x0 = LRQQPResult(1:end-1,1);
                feasibile = feasibility(f,x0,d,N);
                if feasibile
                    LBk = findLB(f(1),x0);
                    if LBk <= UB - epsilon
                        if LBk < LB
                            LB = LBk;
                        end
                        UB = findUB(UB,LB,N,f,x,x0,d,no_of_var);
                        if UB-LB<=epsilon
                            disp('second check');
                            K
                            disp(UB); 
                            break
                        else
                            disp('here');
                            K=K+1;
                            [X,XX] = branch(x,N,no_of_var)        
                            Set{end+1} = X;
                            Set{end+2} = XX;
                        end
                    end
                end
            end
        end
    end
end
