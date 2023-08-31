function [Pfa,Pd]=TM_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,T,k1,k2)
secondary_data=sort(secondary_data,2);
g = sum(((secondary_data(:,k1:k2))),2);
Pfa=sum(T*g<X_CUT_H0)./length(X_CUT_H0);
Pd=sum(T*g<X_CUT_H1)./length(X_CUT_H0);
end
