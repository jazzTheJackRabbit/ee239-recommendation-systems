%Function to create Matrix R from dataset
function [r_mat,w_mat] = create_R_and_W(raw_data)

     uid = raw_data(:,1);
     mid = raw_data(:,2);
     rating = raw_data(:,3);

    data = raw_data(1:length(raw_data),1:3);

    disp('creating R and W matrix')
    w_mat = zeros(max(data(:,1)), max(data(:,2)));
    r_mat = zeros(max(data(:,1)), max(data(:,2)));

    disp('populating matrix...')
        
    for i=1:length(data)
        r_mat(uid(i),mid(i)) = rating(i);
        w_mat(uid(i),mid(i)) = 1;
    end    

end