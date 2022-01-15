%creating prediction method validation set. 

%shuffles the training data so that proper unseen data is
%transfered correctly
%{
randCol = colIndex(randperm(size(colIndex, 1)), :);

rand_emb_train(randCol,:) = emb_train(colIndex,:);
rand_ytrain(randCol,:) = ytrain(colIndex,:);
rand_gtrain(randCol,:) = gtrain(colIndex,:);
%}

%Split training data 30% and 70%
%{
emb_train_0_30 = rand_emb_train(1:4838,:);
emb_train_31_100 = rand_emb_train(4839:16128,:);
ytrain_0_30 = rand_ytrain(1:4838,:);
ytrain_31_100 = rand_ytrain(4839:16128,:);
gtrain_0_30 = rand_gtrain(1:4838,:);
gtrain_31_100 = rand_gtrain(4839:16128,:);
%}

%for loop selects and transfers unique species in the 70% to the 30%
%to create unclassified(unseen) species
%
%{
uSp = size(unique(ytrain),1);
n = size(ytrain_31_100,1);
m = size(ytrain_0_30,1)+1;
for i=1:uSp
    r = randi([i,i+74]);
     if mod(r, 50) == 0
         disp(i);
         for j=1:n
             if j < n
                 if ytrain_31_100(j,1) == i
                    m = size(ytrain_0_30,1)+1;
                    emb_train_0_30(m,:) = emb_train_31_100(j,:);
                    emb_train_31_100(j,:) = [];
                    ytrain_0_30(m,:) = ytrain_31_100(j,:);
                    ytrain_31_100(j,:) = [];
                    gtrain_0_30(m,:) = gtrain_31_100(j,:);
                    gtrain_31_100(j,:) = [];
                    n = size(ytrain_31_100,1);
                    j = j-1;
                 end
             end
         end
         j= 0;
     end
end
 %}
 
%creates KNN distribution based on the training data
%{
sz=size(emb_train_0_30,1);

for i=1:sz
    if rem(i,250)==0
        disp(i)
    end
    [D(i),I(i)]=pdist2(emb_train_31_100,emb_train_0_30(i,:),'euclidean','smallest',1);
end
%}

%creates prediction and changes specific species into genus
%based on KNN threshold
%{
 ypred_0_30=ytrain_31_100(I);  
 th=25;
 for i=1:sz
     if D(i)>th
         disp(i)
         ypred_0_30(i)=unique(gtrain_31_100(ytrain_31_100==ypred_0_30(i)));
     end
 end
%}
%{
[gR, ~] = find(ismember(ytrain_0_30, setdiff(unique(ytrain_0_30),unique(ytrain_31_100))));
ypred_0_30_seen=ypred_0_30(:);
ypred_0_30_seen(gR)=[];
ypred_0_30_unseen=ypred_0_30(gR);
ytrain_0_30_seen=ytrain_0_30(:);
ytrain_0_30_seen(gR)=[];
ytrain_0_30_unseen=gtrain_0_30(gR);
%}

%{
classes=unique(ytrain_0_30_unseen);
    nclass = length(classes);
    acc_per_class = zeros(nclass, 1);
    for i=1:nclass
        idx = find(ytrain_0_30_unseen==classes(i));
        acc_per_class(i) = sum(ytrain_0_30_unseen(idx) == ypred_0_30_unseen(idx)) / length(idx);
    end
    gzsl_unseen_acc = mean(acc_per_class);
    
classes=unique(ytrain_0_30_seen);
    nclass = length(classes);
    acc_per_class = zeros(nclass, 1);
    for i=1:nclass
        idx = find(ytrain_0_30_seen==classes(i));
        acc_per_class(i) = sum(ytrain_0_30_seen(idx) == ypred_0_30_seen(idx)) / length(idx);
    end
    gzsl_seen_acc = mean(acc_per_class);
  H = 2 * gzsl_unseen_acc * gzsl_seen_acc / (gzsl_unseen_acc + gzsl_seen_acc);   
%}

%{
  disp(['GZSL unseen: averaged per-class accuracy=' num2str(gzsl_unseen_acc) ]);
disp(['GZSL seen: averaged per-class accuracy=' num2str(gzsl_seen_acc) ]);
disp(['GZSL: H=' num2str(H)]);
%}

hsz=size(emb_test,1)/2;
sz=size(emb_test,1);
for i=1:hsz
    if rem(i,250)==0
        disp(i)
    end
    [Q(i),G(i)]=pdist2(emb_train(1:8064,:),emb_test(i,:),'seuclidean','smallest',1);
    [R(i),J(i)]=pdist2(emb_train(8065:16128,:),emb_test(i,:),'seuclidean','smallest',1);
end
for i=1:sz
    if rem(i,290)==0
        disp(i)
    end
    [V(i),X(i)]=pdist2(emb_train,emb_test(i,:),'euclidean','smallest',1);
    
end
 ypredF=ytrain(X);  
 th=13;
 for i=1:sz
     if V(i)>th
         ypredF(i)=unique(gtrain(ytrain==ypredF(i)));
     end
 end

csvwrite('D:\Users\jason\Documents\IUPUI_S6_2021_Spring\CSCI 48100\HW5\submissionKNN.csv',ypredF);
%}
%creates prediction and changes specific species into genus
%based on KNN threshold

