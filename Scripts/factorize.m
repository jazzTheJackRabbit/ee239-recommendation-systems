% [uid, mid, rating, timestamp] = textscan('../Dataset/ml-100k/u.data', '%d%d%d%d', 'delimiter', '\t');
load('/Dataset/ml-100k/u.data');

uid = u(:,1);
mid = u(:,2);
rating = u(:,3);

data = [uid,mid,rating];

disp('creating R and W matrix')
m_weight = zeros(max(uid), max(mid));
m_rmat = zeros(max(uid), max(mid));

disp('populating matrix...')
for i=1:length(data)
	m_rmat(uid(i),mid(i)) = rating(i);
	m_weight(uid(i),mid(i)) = 1;
end

