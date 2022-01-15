special characters 'N' and '-' denote missing values
%{
testTokens = exists(1:340, 1:5989);
trainTokens = existsTR(1:340, 1:9896);
trainTokensC = trainTokens;
testTokensC = testTokens;
trainTokens = trainTokensC';
testTokens = testTokensC';
ytrainReduced = ytrain(1:9896);
gtrainReduced = gtrain(1:9896);

totalR = zeros(9096,1);
r = 0;
n = 68;
z = n;
m = 0;
q = 0;
for i = 1:9896
    totalR(i,1) = randi([1,8]);
    if totalR(i,1) > 1 && n > 0
        n = n - 1;
    else
        r = r + 1;
        if n == 0
            m = m + 1;
            totalR(i,1) = 1;
            if m == 16
                n = z;
                m = 0;
                q = q + 1;
            end
        end
    end
end
ytrainR25 = zeros(r,1);
gtrainR25 = zeros(r,1);
trainT25 = zeros(r,340);
ytrainR75 = zeros(9896 - r,1);
gtrainR75 = zeros(9896 - r,1);
trainT75 = zeros(9896 - r,340);

j = 1;
k = 1;
for i = 1:9896
    if totalR(i,1) == 1
        ytrainR25(j,:) = ytrainReduced(i,:);
        gtrainR25(j,:) = gtrainReduced(i,:);
        trainT25(j,:) = trainTokens(i,:);
        j = j + 1;
    else
        ytrainR75(k,:) = ytrainReduced(i,:);
        gtrainR75(k,:) = gtrainReduced(i,:);
        trainT75(k,:) = trainTokens(i,:);
        k = k + 1;
    end
end
tokenWeight = zeros(1, 340);
tokenWeight(1, 1:4) = .2;
tokenWeight(1, 5:20) = .3;
tokenWeight(1, 21:84) = .9;
tokenWeight(1, 85:340) = 1;



tr75sBagger = TreeBagger(100, trainT75, ytrainR75);
tr75gBagger = TreeBagger(100, trainT75, gtrainR75);

[cell75s25,score75s25] = predict(tr75sBagger, trainT25);
[cell75g25,score75g25] = predict(tr75gBagger, trainT25);

tr75sPred25 = str2double(cell75s25);
tr75gPred25 = str2double(cell75g25);
sz = size(tr75sPred25,1);
tr75ScoredPred25 = zeros(sz,1);

for i = 1:sz
    if max(score75s25(i,:)) < 0.2
        if max(score75g25(i,:)) > max(score75s25(i,:))
            tr75ScoredPred25(i,:) = tr75gPred25(i,:);
        else
            unique(gtrainR75(ytrainR75==tr75sPred25(i)));
        end
    else
        tr75ScoredPred25(i,:) = tr75sPred25(i,:);
    end
end

%//////////////////////////////////////////////

[tsR, ~] = find(ismember(ytrainR25, setdiff(unique(ytrainR25),unique(ytrainR75))));
tr75sPred25Seen=tr75sPred25(:);
tr75sPred25Seen(tsR)=[];
tr75sPred25Unseen=tr75sPred25(tsR);
ytrainR25Seen=ytrainR25(:);
ytrainR25Seen(tsR)=[];
ytrainR25Unseen=ytrainR25(tsR);

classes=unique(ytrainR25Unseen);
    nclass = length(classes);
    acc_per_class = zeros(nclass, 1);
    for i=1:nclass
        idx = find(ytrainR25Unseen==classes(i));
        acc_per_class(i) = sum(ytrainR25Unseen(idx) == tr75sPred25Unseen(idx)) / length(idx);
    end
    gzsl_unseen_acc = mean(acc_per_class);
    
classes=unique(ytrainR25Seen);
    nclass = length(classes);
    acc_per_class = zeros(nclass, 1);
    for i=1:nclass
        idx = find(ytrainR25Seen==classes(i));
        acc_per_class(i) = sum(ytrainR25Seen(idx) == tr75sPred25Seen(idx)) / length(idx);
    end
    gzsl_seen_acc = mean(acc_per_class);
  H = 2 * gzsl_unseen_acc * gzsl_seen_acc / (gzsl_unseen_acc + gzsl_seen_acc);   

  disp(['Species unseen: averaged per-class accuracy=' num2str(gzsl_unseen_acc) ]);
disp(['Species seen: averaged per-class accuracy=' num2str(gzsl_seen_acc) ]);
disp(['Species: H=' num2str(H)]);

%////////////////////////////////////////

tr75gPred25Seen=tr75gPred25(:);
tr75gPred25Seen(tsR)=[];
tr75gPred25Unseen=tr75gPred25(tsR);
gtrainR25Seen=gtrainR25(:);
gtrainR25Seen(tsR)=[];
gtrainR25Unseen=gtrainR25(tsR);

classes=unique(gtrainR25Unseen);
    nclass = length(classes);
    acc_per_class = zeros(nclass, 1);
    for i=1:nclass
        idx = find(gtrainR25Unseen==classes(i));
        acc_per_class(i) = sum(gtrainR25Unseen(idx) == tr75gPred25Unseen(idx)) / length(idx);
    end
    gzsl_unseen_acc = mean(acc_per_class);
    
classes=unique(gtrainR25Seen);
    nclass = length(classes);
    acc_per_class = zeros(nclass, 1);
    for i=1:nclass
        idx = find(gtrainR25Seen==classes(i));
        acc_per_class(i) = sum(gtrainR25Seen(idx) == tr75gPred25Seen(idx)) / length(idx);
    end
    gzsl_seen_acc = mean(acc_per_class);
  H = 2 * gzsl_unseen_acc * gzsl_seen_acc / (gzsl_unseen_acc + gzsl_seen_acc);   

  disp(['Genus unseen: averaged per-class accuracy=' num2str(gzsl_unseen_acc) ]);
disp(['Genus seen: averaged per-class accuracy=' num2str(gzsl_seen_acc) ]);
disp(['Genus: H=' num2str(H)]);

%////////////////////////////////////////

tr75ScoredPred25Seen=tr75ScoredPred25(:);
tr75ScoredPred25Seen(tsR)=[];
tr75ScoredPred25Unseen=tr75ScoredPred25(tsR);
scoredSeen=ytrainR25(:);
scoredSeen(tsR)=[];
scoredUnseen=gtrainR25(tsR);

classes=unique(scoredUnseen);
    nclass = length(classes);
    acc_per_class = zeros(nclass, 1);
    for i=1:nclass
        idx = find(scoredUnseen==classes(i));
        acc_per_class(i) = sum(scoredUnseen(idx) == tr75ScoredPred25Unseen(idx)) / length(idx);
    end
    gzsl_unseen_acc = mean(acc_per_class);
    
classes=unique(scoredSeen);
    nclass = length(classes);
    acc_per_class = zeros(nclass, 1);
    for i=1:nclass
        idx = find(scoredSeen==classes(i));
        acc_per_class(i) = sum(scoredSeen(idx) == tr75ScoredPred25Seen(idx)) / length(idx);
    end
    gzsl_seen_acc = mean(acc_per_class);
  H = 2 * gzsl_unseen_acc * gzsl_seen_acc / (gzsl_unseen_acc + gzsl_seen_acc);   

  disp(['Scored unseen: averaged per-class accuracy=' num2str(gzsl_unseen_acc) ]);
disp(['Scored seen: averaged per-class accuracy=' num2str(gzsl_seen_acc) ]);
disp(['Scored: H=' num2str(H)]);

%////////////////////////////////////////
%}

trainBaggerS = TreeBagger(100, trainTokens, ytrainReduced);
trainBaggerG = TreeBagger(100, trainTokens, ytrainReduced);

[cellS,scoreS] = predict(trainBaggerS, testTokens);
[cellG,scoreG] = predict(trainBaggerG, testTokens);

sPrediction = str2double(cellS);
gPrediction = str2double(cellG);
sz = size(sPrediction,1);
finalPrediction = zeros(sz,1);

for i = 1:sz
    if max(scoreS(i,:)) < 0.2
        if max(scoreG(i,:)) > 0.2 
            finalPrediction(i,:) = gPrediction(i,:);
        else
            unique(gtrainReduced(ytrainReduced==sPrediction(i)));
        end
    else
        finalPrediction(i,:) = sPrediction(i,:);
    end
end

csvwrite('D:\Users\jason\Documents\IUPUI_S6_2021_Spring\CSCI 48100\HW5\rForestSubmission.csv',finalPrediction);
