
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



