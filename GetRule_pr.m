function [pr]=GetRule_pr( Xtr,xc,RuleBunch,Order,tauMat,RuleNumInit)
    RuleBunchInit=RuleBunch(1:RuleNumInit,:);
    Delta=ones(RuleNumInit,xc);
    [pr]=TSK_RuleAvailable( Xtr,RuleBunchInit,Delta,Order,tauMat);
end

function [pr] = TSK_RuleAvailable( x,RuleBunch,Delta,Order,tau) 
z0=fromXtoZ_N_Order(x,RuleBunch,Delta,Order);
hth=z0'*z0; 
[K,~]=size(hth);
pr=(tau*eye(K)+hth)\z0';
clear zt z0
end
