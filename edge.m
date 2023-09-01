clc;clearvars;close all
addpath('functions/');

% ---------------------------------------------------------
% ------------------  Parameters --------------------------
% ---------------------------------------------------------
iteration = 1000000;                % Number of iterations
landa1 = 1; landa2 = 10;            % Mean of exponential distribution
pfa=0.001;                          % Probability of false alarm
window_size = 32;                   % Size of sliding window
SNR_dB = 20;                        % SNR in decible

% ---------------------------------------------------------
% ------------------ CFAR Parameters ----------------------
% ---------------------------------------------------------
T_CA=(pfa.^(-1/window_size))-1;                     % CA-CFAR
Th_Os=4.12; k_Os = window_size*7/8;                 % OS-CFAR
T_CHA= 283; k_CHA=8;                                % CHA-CFAR
Th_TM=0.395; k1_TM= 3; k2_TM = window_size*7/8;     % TM-CFAR
T_WAI = 19.75; n_WAI = 0.9;                         % WAI-CFAR
% ---------------------------------------------------------

SNR = 10.^(0.1.*SNR_dB);
L = length(SNR);
% Preallocate variables
[Pfa_CA, Pd_CA, Pfa_OS ,Pd_OS, ...
    Pfa_CHA, Pd_CHA, Pfa_TM, Pd_TM, ...
    Pfa_WAI,Pd_WAI] = deal(zeros(window_size+1,1));

for Edge=0:window_size
    disp(strcat('Edge  = ',num2str(Edge) ))
    secondary_data = [exprnd(landa1,[iteration,Edge]) exprnd(landa2,[iteration,window_size-Edge]) ];
    if Edge<(window_size/2)
        X_CUT_H0=(exprnd(landa2,[iteration,1]));
        X_CUT_H1 = exprnd((landa2+SNR),[iteration,1]);
    else
        X_CUT_H0=(exprnd(landa1,[iteration,1]));
        X_CUT_H1 = exprnd((landa1+SNR),[iteration,1]);
    end
    [Pfa_CA(Edge+1,1),Pd_CA(Edge+1,1)]=CA_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,T_CA);
    [Pfa_OS(Edge+1,1),Pd_OS(Edge+1,1)]=OS_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,Th_Os,k_Os);
    [Pfa_CHA(Edge+1,1),Pd_CHA(Edge+1,1)]=CHA_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,T_CHA,k_CHA);
    [Pfa_TM(Edge+1,1),Pd_TM(Edge+1,1)]=TM_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,Th_TM,k1_TM,k2_TM);
    [Pfa_WAI(Edge+1,1),Pd_WAI(Edge+1,1)]=WAI_CFAR(secondary_data,X_CUT_H1,X_CUT_H0,T_WAI,n_WAI);
end

% ---------------------------------------------------------
% ------------------ Plot results -------------------------
% ---------------------------------------------------------
X1 = 0:Edge;
YMatrix_Pd = [Pd_CA Pd_OS Pd_CHA Pd_TM Pd_WAI ];
YMatrix_Pfa = [Pfa_CA Pfa_OS Pfa_CHA Pfa_TM Pfa_WAI];

fontSize = 24;
legendFontSize = 16;
markerSize =  14;
LineWidth = 2;

figure1 = figure;
set(figure1, 'Position', [0 0 800 730])
axes1 = axes('Parent',figure1);
hold(axes1,'on');
plot1 = plot(X1,YMatrix_Pd,'LineWidth',LineWidth,'Parent',axes1);
set(plot1(1),'DisplayName','CA - CFAR','MarkerSize',markerSize,'Marker','square','Color',[0 0.85 1]);
set(plot1(2),'DisplayName','OS - CFAR','MarkerSize',markerSize,'Marker','o','LineStyle','--','Color',[0 0.498039215803146 0]);
set(plot1(3),'DisplayName','CHA - CFAR','MarkerSize',markerSize,'Marker','diamond','Color',[0 0 0]);
set(plot1(4),'DisplayName','TM - CFAR','MarkerSize',markerSize,'Marker','+','Color',[1 0 0]);
set(plot1(5),'DisplayName','WAI - CFAR','MarkerSize',markerSize,'Marker','>','Color',[0 0.447058823529412 0.741176470588235]);
xlabel('SCR (dB)','Interpreter','latex');
box(axes1,'on');
set(axes1,'FontSize',fontSize,'TickLabelInterpreter','latex','XGrid','on','YGrid','on');
hold on
xlim([0 window_size])
% Create ylabel
ylabel('Pfa','Interpreter','latex');
% Create xlabel
xlabel('SCR (dB)','Interpreter','latex');
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',fontSize,'TickLabelInterpreter','latex','XGrid','on','YGrid',...
    'on');
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.15053189768149 0.565882378247066 0.26712987293661 0.327050368357047],...
    'Interpreter','latex','FontSize',legendFontSize);

figure1 = figure;
set(figure1, 'Position', [600 0 800 730])
axes1 = axes('Parent',figure1);
semilogy(Pfa_CA,'DisplayName','CA - CFAR','LineWidth',LineWidth,'MarkerSize',markerSize,'Marker','square','Color',[0 0.85 1]);
hold on
semilogy(Pfa_OS,'DisplayName','OS - CFAR','LineWidth',LineWidth,'MarkerSize',markerSize,'Marker','o','LineStyle','--','Color',[0 0.498039215803146 0]);
hold on
semilogy(Pfa_CHA,'DisplayName','CHA - CFAR','LineWidth',LineWidth,'MarkerSize',markerSize,'Marker','diamond','Color',[0 0 0]);ylabel('Pd','Interpreter','latex');
hold on
semilogy(Pfa_TM,'DisplayName','TM - CFAR','LineWidth',LineWidth,'MarkerSize',markerSize,'Marker','+','Color',[1 0 0]);
hold on
semilogy(Pfa_WAI,'DisplayName','WAI - CFAR','LineWidth',LineWidth,'MarkerSize',markerSize,'Marker','>','Color',[0 0.447058823529412 0.741176470588235]);
xlabel('SCR (dB)','Interpreter','latex');
box(axes1,'on');
set(axes1,'FontSize',fontSize,'TickLabelInterpreter','latex','XGrid','on','YGrid','on');
hold on
xlim([0 window_size])
% Create ylabel
ylabel('Pd','Interpreter','latex');
% Create xlabel
xlabel('SCR (dB)','Interpreter','latex');
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',fontSize,'TickLabelInterpreter','latex','XGrid','on','YGrid',...
    'on');
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.15053189768149 0.565882378247066 0.26712987293661 0.327050368357047],...
    'Interpreter','latex','FontSize',legendFontSize);


