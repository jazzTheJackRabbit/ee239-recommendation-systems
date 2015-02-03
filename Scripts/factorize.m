% [uid, mid, rating, timestamp] = textscan('../Dataset/ml-100k/u.data', '%d%d%d%d', 'delimiter', '\t');

if(computer == 'MACI64')
    load('/Dataset/ml-100k/u.data');
else
    load('C:\Users\Brandon\Documents\GitHub\recommendationSystems\Dataset\ml-100k\u.data');
end


uid = u(:,1);
mid = u(:,2);
rating = u(:,3);

data = [uid,mid,rating];

disp('creating R and W matrix')
m_weight = zeros(max(uid), max(mid));
m_rmat = zeros(max(uid), max(mid));
%m_rmat = nan(max(uid),max(mid));

disp('populating matrix...')
for i=1:length(data)
	m_rmat(uid(i),mid(i)) = rating(i);
	m_weight(uid(i),mid(i)) = 1;
end

k=[10,50,100];

option_struct = struct('iter',200,'dis',0);



