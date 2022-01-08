function linprogResult = LRQQP(no_of_var,no_of_fun,a,b,c,d,r,x)
    l = zeros(no_of_fun,max(r));
    u = zeros(no_of_fun,max(r));
    L = zeros(no_of_fun,max(r));
    U = zeros(no_of_fun,max(r));
    for i=1:no_of_fun
        for j=1:r(i)
%             sum = 0;
            for k=1:no_of_var
%                 sum = sum + min(a(k,j,i)*x(k,1),a(k,j,i)*x(k,2));
                l(i,j) = l(i,j) + min(a(k,j,i)*x(k,1),a(k,j,i)*x(k,2));
            end
%             l(i,j) = sum;
        end
    end

    for i=1:no_of_fun
        for j=1:r(i)
%             sum = 0;
            for k=1:no_of_var
%                 sum = sum + max(a(k,j,i)*x(k,1),a(k,j,i)*x(k,2));
                u(i,j) = u(i,j) + max(a(k,j,i)*x(k,1),a(k,j,i)*x(k,2));
            end
%             u(i,j) = sum;
        end
    end

    for i=1:no_of_fun
        for j=1:r(i)
%             sum = 0;
            for k=1:no_of_var
%                 sum = sum + min(b(k,j,i)*x(k,1),b(k,j,i)*x(k,2));
                L(i,j) = L(i,j) + min(b(k,j,i)*x(k,1),b(k,j,i)*x(k,2));
            end
%             L(i,j) = sum;
        end
    end

    for i=1:no_of_fun
        for j=1:r(i)
%             sum = 0;
            for k=1:no_of_var
%                 sum = sum + max(b(k,j,i)*x(k,1),b(k,j,i)*x(k,2));
                U(i,j) = U(i,j) + max(b(k,j,i)*x(k,1),b(k,j,i)*x(k,2));
            end
%             U(i,j) = sum;
        end
    end
    F = zeros(1,no_of_var+1);
    F(end) = 1;
    A = zeros(no_of_fun*2,no_of_var+1);
    bb = zeros(no_of_fun*2,1);%every eq has  2m+2
    row = 1;
    for i=1:no_of_fun
        for j=1:r(i)
            for k=1:no_of_var
                A(row,k) = A(row,k) + (u(i,j)*b(k,j,i) + U(i,j)*a(k,j,i) + c(k,i));
            end
            bb(row) = bb(row) + u(i,j)*U(i,j);
        end
        if i ~= 1%if not obj function then add di 
            bb(row) = bb(row) + d(i-1);
        end
        row = row + 1;
        for j=1:r(i)
            for k=1:no_of_var
                A(row,k) = A(row,k) + (l(i,j)*b(k,j,i) + L(i,j)*a(k,j,i) + c(k,i));
            end
            bb(row) = bb(row) + l(i,j)*L(i,j);
        end
        if i ~= 1
            bb(row) = bb(row) + d(i-1);
        end
        row = row + 1;
    end

    A(1,end) = -1;
    A(2,end) = -1;
    lb = zeros(1,no_of_var+1);
    ub = zeros(1,no_of_var+1);
    for k=1:no_of_var
        lb(k) = x(k,1);
        ub(k) = x(k,2);
    end
    Aeq=[];
    beq=[];
    lb(end) = -Inf;
    ub(end) = Inf;
    options = optimoptions('linprog','Display','none');
    linprogResult = linprog(F,A,bb,Aeq,beq,lb,ub,options);
end