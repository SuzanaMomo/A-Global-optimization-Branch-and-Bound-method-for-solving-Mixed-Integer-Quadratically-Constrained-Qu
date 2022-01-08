function c=findC(f,symbols,no_of_var,all_symbols)
    c = zeros(no_of_var,1);
    for i=1:length(symbols)
        list_coeffs = coeffs(f,symbols(i));
        for j=1:length(all_symbols)
            if symbols(i)==all_symbols(j)
                c(j) = double(list_coeffs(end));
            end
        end
    end
end