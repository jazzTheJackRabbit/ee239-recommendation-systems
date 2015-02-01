function marr = kmax(arr,k)

marr = zeros(1,k);

for i=1:k
    [~,idx] = max(arr);
    marr(i) = idx;
    arr = [arr(1:(idx-1)),arr((idx+1):(length(arr)))];
    
end