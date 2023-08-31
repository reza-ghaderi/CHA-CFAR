function [Pfa,Pd]=CHA_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,T,k)
secondary_data=sort(secondary_data,2);
g = 1./(sum((1./ (secondary_data(:,k:end)) ),2));
Pfa=sum(T*g<X_CUT_H0)./length(X_CUT_H0);
Pd=sum(T*g<X_CUT_H1)./length(X_CUT_H0);
end




