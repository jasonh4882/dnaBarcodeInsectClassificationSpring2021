
nt=size(emb_test,1);

for i=1:nt
    if rem(i,1000)==0
        disp(i)
    end
    [D(i),I(i)]=pdist2(emb_train,emb_test(i,:),'euclidean','smallest',1);
end
    
 ypred=ytrain(I);  
 th=20;
 for i=1:nt
     if D(i)>th
         ypred(i)=unique(gtrain(ytrain==ypred(i)));
     end
 end
         
csvwrite('D:\Users\jason\Documents\IUPUI_S6_2021_Spring\CSCI 48100\HW5\sample_submission.csv',ypred);

%the numbers below are for my own testing. you have to update them based on
%your own validation set.
 ypred_seen=ypred(1:4033);
ypred_unseen=ypred(4034:5989);
ytest_seen=ytest(1:4033);
ytest_unseen=gtest(4034:5989);

classes=unique(ytest_unseen);
    nclass = length(classes);
    acc_per_class = zeros(nclass, 1);
    for i=1:nclass
        idx = find(ytest_unseen==classes(i));
        acc_per_class(i) = sum(ytest_unseen(idx) == ypred_unseen(idx)) / length(idx);
    end
    gzsl_unseen_acc = mean(acc_per_class);


classes=unique(ytest_seen);
    nclass = length(classes);
    acc_per_class = zeros(nclass, 1);
    for i=1:nclass
        idx = find(ytest_seen==classes(i));
        acc_per_class(i) = sum(ytest_seen(idx) == ypred_seen(idx)) / length(idx);
    end
    gzsl_seen_acc = mean(acc_per_class);
  H = 2 * gzsl_unseen_acc * gzsl_seen_acc / (gzsl_unseen_acc + gzsl_seen_acc);   

  disp(['GZSL unseen: averaged per-class accuracy=' num2str(gzsl_unseen_acc) ]);
disp(['GZSL seen: averaged per-class accuracy=' num2str(gzsl_seen_acc) ]);
disp(['GZSL: H=' num2str(H)]);


