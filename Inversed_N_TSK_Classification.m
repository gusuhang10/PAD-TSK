function [TestAcc,TrainAcc,TrainAccMap,TestAccMap,p,timetotal]=Inversed_N_TSK_Classification( Xtr,Ytr,Xte,Yte,xc,LabelList,LabelCount,RuleNumEnd,HI,N,tau,Predicted_testlabel,runNumgrade,Belta,gamma,k,TestAcc,TrainAcc,p,j,TrainAccMap,TestAccMap,timetotal,percent_tr,percent_t)
Delta=ones(RuleNumEnd,xc);
for r=1:runNumgrade
    [RuleBunch,~]=GetRuleBunch(xc,k,HI);
    timeini=cputime;
    [yvp,ytp,p,wt,wt2,xt1,xt2]=TSK_InversedRuleAvailable(Xtr,Ytr,Xte,Delta,N,tau,p,k,r,RuleBunch);
    timeini2=cputime-timeini;
    
    [N_te,~]=size(Xte);
    Dis=zeros(N_te,LabelCount); 
    for i=1:LabelCount 
        Dis(:,i)=abs(yvp(:,r)-LabelList(i)); 
    end
    [~,NearestLabelX]=min(Dis,[],2);
    TestLabel=LabelList(NearestLabelX);
    TestAcc(k,r)=length(TestLabel(TestLabel==Yte))/N_te;
    
    [N_tr,~]=size(Xtr);
    Dis=zeros(N_tr,LabelCount); 
    for i=1:LabelCount 
        Dis(:,i)=abs(ytp(:,r)-LabelList(i));
    end
    [~,NearestLabelX]=min(Dis,[],2);
    TrainLabel=LabelList(NearestLabelX);
    TrainAcc(k,r)=length(TrainLabel(TrainLabel==Ytr))/N_tr;
    
    datatra_by_label_replacement=label_replacement_of_trainingset([Xtr Ytr],percent_tr);
    label_attack_tr=datatra_by_label_replacement(:,end);
    
    
    testdataset_by_label_replacement=label_replacement_of_trainingset([Xte Predicted_testlabel],percent_t);
    label_attack_te=testdataset_by_label_replacement(:,end);
    
    timeini3=cputime;
    [Xtr,Xte]=Get_Adversarial_sample(Xtr,Ytr,Xte,Predicted_testlabel,Belta,wt,wt2,ytp,yvp,p{k,r},xt1,xt2,RuleBunch,gamma,k);
    timetotal=cputime+timetotal-timeini3+timeini2;
end

TestAccMap{1,j}=TestAcc;
TrainAccMap{1,j}=TrainAcc;

    function [yvp,ytp,p,wt,wt2,xt1,xt2] = TSK_InversedRuleAvailable( x,y,xt,Delta,Order,tau,p,k,r,RuleBunch) 
        [z0,wt,xt1]=fromXtoZ_N_Order(x,RuleBunch,Delta,Order);
        hth=z0'*z0;
        [K,~]=size(hth);
        pr=(tau*eye(K)+hth)\z0';
        p{k,r}=pr*y;
        [zt,wt2,xt2]=fromXtoZ_N_Order(xt ,RuleBunch,Delta,Order);
        ytp(:,r)=z0*p{k,r}; 
        yvp(:,r)=zt*p{k,r}; 
        clear zt z0
    end
end
