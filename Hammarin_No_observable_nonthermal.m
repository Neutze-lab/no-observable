% THIS SCRIPT PRODUCES ALL THE FIGURES AND STATISTICS FOR:
% No observable non-thermal effect of microwave radiation on the growth of microtubules
% Scientific Reports
% 20240807

%% HOUSEKEEPING
clear all;
close all;
clc

global no_of_curves_sets abs_norm_means time_new abs_norm abs_no_norm plot_fits statistic
%% LOAD DATASETS
load('microspec_dataset_20231107.mat')

disp(set_names)

% Indices for groups
T32=1;
T35=2;
T39=3;
AC35=4;
AC20T35=5;
AC29=6;
AC2015dbm=7;
AC2019dbm=8;
IRcent=9;
HotAir=10;

names={'31.9 C','34.9 C','39.1 C','3.5 GHz','20 GHz 14.2 dBm','20 GHz 18.2 dBm','20 GHz 22.2 dBm','29 GHz','IR laser','Hot air'};

load("IR_dataset.mat")

%% SETTINGS
save_plots=false;
legend_show=false;
linewidth_width=2;
fontsize_size=24;
plot_fits=false;

% statistic='ks'; %kolmogorov-Smirnov
% statistic='t'; %t-test
statistic='w'; %wilcoxon rank sum

tablename=strcat('stats_table_',statistic,'_',string(string(datetime("today"))),'.xls');

%% NORMALIZATIONS and MEANS
for i=1:length(no_of_curves_sets)
    for j=1:no_of_curves_sets(i)
        abs_norm{i}(j,:)=abs_no_norm{i}(j,:)./abs_no_norm{i}(j,end);
    end
    abs_means_trim(i,:)=trimmean(abs_no_norm{i},20);
    abs_norm_means_trim(i,:)=trimmean(abs_norm{i},20);
end

abs_norm_means=abs_norm_means_trim;

%% STANDARD DEVIATIONS

for i=1:length(time_new)
    T32_std(i)=std(abs_norm{T32}(:,i));
    T35_std(i)=std(abs_norm{T35}(:,i));
    T39_std(i)=std(abs_norm{T39}(:,i));
    AC20T35_std(i)=std(abs_norm{AC20T35}(:,i));
    IRcent_std(i)=std(abs_norm{IRcent}(:,i));
    Air_std(i)=std(abs_norm{HotAir}(:,i));
end

T32_stderror=T32_std./sqrt(no_of_curves_sets(T32));
T35_stderror=T35_std./sqrt(no_of_curves_sets(T35));
T39_stderror=T39_std./sqrt(no_of_curves_sets(T39));
AC20T35_stderror=AC20T35_std./sqrt(no_of_curves_sets(AC20T35));
IRcent_stderror=IRcent_std./sqrt(no_of_curves_sets(IRcent));
Air_stderror=Air_std./sqrt(no_of_curves_sets(HotAir));

%% PLOT SET 2AB
%A
figure('Name','2a','Units','centimeters','Position',[2 2 20 15]); clf;

plot(time_new,abs_norm_means(T35,:),'b','LineWidth',2,'DisplayName',set_names{T35})
hold on
plot(time_new,abs_norm_means(T35,:)+T35_stderror,'--b','LineWidth',1)
plot(time_new,abs_norm_means(T35,:)-T35_stderror,'--b','LineWidth',1)
xl1a=xline(time_new(find(abs_norm_means(T35,:)>0.1,1)),'b--',{'t_1_0'});
xl1a.FontSize=fontsize_size+2;
xl1a.LabelVerticalAlignment = 'top';
xl1a.LabelHorizontalAlignment = 'center';

plot(time_new,abs_norm_means(T39,:),'r','LineWidth',2,'DisplayName',set_names{T39})
hold on
plot(time_new,abs_norm_means(T39,:)+T39_stderror,'--r','LineWidth',1)
plot(time_new,abs_norm_means(T39,:)-T39_stderror,'--r','LineWidth',1)
xl1b=xline(time_new(find(abs_norm_means(T39,:)>0.1,1)),'r--',{'t_1_0'});
xl1b.FontSize=fontsize_size+2;
xl1b.LabelVerticalAlignment = 'top';
xl1b.LabelHorizontalAlignment = 'center';

xlim([0 200])
ylabel('Normalized O.D.');
xlabel('Time [s]');
ylim([0 1.05])
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)

if legend_show; legend show;end
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_2a_',string(datetime("today")),'.png'),'Resolution',600) 
end

%B
figure('Name','2b','Units','centimeters','Position',[2 2 20 15]); clf;

indice(1)=find(abs_norm_means(T35,:)>0.1,1);
indice(2)=find(abs_norm_means(T35,:)>0.4,1);
loglog(time_new,abs_norm_means(T35,:),'b','LineWidth',2,'DisplayName',set_names{T35})
hold on
poly_fit=polyfit(log(time_new(indice(1):indice(2))),log(abs_norm_means(T35,indice(1):indice(2))),1);
log_time=log(time_new(indice(1):indice(2)));
temp_extrapolation_b=poly_fit(1).*log_time+poly_fit(2);
x=exp(log_time);y=exp(temp_extrapolation_b);
plot(x, y,':k','LineWidth',4)

xl3=xline(time_new(find(abs_norm_means(T35,:)>0.1,1)),'b--',{'t_1_0'});
xl3.FontSize=fontsize_size+2;
xl3.LabelVerticalAlignment = 'top';
xl3.LabelHorizontalAlignment = 'center';

indice(1)=find(abs_norm_means(T39,:)>0.1,1);
indice(2)=find(abs_norm_means(T39,:)>0.4,1);
loglog(time_new,abs_norm_means(T39,:),'r','LineWidth',2,'DisplayName',set_names{T39})
hold on
poly_fit=polyfit(log(time_new(indice(1):indice(2))),log(abs_norm_means(T39,indice(1):indice(2))),1);
log_time=log(time_new(indice(1):indice(2)));
temp_extrapolation_b=poly_fit(1).*log_time+poly_fit(2);
x=exp(log_time);y=exp(temp_extrapolation_b);
plot(x, y,':k','LineWidth',4)

xl4=xline(time_new(find(abs_norm_means(T39,:)>0.1,1)),'r--',{'t_1_0'});
xl4.FontSize=fontsize_size;
xl4.LabelVerticalAlignment = 'top';
xl4.LabelHorizontalAlignment = 'center';

box on;
ylim([0.05 inf])
xlim([0 200])
ylabel('Normalized O.D.');
xlabel('time [s]');
grid on;
yticks([0 0.1 0.2 0.4 0.6  0.8 1.0])
xticks([0 5 10 50 100 200])
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
if legend_show; legend show;end
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_2b_',string(datetime("today")),'.png'),'Resolution',600)
end

%% PLOT SET 3AB
%A
figure('Name','3a','Units','centimeters','Position',[2 2 20 15]); clf;

plot(time_new,abs_norm_means(T35,:),'b','LineWidth',2,'DisplayName',set_names{T35})
hold on
plot(time_new,abs_norm_means(T35,:)+T35_stderror,'--b','LineWidth',1)
plot(time_new,abs_norm_means(T35,:)-T35_stderror,'--b','LineWidth',1)

xl2a=xline(time_new(find(abs_norm_means(T35,:)>0.1,1)),'b--',{'t_1_0'});
xl2a.FontSize=fontsize_size+2;
xl2a.LabelVerticalAlignment = 'top';
xl2a.LabelHorizontalAlignment = 'center';

plot(time_new,abs_norm_means(AC20T35,:),'r','LineWidth',2,'DisplayName',set_names{AC20T35})
hold on
plot(time_new,abs_norm_means(AC20T35,:)+AC20T35_stderror,'--r','LineWidth',1)
plot(time_new,abs_norm_means(AC20T35,:)-AC20T35_stderror,'--r','LineWidth',1)
xl2a=xline(time_new(find(abs_norm_means(AC20T35,:)>0.1,1)),'r--',{'t_1_0'});
xl2a.FontSize=fontsize_size+2;
xl2a.LabelVerticalAlignment = 'top';
xl2a.LabelHorizontalAlignment = 'center';

xlim([0 200])
ylabel('Normalized O.D.');
xlabel('Time [s]');
ylim([0 1.05])

set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
if legend_show; legend show;end
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_3a_',string(datetime("today")),'.png'),'Resolution',600);
end

%B
figure('Name','3b','Units','centimeters','Position',[2 2 20 15]); clf;

indice(1)=find(abs_norm_means(T35,:)>0.1,1);
indice(2)=find(abs_norm_means(T35,:)>0.4,1);
loglog(time_new,abs_norm_means(T35,:),'b','LineWidth',2,'DisplayName',set_names{T35})
hold on
poly_fit=polyfit(log(time_new(indice(1):indice(2))),log(abs_norm_means(T35,indice(1):indice(2))),1);
log_time=log(time_new(indice(1):indice(2)));
temp_extrapolation_b=poly_fit(1).*log_time+poly_fit(2);
x=exp(log_time);y=exp(temp_extrapolation_b);
plot(x, y,':k','LineWidth',4)

xl3=xline(time_new(find(abs_norm_means(T35,:)>0.1,1)),'b--',{'t_1_0'});
xl3.FontSize=fontsize_size;
xl3.LabelVerticalAlignment = 'top';
xl3.LabelHorizontalAlignment = 'center';

indice(1)=find(abs_norm_means(AC20T35,:)>0.1,1);
indice(2)=find(abs_norm_means(AC20T35,:)>0.4,1);
loglog(time_new,abs_norm_means(AC20T35,:),'r','LineWidth',2,'DisplayName',set_names{AC20T35})
hold on
poly_fit=polyfit(log(time_new(indice(1):indice(2))),log(abs_norm_means(AC20T35,indice(1):indice(2))),1);
log_time=log(time_new(indice(1):indice(2)));
temp_extrapolation_b=poly_fit(1).*log_time+poly_fit(2);
x=exp(log_time);y=exp(temp_extrapolation_b);
plot(x, y,':k','LineWidth',4)

xl4=xline(time_new(find(abs_norm_means(AC20T35,:)>0.1,1)),'r--',{'t_1_0'});
xl4.FontSize=fontsize_size;
xl4.LabelVerticalAlignment = 'top';
xl4.LabelHorizontalAlignment = 'center';

box on;
ylim([0.05 inf])
xlim([0 200])
ylabel('Normalized O.D.');
xlabel('Time [s]');
grid on;
yticks([0 0.1 0.2 0.4 0.6  0.8 1.0])
xticks([0 5 10 50 100 200])
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
if legend_show; legend show;end
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_3b_',string(datetime("today")),'.png'),'Resolution',600)
end


%% PLOT SET 4AB
%A
figure('Name','4a','Units','centimeters','Position',[2 2 20 15]); clf;

plot(time_new,abs_norm_means(HotAir,:),'b','LineWidth',2,'DisplayName',set_names{HotAir})
hold on
plot(time_new,abs_norm_means(HotAir,:)+IRcent_stderror,'--b','LineWidth',1)
plot(time_new,abs_norm_means(HotAir,:)-IRcent_stderror,'--b','LineWidth',1)
xl3a=xline(time_new(find(abs_norm_means(HotAir,:)>0.1,1)),'b--',{'t_1_0'});
xl3a.FontSize=fontsize_size+2;
xl3a.LabelVerticalAlignment = 'top';
xl3a.LabelHorizontalAlignment = 'center';

plot(time_new,abs_norm_means(AC20T35,:),'r','LineWidth',2,'DisplayName',set_names{AC20T35})
hold on
plot(time_new,abs_norm_means(AC20T35,:)+AC20T35_stderror,'--r','LineWidth',1)
plot(time_new,abs_norm_means(AC20T35,:)-AC20T35_stderror,'--r','LineWidth',1)
xl3a=xline(time_new(find(abs_norm_means(AC20T35,:)>0.1,1)),'r--',{'t_1_0'});
xl3a.FontSize=fontsize_size+2;
xl3a.LabelVerticalAlignment = 'top';
xl3a.LabelHorizontalAlignment = 'center';

xlim([0 200])
ylabel('Normalized O.D.');
xlabel('Time [s]');
ylim([0 1.05])
if legend_show; legend show;end
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_4a_',string(datetime("today")),'.png'),'Resolution',600)
end

%B
figure('Name','4b','Units','centimeters','Position',[2 2 20 15]); clf;

indice(1)=find(abs_norm_means(AC20T35,:)>0.1,1);
indice(2)=find(abs_norm_means(AC20T35,:)>0.4,1);
loglog(time_new,abs_norm_means(AC20T35,:),'r','LineWidth',2,'DisplayName',set_names{AC20T35})
hold on
poly_fit=polyfit(log(time_new(indice(1):indice(2))),log(abs_norm_means(AC20T35,indice(1):indice(2))),1);
log_time=log(time_new(indice(1):indice(2)));
temp_extrapolation_b=poly_fit(1).*log_time+poly_fit(2);
x=exp(log_time);y=exp(temp_extrapolation_b);
plot(x, y,':k','LineWidth',4)

xl3b=xline(time_new(find(abs_norm_means(AC20T35,:)>0.1,1)),'r--',{'t_1_0'});
xl3b.FontSize=fontsize_size+2;
xl3b.LabelVerticalAlignment = 'top';
xl3b.LabelHorizontalAlignment = 'center';

indice(1)=find(abs_norm_means(HotAir,:)>0.1,1);
indice(2)=find(abs_norm_means(HotAir,:)>0.4,1);
loglog(time_new,abs_norm_means(HotAir,:),'b','LineWidth',2,'DisplayName',set_names{HotAir})
hold on
poly_fit=polyfit(log(time_new(indice(1):indice(2))),log(abs_norm_means(HotAir,indice(1):indice(2))),1);
log_time=log(time_new(indice(1):indice(2)));
temp_extrapolation_b=poly_fit(1).*log_time+poly_fit(2);
x=exp(log_time);y=exp(temp_extrapolation_b);
plot(x, y,':k','LineWidth',4)

xl3b=xline(time_new(find(abs_norm_means(HotAir,:)>0.1,1)),'b--',{'t_1_0'});
xl3b.FontSize=fontsize_size+2;
xl3b.LabelVerticalAlignment = 'top';
xl3b.LabelHorizontalAlignment = 'center';
box on;
ylim([0.05 inf])
xlim([0 200])
ylabel('Normalized O.D.');
xlabel('Time [s]');
grid on;
yticks([0 0.1 0.2 0.4 0.6  0.8 1.0])
xticks([0 5 10 50 100 200])
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
if legend_show; legend show;end
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_4b_',string(datetime("today")),'.png'),'Resolution',600)
end

%% PLOT SET 5AB
%A
figure('Name','5a','Units','centimeters','Position',[2 2 20 15]); clf;

plot(time_new,abs_norm_means(IRcent,:),'b','LineWidth',2,'DisplayName',set_names{IRcent})
hold on
plot(time_new,abs_norm_means(IRcent,:)+IRcent_stderror,'--b','LineWidth',1)
plot(time_new,abs_norm_means(IRcent,:)-IRcent_stderror,'--b','LineWidth',1)
xl3a=xline(time_new(find(abs_norm_means(IRcent,:)>0.1,1)),'b--',{'t_1_0'});
xl3a.FontSize=fontsize_size+2;
xl3a.LabelVerticalAlignment = 'top';
xl3a.LabelHorizontalAlignment = 'center';

plot(time_new,abs_norm_means(AC20T35,:),'r','LineWidth',2,'DisplayName',set_names{AC20T35})
hold on
plot(time_new,abs_norm_means(AC20T35,:)+AC20T35_stderror,'--r','LineWidth',1)
plot(time_new,abs_norm_means(AC20T35,:)-AC20T35_stderror,'--r','LineWidth',1)
xl3a=xline(time_new(find(abs_norm_means(AC20T35,:)>0.1,1)),'r--',{'t_1_0'});
xl3a.FontSize=fontsize_size+2;
xl3a.LabelVerticalAlignment = 'top';
xl3a.LabelHorizontalAlignment = 'center';

xlim([0 200])
ylabel('Normalized O.D.');
xlabel('Time [s]');
ylim([0 1.05])
if legend_show; legend show;end
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_5a_',string(datetime("today")),'.png'),'Resolution',600)
end

%B
figure('Name','5b','Units','centimeters','Position',[2 2 20 15]); clf;

indice(1)=find(abs_norm_means(AC20T35,:)>0.1,1);
indice(2)=find(abs_norm_means(AC20T35,:)>0.4,1);
loglog(time_new,abs_norm_means(AC20T35,:),'r','LineWidth',2,'DisplayName',set_names{AC20T35})
hold on
poly_fit=polyfit(log(time_new(indice(1):indice(2))),log(abs_norm_means(AC20T35,indice(1):indice(2))),1);
log_time=log(time_new(indice(1):indice(2)));
temp_extrapolation_b=poly_fit(1).*log_time+poly_fit(2);
x=exp(log_time);y=exp(temp_extrapolation_b);
plot(x, y,':k','LineWidth',4)

xl3b=xline(time_new(find(abs_norm_means(AC20T35,:)>0.1,1)),'r--',{'t_1_0'});
xl3b.FontSize=fontsize_size+2;
xl3b.LabelVerticalAlignment = 'top';
xl3b.LabelHorizontalAlignment = 'center';

indice(1)=find(abs_norm_means(IRcent,:)>0.1,1);
indice(2)=find(abs_norm_means(IRcent,:)>0.4,1);
loglog(time_new,abs_norm_means(IRcent,:),'b','LineWidth',2,'DisplayName',set_names{IRcent})
hold on
poly_fit=polyfit(log(time_new(indice(1):indice(2))),log(abs_norm_means(IRcent,indice(1):indice(2))),1);
log_time=log(time_new(indice(1):indice(2)));
temp_extrapolation_b=poly_fit(1).*log_time+poly_fit(2);
x=exp(log_time);y=exp(temp_extrapolation_b);
plot(x, y,':k','LineWidth',4)

xl3b=xline(time_new(find(abs_norm_means(IRcent,:)>0.1,1)),'b--',{'t_1_0'});
xl3b.FontSize=fontsize_size+2;
xl3b.LabelVerticalAlignment = 'top';
xl3b.LabelHorizontalAlignment = 'center';
box on;
ylim([0.05 inf])
xlim([0 200])
ylabel('Normalized O.D.');
xlabel('Time [s]');
grid on;
yticks([0 0.1 0.2 0.4 0.6  0.8 1.0])
xticks([0 5 10 50 100 200])
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
if legend_show; legend show;end
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_5b_',string(datetime("today")),'.png'),'Resolution',600)
end

%% CALCULATE STRETCHES T35 T3 AC  & controls

%1. calculate the stretch for the means
stretch_T35toT39_means=find_stretch(abs_norm_means(T35,:),abs_norm_means(T39,:));
stretch_T39toT35_means=find_stretch(abs_norm_means(T39,:),abs_norm_means(T35,:));
stretch_T35toAC_means=find_stretch(abs_norm_means(T35,:),abs_norm_means(AC20T35,:));
stretch_ACtoIR_means=find_stretch(abs_norm_means(AC20T35,:),abs_norm_means(IRcent,:));
stretch_ACtoAir_means=find_stretch(abs_norm_means(AC20T35,:),abs_norm_means(HotAir,:));

%2. stretch all curves to other group mean
for i=1:no_of_curves_sets(T39)
    stretched_T39toT35(i,:)=evaluate_stretch(time_new, abs_norm{T39}(i,:), stretch_T39toT35_means);
end

for i=1:no_of_curves_sets(T35)
    stretched_T35toT39(i,:)=evaluate_stretch(time_new, abs_norm{T35}(i,:), stretch_T35toT39_means);
end

for i=1:no_of_curves_sets(T35)
    stretched_T35toAC(i,:)=evaluate_stretch(time_new, abs_norm{T35}(i,:), stretch_T35toAC_means);
end

for i=1:no_of_curves_sets(AC20T35)
    stretched_ACtoIR(i,:)=evaluate_stretch(time_new, abs_norm{AC20T35}(i,:), stretch_ACtoIR_means);
end

for i=1:no_of_curves_sets(AC20T35)
    stretched_ACtoAir(i,:)=evaluate_stretch(time_new, abs_norm{AC20T35}(i,:), stretch_ACtoAir_means);
end

%3. get mean and std from stretched curves
stretched_T35toAC_mean=trimmean(stretched_T35toAC,20);
stretched_T35toT39_mean=trimmean(stretched_T35toT39,20);
stretched_T39toT35_mean=trimmean(stretched_T39toT35,20);
stretched_ACtoIR_mean=trimmean(stretched_ACtoIR,20);
stretched_ACtoAir_mean=trimmean(stretched_ACtoAir,20);

for i=1:length(time_new)
    stretched_T35toAC_std(i)=std(stretched_T35toAC(:,i));
    stretched_T35toT39_std(i)=std(stretched_T35toT39(:,i));
    stretched_T39toT35_std(i)=std(stretched_T39toT35(:,i));
    stretched_ACtoIR_std(i)=std(stretched_ACtoIR(:,i));
    stretched_ACtoAir_std(i)=std(stretched_ACtoAir(:,i));
end

stretched_T35toAC_stderror=stretched_T35toAC_std./sqrt(no_of_curves_sets(T35));
stretched_T35toT39_stderror=stretched_T35toT39_std./sqrt(no_of_curves_sets(T35));
stretched_T39toT35_stderror=stretched_T39toT35_std./sqrt(no_of_curves_sets(T39));
stretched_ACtoIR_stderror=stretched_ACtoIR_std./sqrt(no_of_curves_sets(AC20T35));
stretched_ACtoAir_stderror=stretched_ACtoAir_std./sqrt(no_of_curves_sets(AC20T35));

%% PLOT 2C

figure('Name','2c','Units','centimeters','Position',[2 2 20 15]); clf;
plot(time_new,abs_norm_means(T39,:),'r-','DisplayName',set_names{T39},'LineWidth',2)
hold on
plot(time_new,stretched_T35toT39_mean,'b:','DisplayName','stretched','LineWidth',2)
plot(time_new,stretched_T35toT39_mean+stretched_T35toT39_stderror,'b--','DisplayName','stderror','LineWidth',1)
plot(time_new,stretched_T35toT39_mean-stretched_T35toT39_stderror,'b--','DisplayName','stderror','LineWidth',1)
plot(time_new,abs_norm_means(T39,:)+T39_stderror,'r--','DisplayName','stderror','LineWidth',1)
plot(time_new,abs_norm_means(T39,:)-T39_stderror,'r--','DisplayName','stderror','LineWidth',1)
if legend_show; legend show;end
xlim([0 200])
ylim([0 1.05])
xlabel('Time [s]');ylabel('Normalized O.D.')

set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_2c_',string(datetime("today")),'.png'),'Resolution',600)
end
%% PLOT 3C

figure('Name','3c','Units','centimeters','Position',[2 2 20 15]); clf;
plot(time_new,abs_norm_means(AC20T35,:),'r-','DisplayName',set_names{AC20T35},'LineWidth',2)
hold on
plot(time_new,stretched_T35toAC_mean,'b:','DisplayName','stretched','LineWidth',2)
plot(time_new,stretched_T35toAC_mean+stretched_T35toAC_stderror,'b--','DisplayName','stderror','LineWidth',1)
plot(time_new,stretched_T35toAC_mean-stretched_T35toAC_stderror,'b--','DisplayName','stderror','LineWidth',1)
plot(time_new,abs_norm_means(AC20T35,:)+AC20T35_stderror,'r--','DisplayName','stderror','LineWidth',1)
plot(time_new,abs_norm_means(AC20T35,:)-AC20T35_stderror,'r--','DisplayName','stderror','LineWidth',1)
if legend_show; legend show;end
xlim([0 200])
ylim([0 1.05])
xlabel('Time [s]');ylabel('Normalized O.D.')

set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_3c_',string(datetime("today")),'.png'),'Resolution',600)
end

%% PLOT 4C

figure('Name','4c','Units','centimeters','Position',[2 2 20 15]); clf;
plot(time_new,abs_norm_means(HotAir,:),'b-','DisplayName',set_names{HotAir},'LineWidth',2)
hold on
plot(time_new,stretched_ACtoAir_mean,'r:','DisplayName','stretched','LineWidth',2)
plot(time_new,stretched_ACtoAir_mean+stretched_ACtoAir_stderror,'r--','DisplayName','stderror','LineWidth',1)
plot(time_new,stretched_ACtoAir_mean-stretched_ACtoAir_stderror,'r--','DisplayName','stderror','LineWidth',1)
plot(time_new,abs_norm_means(HotAir,:)+Air_stderror,'b--','DisplayName','stderror','LineWidth',1)
plot(time_new,abs_norm_means(HotAir,:)-Air_stderror,'b--','DisplayName','stderror','LineWidth',1)
if legend_show; legend show;end
xlim([0 200])
ylim([0 1.05])
ylabel('Normalized O.D.');
xlabel('Time [s]');

set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_4c_',string(datetime("today")),'.png'),'Resolution',600)
end


%% PLOT 5C

figure('Name','5c','Units','centimeters','Position',[2 2 20 15]); clf;
plot(time_new,abs_norm_means(IRcent,:),'b-','DisplayName',set_names{IRcent},'LineWidth',2)
hold on
plot(time_new,stretched_ACtoIR_mean,'r:','DisplayName','stretched','LineWidth',2)
plot(time_new,stretched_ACtoIR_mean+stretched_ACtoIR_stderror,'r--','DisplayName','stderror','LineWidth',1)
plot(time_new,stretched_ACtoIR_mean-stretched_ACtoIR_stderror,'r--','DisplayName','stderror','LineWidth',1)
plot(time_new,abs_norm_means(IRcent,:)+IRcent_stderror,'b--','DisplayName','stderror','LineWidth',1)
plot(time_new,abs_norm_means(IRcent,:)-IRcent_stderror,'b--','DisplayName','stderror','LineWidth',1)
if legend_show; legend show;end
xlim([0 200])
ylim([0 1.05])
ylabel('Normalized O.D.');
xlabel('Time [s]');

set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_5c_',string(datetime("today")),'.png'),'Resolution',600)
end

%% PLOT 2345D

figure('Name','2d','Units','centimeters','Position',[2 2 20 15]); clf;
plot(time_new,temperatures(T35,:),'b-','DisplayName',set_names{T35},'LineWidth',3)
hold on
plot(time_new,temperatures(T39,:),'r-','DisplayName',set_names{T39},'LineWidth',3)
ylim([28 40])
xlim([0 200])
ylabel('Temperature ^{\circ}C');xlabel('Time [s]')
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
if legend_show; legend show;end
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_2d_',string(datetime("today")),'.png'),'Resolution',600);
end

figure('Name','3d','Units','centimeters','Position',[2 2 20 15]); clf;
plot(time_new,temperatures(T35,:),'b-','DisplayName',set_names{T35},'LineWidth',3)
hold on
plot(time_new,temperatures(AC20T35,:),'r-','DisplayName',set_names{AC20T35},'LineWidth',3)
ylim([28 40])
xlim([0 200])
ylabel('Temperature ^{\circ}C');xlabel('Time [s]')
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
if legend_show; legend show;end
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_3d_',string(datetime("today")),'.png'),'Resolution',600)
end

figure('Name','4d','Units','centimeters','Position',[2 2 20 15]); clf;
plot(time_new,temperatures(HotAir,:),'b-','DisplayName',set_names{HotAir},'LineWidth',3)
hold on
plot(time_new,temperatures(AC20T35,:),'r-','DisplayName',set_names{AC20T35},'LineWidth',3)
ylim([28 40])
xlim([0 200])
ylabel('Temperature ^{\circ}C');xlabel('Time [s]')
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
if legend_show; legend show;end

drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_4d_',string(datetime("today")),'.png'),'Resolution',600)
end

figure('Name','5d','Units','centimeters','Position',[2 2 20 15]); clf;
plot(time_new,temperatures(IRcent,:),'b-','DisplayName',set_names{IRcent},'LineWidth',3)
hold on
plot(time_new,temperatures(AC20T35,:),'r-','DisplayName',set_names{AC20T35},'LineWidth',3)
ylim([28 40])
xlim([0 200])
ylabel('Temperature ^{\circ}C');xlabel('Time [s]')
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
if legend_show; legend show;end

drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_5d_',string(datetime("today")),'.png'),'Resolution',600)
end

%% GET B, OD, T10 & T1

%get parameters from abs_no_norm data
for i=1:length(no_of_curves_sets)
    for j=1:no_of_curves_sets(i)
        [parameters{i}.b(j),parameters{i}.T10(j),parameters{i}.OD(j)]=get_parameters(time_new,abs_no_norm{i}(j,:),plot_fits);
    end
    parameters{1,i}.T1=temperatures(i,1);
end

%% TABLE PARAMETERS

tablelist=[T32 T35 T39 AC35 AC2015dbm AC2019dbm AC20T35 AC29 IRcent HotAir];
n=1;
for i=tablelist

    temp_outl(1,:)=MAD(parameters{1, i}.b);
    temp_outl(2,:)=MAD(parameters{1, i}.OD);
    temp_outl(3,:)=MAD(parameters{1, i}.T10);
    outliers(n)=sum(any(temp_outl))
    not_outliers{n}=~any(temp_outl);

    N(n)=no_of_curves_sets(i)-outliers(n);
    OD_mean(n)=mean(parameters{1, i}.OD(~any(temp_outl)));
    OD_stderror(n)=std(parameters{1, i}.OD(~any(temp_outl)))/sqrt(N(n));
    T10_mean(n)=mean(parameters{1, i}.T10(~any(temp_outl)));
    T10_stderror(n)=std(parameters{1, i}.T10(~any(temp_outl)))/sqrt(N(n));
    B_mean(n)=mean(parameters{1, i}.b(~any(temp_outl)));
    B_stderror(n)=std(parameters{1, i}.b(~any(temp_outl)))/sqrt(N(n));
    T_mean(n)=mean(parameters{1, i}.T2(~any(temp_outl)));
    n=n+1;
    clearvars temp_outl
end

% write parameter_table
writecell(names',tablename,'Sheet','parameters','WriteMode','replacefile','Range','A2')
writecell({'N','OD','OD stderror','T10','T10 stderror','b','b stderror'},tablename,'Sheet','parameters','Range','B1')
writematrix(N',tablename,'Sheet','parameters','Range','B2')
writematrix(OD_mean',tablename,'Sheet','parameters','Range','C2')
writematrix(OD_stderror',tablename,'Sheet','parameters','Range','D2')
writematrix(T10_mean',tablename,'Sheet','parameters','Range','E2')
writematrix(T10_stderror',tablename,'Sheet','parameters','Range','F2')
writematrix(B_mean',tablename,'Sheet','parameters','Range','G2')
writematrix(B_stderror',tablename,'Sheet','parameters','Range','H2')

%% TABLE STATISTICS

summary(1,:)=table2(T32,T35); comparison{1}='T32,T35';
summary(2,:)=table2(T32,T39); comparison{2}='T32,T39';
summary(3,:)=table2(T35,T39); comparison{3}='T35,T39';

summary(4,:)=table2(T35,AC35); comparison{4}='T35,AC35';
summary(5,:)=table2(T35,AC2015dbm); comparison{5}='T35,AC2015dbm';
summary(6,:)=table2(T35,AC2019dbm); comparison{6}='T35,AC2019dbm';
summary(7,:)=table2(T35,AC20T35); comparison{7}='T35,AC20T35';
summary(8,:)=table2(T35,AC29); comparison{8}='T35,AC29';

summary(9,:)=table2(HotAir,AC35); comparison{9}='HotAir,AC35';
summary(10,:)=table2(HotAir,AC2015dbm); comparison{10}='HotAir,AC2015dbm';
summary(11,:)=table2(HotAir,AC2019dbm); comparison{11}='HotAir,AC2019dbm';
summary(12,:)=table2(HotAir,AC20T35); comparison{12}='HotAir,AC20T35';
summary(13,:)=table2(HotAir,AC29); comparison{13}='HotAir,AC29';
summary(14,:)=table2(HotAir,T35); comparison{14}='HotAir,T35';

summary(15,:)=table2(IRcent,AC35); comparison{15}='IRcent,AC35';
summary(16,:)=table2(IRcent,AC2015dbm); comparison{16}='IRcent,AC2015dbm';
summary(17,:)=table2(IRcent,AC2019dbm); comparison{17}='IRcent,AC2019dbm';
summary(18,:)=table2(IRcent,AC20T35); comparison{18}='IRcent,AC20T35';
summary(19,:)=table2(IRcent,AC29); comparison{19}='IRcent,AC29';
summary(20,:)=table2(IRcent,T35); comparison{20}='IRcent,T35';

% write parameter_table
writecell(comparison',tablename,'Sheet','statistics','Range','A2')
writecell({'OD','t10','b','t10 stretched'},tablename,'Sheet','statistics','Range','B1')
writematrix(summary,tablename,'Sheet','statistics','Range','B2')

%% TABLE STATISTICAL POWER

comparisons = [T32 T35; T32 T39; T35 T39; T35 AC35; T35 AC2015dbm; T35 AC2019dbm; T35 AC20T35; T35 AC29;...
    HotAir AC35; HotAir AC2015dbm; HotAir AC2019dbm; HotAir AC20T35; HotAir AC29; HotAir T35;...
    IRcent AC35; IRcent AC2015dbm; IRcent AC2019dbm; IRcent AC20T35; IRcent AC29; IRcent T35];

n=1;
for i =1:length(comparisons)
    set1=comparisons(i,1); set2=comparisons(i,2);
    set1_mean_b=mean(parameters{1,set1}.b(~MAD(parameters{1, set1}.b)));
    set1_std_b=std(parameters{1,set1}.b(~MAD(parameters{1, set1}.b)));
    set2_mean_b=mean(parameters{1,set2}.b(~MAD(parameters{1, set2}.b)));
    set2_std_b=std(parameters{1,set2}.b(~MAD(parameters{1, set2}.b)));

    set1_mean_OD=mean(parameters{1,set1}.OD(~MAD(parameters{1, set1}.OD)));
    set1_std_OD=std(parameters{1,set1}.OD(~MAD(parameters{1, set1}.OD)));
    set2_mean_OD=mean(parameters{1,set2}.OD(~MAD(parameters{1, set2}.OD)));
    set2_std_OD=std(parameters{1,set2}.OD(~MAD(parameters{1, set2}.OD)));

    set1_mean_T10=mean(parameters{1,set1}.T10(~MAD(parameters{1, set1}.T10)));
    set1_std_T10=std(parameters{1,set1}.T10(~MAD(parameters{1, set1}.T10)));
    set2_mean_T10=mean(parameters{1,set2}.T10(~MAD(parameters{1, set2}.T10)));
    set2_std_T10=std(parameters{1,set2}.T10(~MAD(parameters{1, set2}.T10)));

    %
    pwrout_b(n,1) = sampsizepwr('t2',[set1_mean_b set1_std_b],[set2_mean_b],[],length((parameters{1,set1}.b(~MAD(parameters{1, set1}.b)))));
    pwrout_b(n,2) = sampsizepwr('t2',[set2_mean_b set2_std_b],[set1_mean_b],[],length((parameters{1,set2}.b(~MAD(parameters{1, set2}.b)))));

    nreq_b(n,1) = sampsizepwr('t2',[set1_mean_b set1_std_b],[set2_mean_b],0.8,[]);
    nreq_b(n,2) = sampsizepwr('t2',[set2_mean_b set2_std_b],[set1_mean_b],0.8,[]);

    pwrout_OD(n,1) = sampsizepwr('t2',[set1_mean_OD set1_std_b],[set2_mean_OD],[],length((parameters{1,set1}.OD(~MAD(parameters{1, set1}.OD)))));
    pwrout_OD(n,2) = sampsizepwr('t2',[set2_mean_OD set2_std_b],[set1_mean_OD],[],length((parameters{1,set2}.OD(~MAD(parameters{1, set2}.OD)))));

    nreq_OD(n,1) = sampsizepwr('t2',[set1_mean_OD set1_std_b],[set2_mean_OD],0.8,[]);
    nreq_OD(n,2) = sampsizepwr('t2',[set2_mean_OD set2_std_b],[set1_mean_OD],0.8,[]);

    pwrout_T10(n,1) = sampsizepwr('t2',[set1_mean_T10 set1_std_T10],[set2_mean_T10],[],length((parameters{1,set1}.T10(~MAD(parameters{1, set1}.T10)))));
    pwrout_T10(n,2) = sampsizepwr('t2',[set2_mean_T10 set2_std_T10],[set1_mean_T10],[],length((parameters{1,set2}.T10(~MAD(parameters{1, set2}.T10)))));

    nreq_T10(n,1) = sampsizepwr('t2',[set1_mean_T10 set1_std_T10],[set2_mean_T10],0.8,[]);
    nreq_T10(n,2) = sampsizepwr('t2',[set2_mean_T10 set2_std_T10],[set1_mean_T10],0.8,[]);

    n=n+1;
end

% write parameter_tables
writecell(comparison',tablename,'Sheet','power','Range','A2')
writecell({'OD','t10','b'},tablename,'Sheet','power','Range','B1')
writematrix(max(pwrout_OD')',tablename,'Sheet','power','Range','B2')
writematrix(max(pwrout_T10')',tablename,'Sheet','power','Range','C2')
writematrix(max(pwrout_b')',tablename,'Sheet','power','Range','D2')

writecell(comparison',tablename,'Sheet','nreq','Range','A2')
writecell({'OD','t10','b'},tablename,'Sheet','nreq','Range','B1')
writematrix(min(nreq_OD')',tablename,'Sheet','nreq','Range','B2')
writematrix(min(nreq_T10')',tablename,'Sheet','nreq','Range','C2')
writematrix(min(nreq_b')',tablename,'Sheet','nreq','Range','D2')

%% TABLE TEMPERATURES

n=1;
for i=tablelist
    T1(n,1)=temperatures(i,1);
    Tdelta(n,1)=temperatures(i,end)-temperatures(i,1);
    T2(n,1)=temperatures(i,end);
    T2(n,2)=mean(parameters{1,i}.T2(not_outliers{n}));
    T2(n,3)=std(parameters{1,i}.T2(not_outliers{n}));
    n=n+1;
end

writecell(names',tablename,'Sheet','temperatures','Range','A2')
writecell({'Tfinal mean curve','Tfinal mean annot','Tfinal std annot'},tablename,'Sheet','temperatures','Range','B1')
writematrix(round(T2,2),tablename,'Sheet','temperatures','Range','B2')
writecell({'Tstart mean curve'},tablename,'Sheet','temperatures','Range','E1')
writematrix(round(T1,2),tablename,'Sheet','temperatures','Range','E2')
writecell({'Tdelta'},tablename,'Sheet','temperatures','Range','F1')
writematrix(round(Tdelta,2),tablename,'Sheet','temperatures','Range','F2')

%% OBSOLETE SUPPLEMENTARY 1: NORMALITY CHECK
%
% alpha=0.05;
%
% for i=1:length(parameters)
%     %jbtest
%     [jb_h(i,1),jb_p(i,1)]=jbtest(parameters{1, i}.b(~MAD(parameters{1, i}.b)), alpha);
%     [jb_h(i,2),jb_p(i,2)]=jbtest(parameters{1, i}.OD(~MAD(parameters{1, i}.OD)), alpha);
%     [jb_h(i,3),jb_p(i,3)]=jbtest(parameters{1, i}.T10(~MAD(parameters{1, i}.T10)), alpha);
%
%     %adtest
%     [ad_h(i,1),ad_p(i,1)]=adtest(parameters{1, i}.b(~MAD(parameters{1, i}.b)),"Alpha",alpha);
%     [ad_h(i,2),ad_p(i,2)]=adtest(parameters{1, i}.OD(~MAD(parameters{1, i}.OD)),"Alpha",alpha);
%     [ad_h(i,3),ad_p(i,3)]=adtest(parameters{1, i}.T10(~MAD(parameters{1, i}.T10)),"Alpha",alpha);
%
%     %kstest
%     [ks_h(i,1),ks_p(i,1)]=kstest((parameters{1, i}.b(~MAD(parameters{1, i}.b))-mean(parameters{1, i}.b(~MAD(parameters{1, i}.b))))/std(parameters{1, i}.b(~MAD(parameters{1, i}.b))),"Alpha",alpha);
%     [ks_h(i,2),ks_p(i,2)]=kstest((parameters{1, i}.OD(~MAD(parameters{1, i}.OD))-mean(parameters{1, i}.OD(~MAD(parameters{1, i}.OD))))/std(parameters{1, i}.OD(~MAD(parameters{1, i}.OD))),"Alpha",alpha);
%     [ks_h(i,3),ks_p(i,3)]=kstest((parameters{1, i}.T10(~MAD(parameters{1, i}.T10))-mean(parameters{1, i}.T10(~MAD(parameters{1, i}.T10))))/std(parameters{1, i}.T10(~MAD(parameters{1, i}.T10))),"Alpha",alpha);
%
%     %lillietest
%     [lillie_h(i,1),lillie_p(i,1)]=lillietest(parameters{1, i}.b(~MAD(parameters{1, i}.b)),"Alpha",alpha)  ;
%     [lillie_h(i,2),lillie_p(i,2)]=lillietest(parameters{1, i}.OD(~MAD(parameters{1, i}.OD)),"Alpha",alpha)  ;
%     [lillie_h(i,3),lillie_p(i,3)]=lillietest(parameters{1, i}.T10(~MAD(parameters{1, i}.T10)),"Alpha",alpha)  ;
% end
%
% figure('Name','Supplementary, Normality check of parameters, 1 rejects null hypothesis at p=0.05','Units','centimeters','Position',[2 2 35 20]);clf
% n=1;
% for i=tablelist
%     subplot(3,4,n)
%     imagesc([ad_h(i,:); ks_h(i,:); lillie_h(i,:); jb_h(i,:)],[0 1])
%     xticks([1:3])
%     xticklabels({'b','OD','t10'})
%     yticks([1:4])
%     yticklabels({'Anderson-Darling','Kolmogorov-Smirnov','Lilliefors','Jarque-Bera'})
%     title(names{n})
%     axis equal tight
%     colormap copper
%     %     colorbar('Ticks',[0 1])
%     n=n+1;
% end
%
% % drawnow
% % if save_plots
% %     exportgraphics(gcf,strcat('Microspec_S1_',string(datetime("today")),'.png'),'Resolution',600)
% %     %     exportgraphics(gca,['Microspec_S1_',string(datetime("today")),'.eps'])
% % end


%% SUPPLEMENTARY: HISTOGRAMS SHOWING THE NONPARAMETRICS
nonparametrics=[1,3; 4,3; 6,3; 7,1; 8,3; 9,3] %after outlier rejection

sum_outl=0;
sum_all=0;
hist_fontsize=10;
hist_linewidth=1;

figure('Name','Histograms','Units','centimeters','Position',[2 2 38 45])
n=1;m=1;
for set_no = tablelist
    subplot(10,3,n)
    if ismember(1,nonparametrics(find(nonparametrics(:,1)==m),2))
        histogram(parameters{1,set_no}.b,linspace(1,4,50),'FaceColor','r')
    else
        histogram(parameters{1,set_no}.b,linspace(1,4,50),'FaceColor','b')
    end
    hold on
    histogram(parameters{1,set_no}.b(MAD(parameters{1, set_no}.b)),linspace(1,4,50),'FaceColor','k')
    title(['b:',names{1,m}])
    set(gca,'LineWidth',hist_linewidth,'FontSize',hist_fontsize)

    %counting
    sum_outl=sum_outl+sum(MAD(parameters{1, set_no}.b));
    sum_all=sum_all+sum(~MAD(parameters{1, set_no}.b));

    subplot(10,3,n+1)
    if ismember(2,nonparametrics(find(nonparametrics(:,1)==m),2))
        histogram(parameters{1,set_no}.OD,linspace(0.5,2.2,50),'FaceColor','r')
    else
        histogram(parameters{1,set_no}.OD,linspace(0.5,2.2,50),'FaceColor','b')
    end
    hold on
    histogram(parameters{1,set_no}.OD(MAD(parameters{1, set_no}.OD)),linspace(0.5,2.2,50),'FaceColor','k')
    title(['OD:',names{1,m}])
    set(gca,'LineWidth',hist_linewidth,'FontSize',hist_fontsize)
    sum_outl=sum_outl+sum(MAD(parameters{1, set_no}.OD));
    sum_all=sum_all+sum(~MAD(parameters{1, set_no}.OD));

    subplot(10,3,n+2)
    if ismember(3,nonparametrics(find(nonparametrics(:,1)==m),2))
        histogram(parameters{1,set_no}.T10,linspace(0,140,100),'FaceColor','r')
    else
        histogram(parameters{1,set_no}.T10,linspace(0,140,100),'FaceColor','b')
    end
    hold on
    histogram(parameters{1,set_no}.T10(MAD(parameters{1, set_no}.T10)),linspace(0,140,100),'FaceColor','k')
    title(['t_1_0:',names{1,m}])
    set(gca,'LineWidth',hist_linewidth,'FontSize',hist_fontsize)
    sum_outl=sum_outl+sum(MAD(parameters{1, set_no}.T10));
    sum_all=sum_all+sum(~MAD(parameters{1, set_no}.T10));

    n=n+3;m=m+1;
end
% sum_outl
% sum_all

drawnow
if save_plots
    exportgraphics(gcf,strcat('Microspec_S3_Histograms',string(datetime("today")),'.png'),'Resolution',600)
end

%% SUPPLEMENTARY: NEW VNA MEASUREMENTS

% Simulations 2024
load('HFSS_sim_Debye.mat')
load("HFSS_sim_empty_2024.mat")

% Experiments 2024
[new_s_params_exp_buffer new_freq_exp_buffer]=vna_extract('buffer.s2p');
[new_s_params_exp_empty new_freq_exp_empty]=vna_extract('emptycap.s2p');
[new_s_params_exp_nocap new_freq_exp_nocap]=vna_extract('nocap.s2p');
[new_s_params_exp_water1 new_freq_exp_water1]=vna_extract('water.s2p');
[new_s_params_exp_water2 new_freq_exp_water2]=vna_extract('water2.s2p');

new_S21_exp_buffer_amp = squeeze(new_s_params_exp_buffer(2,1,:));
new_S21_exp_buffer_db = mag2db(abs(new_S21_exp_buffer_amp));
new_S11_exp_buffer_amp = squeeze(new_s_params_exp_buffer(1,1,:));
new_S11_exp_buffer_db = mag2db(abs(new_S11_exp_buffer_amp));

new_S21_exp_empty_amp = squeeze(new_s_params_exp_empty(2,1,:));
new_S21_exp_empty_db = mag2db(abs(new_S21_exp_empty_amp));
new_S11_exp_empty_amp = squeeze(new_s_params_exp_empty(1,1,:));
new_S11_exp_empty_db = mag2db(abs(new_S11_exp_empty_amp));

new_S21_exp_nocap_amp = squeeze(new_s_params_exp_nocap(2,1,:));
new_S21_exp_nocap_db = mag2db(abs(new_S21_exp_nocap_amp));
new_S11_exp_nocap_amp = squeeze(new_s_params_exp_nocap(1,1,:));
new_S11_exp_nocap_db = mag2db(abs(new_S11_exp_nocap_amp));

new_S21_exp_water1_amp = squeeze(new_s_params_exp_water1(2,1,:));
new_S21_exp_water1_db = mag2db(abs(new_S21_exp_water1_amp));
new_S11_exp_water1_amp = squeeze(new_s_params_exp_water1(1,1,:));
new_S11_exp_water1_db = mag2db(abs(new_S11_exp_water1_amp));

new_S21_exp_water2_amp = squeeze(new_s_params_exp_water2(2,1,:));
new_S21_exp_water2_db = mag2db(abs(new_S21_exp_water2_amp));
new_S11_exp_water2_amp = squeeze(new_s_params_exp_water2(1,1,:));
new_S11_exp_water2_db = mag2db(abs(new_S11_exp_water2_amp));

figure('Name','Supplementary S2 c','Units','centimeters','Position',[2 2 15 15]);clf
plot(S21deby(:,1), S21deby(:,2),'r','DisplayName','HFSS','LineWidth',2)
hold on;
plot(S21thinCuempty(:,1), S21thinCuempty(:,2),'r:','DisplayName','HFSS','LineWidth',2)
plot(new_freq_exp_buffer./1e9, new_S21_exp_buffer_db,'k','DisplayName','new buffer','LineWidth',2)
plot(new_freq_exp_empty./1e9, new_S21_exp_empty_db,'k:','DisplayName','new empty','LineWidth',2)
xline(3.5,'--')
xline(20,'--')
xline(29,'--')
xlabel('Frequency (GHz)');
ylabel('S_2_1 [dB]');
box on
xlim([0 30])
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
drawnow
if save_plots
    exportgraphics(gcf,strcat('Microspec_S2_c_',string(datetime("today")),'.png'),'Resolution',600)
end

figure('Name','Supplementary S2 d','Units','centimeters','Position',[2 2 15 15]);clf
plot(S11deby(:,1), S11deby(:,2),'r','DisplayName','HFSS','LineWidth',2)
hold on;
plot(S11thinCuempty(:,1), S11thinCuempty(:,2),'r:','DisplayName','HFSS empty','LineWidth',2)
plot(new_freq_exp_buffer./1e9, new_S11_exp_buffer_db,'k','DisplayName','new buffer','LineWidth',2)
plot(new_freq_exp_empty./1e9, new_S11_exp_empty_db,'k:','DisplayName','new empty','LineWidth',2)
xlabel('Frequency (GHz)');
ylabel('S_1_1 [dB]');
xline(3.5,'--')
xline(20,'--')
xline(29,'--')
box on
xlim([0 30])
set(gca,'LineWidth',linewidth_width,'FontSize',fontsize_size)
drawnow
if save_plots
    exportgraphics(gcf,strcat('Microspec_S2_d_',string(datetime("today")),'.png'),'Resolution',600)
end

% CALCULATIONS
% Experimental S values frequency range
freq35=[11 12]; 
freq20=[60 61];
freq29=[87 88];

exp_S21_buffer_35=mean(new_S21_exp_buffer_db(freq35))
exp_S11_buffer_35=mean(new_S11_exp_buffer_db(freq35))
exp_S21_empty_35=mean(new_S21_exp_empty_db(freq35))
exp_S11_empty_35=mean(new_S11_exp_empty_db(freq35))

exp_S21_buffer_20=mean(new_S21_exp_buffer_db(freq20))
exp_S11_buffer_20=mean(new_S11_exp_buffer_db(freq20))
exp_S21_empty_20=mean(new_S21_exp_empty_db(freq20))
exp_S11_empty_20=mean(new_S11_exp_empty_db(freq20))

exp_S21_buffer_29=mean(new_S21_exp_buffer_db(freq29))
exp_S11_buffer_29=mean(new_S11_exp_buffer_db(freq29))
exp_S21_empty_29=mean(new_S21_exp_empty_db(freq29))
exp_S11_empty_29=mean(new_S11_exp_empty_db(freq29))

% EMISSION CALC
exp_em_pow_buffer_35=1-mean(db2pow(new_S21_exp_buffer_db(freq35))) - mean(db2pow(new_S11_exp_buffer_db(freq35)))
exp_em_pow_empty_35=1-mean(db2pow(new_S21_exp_empty_db(freq35))) - mean(db2pow(new_S11_exp_empty_db(freq35)))
exp_em_pow_buffer_20=1-mean(db2pow(new_S21_exp_buffer_db(freq20))) - mean(db2pow(new_S11_exp_buffer_db(freq20)))
exp_em_pow_empty_20=1-mean(db2pow(new_S21_exp_empty_db(freq20))) - mean(db2pow(new_S11_exp_empty_db(freq20)))
exp_em_pow_buffer_29=1-mean(db2pow(new_S21_exp_buffer_db(freq29))) - mean(db2pow(new_S11_exp_buffer_db(freq29)))
exp_em_pow_empty_29=1-mean(db2pow(new_S21_exp_empty_db(freq29))) - mean(db2pow(new_S11_exp_empty_db(freq29)))

exp_em_pow_diff_35=exp_em_pow_buffer_35-exp_em_pow_empty_35;
exp_em_pow_diff_20=exp_em_pow_buffer_20-exp_em_pow_empty_20;
exp_em_pow_diff_29=exp_em_pow_buffer_29-exp_em_pow_empty_29;

% SIM S VALUES frequency range
freq35=[25 26 27];
freq20=[190 191 192];
freq29=[280 281 282];

sim_S21_buffer_35=mean(S21deby(freq35,2))
sim_S11_buffer_35=mean(S11deby(freq35,2))
sim_S21_empty_35=mean(S21thinCuempty(freq35,2))
sim_S11_empty_35=mean(S11thinCuempty(freq35,2))

sim_S21_buffer_20=mean(S21deby(freq20,2))
sim_S11_buffer_20=mean(S11deby(freq20,2))
sim_S21_empty_20=mean(S21thinCuempty(freq20,2))
sim_S11_empty_20=mean(S11thinCuempty(freq20,2))

sim_S21_buffer_29=mean(S21deby(freq29,2))
sim_S11_buffer_29=mean(S11deby(freq29,2))
sim_S21_empty_29=mean(S21thinCuempty(freq29,2))
sim_S11_empty_29=mean(S11thinCuempty(freq29,2))

sim_em_pow_buffer_35=1-mean(db2pow(S21deby(freq35,2))) - mean(db2pow(S11deby(freq35,2)))
sim_em_pow_empty_35=1-mean(db2pow(S21thinCuempty(freq35,2))) - mean(db2pow(S11thinCuempty(freq35,2)))
sim_em_pow_buffer_20=1-mean(db2pow(S21deby(freq20,2))) - mean(db2pow(S11deby(freq20,2)))
sim_em_pow_empty_20=1-mean(db2pow(S21thinCuempty(freq20,2))) - mean(db2pow(S11thinCuempty(freq20,2)))
sim_em_pow_buffer_29=1-mean(db2pow(S21deby(freq29,2))) - mean(db2pow(S11deby(freq29,2)))
sim_em_pow_empty_29=1-mean(db2pow(S21thinCuempty(freq29,2))) - mean(db2pow(S11thinCuempty(freq29,2)))

sim_em_pow_diff_35=sim_em_pow_buffer_35-sim_em_pow_empty_35;
sim_em_pow_diff_20=sim_em_pow_buffer_20-sim_em_pow_empty_20;
sim_em_pow_diff_29=sim_em_pow_buffer_29-sim_em_pow_empty_29;

% write parameter_table
writecell({'3.5GHz buffer';'3.5GHz empty';'20GHz buffer';'20GHz empty';'29GHz buffer';'29GHz empty';'Sim 3.5GHz buffer';'Sim 3.5GHz empty';'Sim 20GHz buffer';'Sim 20GHz empty';'Sim 29GHz buffer';'Sim 29GHz empty'},tablename,'Sheet','S values','Range','A2')
writecell({'S21','S11','Emission pwr %','Diff %'},tablename,'Sheet','S values','Range','B1')
writematrix([round(exp_S21_buffer_35,2) round(exp_S11_buffer_35,2) round(exp_em_pow_buffer_35*100,2) round(exp_em_pow_diff_35*100,2)],tablename,'Sheet','S values','Range','B2')
writematrix([round(exp_S21_empty_35,2) round(exp_S11_empty_35,2) round(exp_em_pow_empty_35*100,2)],tablename,'Sheet','S values','Range','B3')
writematrix([round(exp_S21_buffer_20,2) round(exp_S11_buffer_20,2) round(exp_em_pow_buffer_20*100,2) round(exp_em_pow_diff_20*100,2)],tablename,'Sheet','S values','Range','B4')
writematrix([round(exp_S21_empty_20,2) round(exp_S11_empty_20,2) round(exp_em_pow_empty_20*100,2)],tablename,'Sheet','S values','Range','B5')
writematrix([round(exp_S21_buffer_29,2) round(exp_S11_buffer_29,2) round(exp_em_pow_buffer_29*100,2) round(exp_em_pow_diff_29*100,2)],tablename,'Sheet','S values','Range','B6')
writematrix([round(exp_S21_empty_29,2) round(exp_S11_empty_29,2) round(exp_em_pow_empty_29*100,2)],tablename,'Sheet','S values','Range','B7')

writematrix([round(sim_S21_buffer_35,2) round(sim_S11_buffer_35,2) round(sim_em_pow_buffer_35,2) round(sim_em_pow_diff_35*100,2)],tablename,'Sheet','S values','Range','B8')
writematrix([round(sim_S21_empty_35,2) round(sim_S11_empty_35,2) round(sim_em_pow_empty_35*100,2)],tablename,'Sheet','S values','Range','B9')
writematrix([round(sim_S21_buffer_20,2) round(sim_S11_buffer_20,2) round(sim_em_pow_buffer_20*100,2) round(sim_em_pow_diff_20*100,2)],tablename,'Sheet','S values','Range','B10')
writematrix([round(sim_S21_empty_20,2) round(sim_S11_empty_20,2) round(sim_em_pow_empty_20*100,2)],tablename,'Sheet','S values','Range','B11')
writematrix([round(sim_S21_buffer_29,2) round(sim_S11_buffer_29,2) round(sim_em_pow_buffer_29*100,2) round(sim_em_pow_diff_29*100,2)],tablename,'Sheet','S values','Range','B12')
writematrix([round(sim_S21_empty_29,2) round(sim_S11_empty_29,2) round(sim_em_pow_empty_29*100,2)],tablename,'Sheet','S values','Range','B13')

%% SAR AND ELECTROMAGNETIC FIELD CALCULATIONS

waveguide_length=64; %mm
waveguide_part=25; %mm
waveguide_point=3; %mm
waveguide_before=20; %mm

Pinput_20=[22.2 18.2 14.2];
losses_reflection_20=Pinput_20*db2pow(exp_S11_buffer_20)
emitted_buffer_20=1-db2pow(exp_S11_buffer_20)-db2pow(exp_S21_buffer_20)
emitted_empty_20=1-db2pow(exp_S11_empty_20)-db2pow(exp_S21_empty_20)
emitted_difference_20=emitted_buffer_20-emitted_empty_20
losses_emitted_empty_per_mm_20=emitted_empty_20/waveguide_length
losses_emitted_difference_per_mm_20=emitted_difference_20/waveguide_part
losses_emitted_empty_before_spot_20=losses_emitted_empty_per_mm_20*waveguide_before
losses_emitted_3mm_20=losses_emitted_difference_per_mm_20*waveguide_point
losses_emitted_before_spot_20=losses_emitted_empty_before_spot_20+losses_emitted_3mm_20
percentage_not_lost_20=(1-db2pow(exp_S11_buffer_20)).*(1-losses_emitted_before_spot_20).*(1-db2pow(exp_S21_buffer_20))
Peffective_20=Pinput_20.*percentage_not_lost_20

Pinput_29=22.2;
losses_reflection_29=Pinput_29*db2pow(exp_S11_buffer_29)
emitted_buffer_29=1-db2pow(exp_S11_buffer_29)-db2pow(exp_S21_buffer_29)
emitted_empty_29=1-db2pow(exp_S11_empty_29)-db2pow(exp_S21_empty_29)
emitted_difference_29=emitted_buffer_29-emitted_empty_29
losses_emitted_empty_per_mm_29=emitted_empty_29/waveguide_length
losses_emitted_difference_per_mm_29=emitted_difference_29/waveguide_part
losses_emitted_empty_before_spot_29=losses_emitted_empty_per_mm_29*waveguide_before
losses_emitted_3mm_29=losses_emitted_difference_per_mm_29*waveguide_point
losses_emitted_before_spot_29=losses_emitted_empty_before_spot_29+losses_emitted_3mm_29
percentage_not_lost_29=(1-db2pow(exp_S11_buffer_29)).*(1-losses_emitted_before_spot_29).*(1-db2pow(exp_S21_buffer_29))
Peffective_29=Pinput_29.*percentage_not_lost_29

Pinput_35=22.2;
losses_reflection_35=Pinput_35*db2pow(exp_S11_buffer_35) %losses due to reflection
emitted_buffer_35=1-db2pow(exp_S11_buffer_35)-db2pow(exp_S21_buffer_35) %not reflected nor goes through
emitted_empty_35=1-db2pow(exp_S11_empty_35)-db2pow(exp_S21_empty_35) %not reflected nor goes through
emitted_difference_35=emitted_buffer_35-emitted_empty_35 %difference between filled and empty
losses_emitted_empty_per_mm_35=emitted_empty_35/waveguide_length
losses_emitted_difference_per_mm_35=emitted_difference_35/waveguide_part
losses_emitted_empty_before_spot_35=losses_emitted_empty_per_mm_35*waveguide_before
losses_emitted_3mm_35=losses_emitted_difference_per_mm_35*waveguide_point
losses_emitted_before_spot_35=losses_emitted_empty_before_spot_35+losses_emitted_3mm_35
percentage_not_lost_35=(1-db2pow(exp_S11_buffer_35)).*(1-losses_emitted_before_spot_35).*(1-db2pow(exp_S21_buffer_35))%not reflected * emitted before spot * does not go through
Peffective_35=Pinput_35.*percentage_not_lost_35

Vnominal_20=sqrt(50/1000)*10.^(Pinput_20./20)
Vnominal_p_20=sqrt(2).*Vnominal_20.*1000
Vnominal_35=sqrt(50/1000)*10.^(Pinput_35./20)
Vnominal_p_35=sqrt(2).*Vnominal_35.*1000
Vnominal_29=sqrt(50/1000)*10.^(Pinput_29./20)
Vnominal_p_29=sqrt(2).*Vnominal_29.*1000

Veffective_20=sqrt(50/1000)*10.^(Peffective_20./20)
V_p_20=sqrt(2).*Veffective_20.*1000
Veffective_35=sqrt(50/1000)*10.^(Peffective_35./20)
V_p_35=sqrt(2).*Veffective_35.*1000
Veffective_29=sqrt(50/1000)*10.^(Peffective_29./20)
V_p_29=sqrt(2).*Veffective_29.*1000

conductivity=0.8 %S/m
density=1e3 %kg/m3
sar_35=conductivity*(V_p_35^2)/density
sar_20=conductivity.*(V_p_20.^2)/density
sar_29=conductivity*(V_p_29^2)/density

% write parameter_table
writecell({'3.5GHz SAR';'20GHz SAR';'29GHz SAR';'3.5GHz Vp';'20GHz Vp';'29GHz Vp';'3.5GHz dbm';'20GHz dbm';'29GHz dbm';'3.5GHz nom Vp';'20GHz nom Vp';'29GHz nom Vp'},tablename,'Sheet','SAR','Range','A2')
writecell({'23 dbm','19dbm','15 dbm'},tablename,'Sheet','SAR','Range','B1')
writematrix([round(sar_35,-2)],tablename,'Sheet','SAR','Range','B2')
writematrix([round(sar_20,-2)],tablename,'Sheet','SAR','Range','B3')
writematrix([round(sar_29,-2)],tablename,'Sheet','SAR','Range','B4')
writematrix([round(V_p_35,-2)],tablename,'Sheet','SAR','Range','B5')
writematrix([round(V_p_20,-2)],tablename,'Sheet','SAR','Range','B6')
writematrix([round(V_p_29,-2)],tablename,'Sheet','SAR','Range','B7')
writematrix([round(Peffective_35,1)],tablename,'Sheet','SAR','Range','B8')
writematrix([round(Peffective_20,1)],tablename,'Sheet','SAR','Range','B9')
writematrix([round(Peffective_29,1)],tablename,'Sheet','SAR','Range','B10')
writematrix([round(Vnominal_p_35,1)],tablename,'Sheet','SAR','Range','B11')
writematrix([round(Vnominal_p_20,1)],tablename,'Sheet','SAR','Range','B12')
writematrix([round(Vnominal_p_29,1)],tablename,'Sheet','SAR','Range','B13')


%% IR DATA

%freq 20
freq_20Ghz=overviewmeasurementlines23dBm20GHz(:,3);
freq_20Ghz_mean=smooth(freq_20Ghz);
pixel_to_mm=length(overviewmeasurementlines23dBm20GHz(~isnan(overviewmeasurementlines23dBm20GHz(:,1)),1))/6
freq_20Ghz_mm=1/pixel_to_mm:1/pixel_to_mm:length(freq_20Ghz_mean)/pixel_to_mm;
[~,I]=max(freq_20Ghz_mean);
freq_20Ghz_mm=freq_20Ghz_mm-freq_20Ghz_mm(I);
freq_20Ghz_mean=freq_20Ghz_mean-freq_20Ghz_mean(I);

%freq 29
freq_29Ghz=overviewmeasurementlines23dBm29GHz(:,3);
freq_29Ghz_mean=smooth(freq_29Ghz);
pixel_to_mm=length(overviewmeasurementlines23dBm29GHz(~isnan(overviewmeasurementlines23dBm29GHz(:,1)),1))/6
freq_29Ghz_mm=1/pixel_to_mm:1/pixel_to_mm:length(freq_29Ghz_mean)/pixel_to_mm;
% [~,I]=max(freq_29Ghz_mean); %centered around 20GHz max
freq_29Ghz_mm=freq_29Ghz_mm-freq_29Ghz_mm(I);
freq_29Ghz_mean=freq_29Ghz_mean-freq_29Ghz_mean(I);

%freq 4
freq_4Ghz=overviewmeasurementlines23dBm4GHz(:,3);
freq_4Ghz_mean=smooth(freq_4Ghz);
pixel_to_mm=length(overviewmeasurementlines23dBm29GHz(~isnan(overviewmeasurementlines23dBm4GHz(:,1)),1))/6
freq_4Ghz_mm=1/pixel_to_mm:1/pixel_to_mm:length(freq_4Ghz_mean)/pixel_to_mm;
% [~,I]=max(freq_4Ghz_mean);%centered around 20GHz max
freq_4Ghz_mm=freq_4Ghz_mm-freq_4Ghz_mm(I);
freq_4Ghz_mean=freq_4Ghz_mean-freq_4Ghz_mean(I);

%warm air
for i=1:length(warmair)
    data=warmair{i};
    warmair_IR(:,i)=data(:,1);
    warmair_IR_cap(:,i)=data(~isnan(data(:,2)),2);
end
warmair_ok=[2 3 4 5 6 7 8 11 12 13 14 15 16 17 18 19];
warmair_mean=smooth(mean(warmair_IR(:,warmair_ok)'));
warmair_cap_mean=mean(warmair_IR_cap(:,warmair_ok)');
pixel_to_mm=30
warmair_mm=1/pixel_to_mm:1/pixel_to_mm:length(warmair_mean)/pixel_to_mm;
warmair_cap_mm=1/pixel_to_mm:1/pixel_to_mm:length(warmair_cap_mean)/pixel_to_mm;
[~,I]=max(warmair_mean);
warmair_mm=warmair_mm-warmair_mm(I);
warmair_mean=warmair_mean-warmair_mean(I);

%laser centered
for i=1:length(laser_IR_data)
    data=laser_IR_data{i};
    laser_centered(:,i)=data(:,1);
    laser_centered_cap(:,i)=data(~isnan(data(:,2)),2);
end

laser_centered_mean=smooth(mean(laser_centered'));
laser_centered_cap_mean=mean(laser_centered_cap');
pixel_to_mm=30
laser_centered_mm=1/pixel_to_mm:1/pixel_to_mm:length(laser_centered_mean)/pixel_to_mm;
laser_centered_cap_mm=1/pixel_to_mm:1/pixel_to_mm:length(laser_centered_cap_mean)/pixel_to_mm;
[~,I]=max(laser_centered_mean);
laser_centered_mm=laser_centered_mm-laser_centered_mm(I);
laser_centered_mean=laser_centered_mean-laser_centered_mean(I);

%scale line 2 6mm
per_pixel=6/100;


%% SUPPPLEMENTARY FIGURE THERMAL PROFILES
figure('Name','Supplementary S1 a','Units','centimeters','Position',[2 2 15 15]);clf

% no_of_parameters=5;
% clrmap = colormap(hsv(no_of_parameters));
plot(freq_29Ghz_mm+0.0,freq_29Ghz_mean,'k--','DisplayName','29 Ghz freq','LineWidth',2)
hold on
plot(warmair_mm,warmair_mean,'r--','DisplayName','Air','LineWidth',2,'LineWidth',2)
hold on
plot(freq_20Ghz_mm+0.0,freq_20Ghz_mean,'k','DisplayName','AC 20GHz','LineWidth',2,'LineWidth',2)
plot(laser_centered_mm,laser_centered_mean,'r','DisplayName','IR laser','LineWidth',2,'LineWidth',2)
% plot(freq_4Ghz_mm,freq_4Ghz_mean,'g--','DisplayName','4ghz','LineWidth',2,'LineWidth',2)
% plot(frequency_mm-9,smooth(mean(frequency_data(1:2,:)))-median(mean(frequency_data(1:2,:))),'g','DisplayName','34ghz','LineWidth',2)
plot(frequency_mm-9,smooth(frequency_data(1,:))-median(frequency_data(1,:)),'-','Color','#9ACD32','DisplayName','34ghz','LineWidth',2)
plot(frequency_mm-9,smooth(frequency_data(2,:))-median(frequency_data(2,:)),'--','Color','#9ACD32','DisplayName','34ghz','LineWidth',2)

xline(7.8-8.3,'k:','LineWidth',2)
xline(8.8-8.3,'k:','LineWidth',2)
xline(-2.5,'b:','LineWidth',2)
xline(2.5,'b:','LineWidth',2)
% legend show
xlim([-8 8])
ylim([-5 0.5])
xlabel('mm')
ylabel('\Delta ^{\circ}C')
set(gca,'FontSize',24,'LineWidth',3)
box on

drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_S1_a_',string(datetime("today")),'.png'),'Resolution',600) %#ok<*UNRCH>
end

figure('Name','Supplementary S1 b','Units','centimeters','Position',[2 2 15 15]);clf
i=75*1.5;
plot(IR_20GHz.L2)
% plot([1:290].*per_pixel-8.3,IR_20GHz.L3-max(IR_20GHz.L3),'Color',clrmap(6,:),'LineWidth',2)
plot([i:i+74].*per_pixel-8.3,IR_20GHz.L4(1:75)-max(IR_20GHz.L4(1:75)),'Color','k','LineWidth',2)
hold on
i=i+18;
chord1=abs(2*0.5.*sind((linspace(0,360,17))./2));
plot([i:i+16].*per_pixel-8.3,chord1-max(chord1),':','Color','b','LineWidth',3)
%make text nice and large
xlabel('mm')
ylabel('\Delta ^\circ C')
xline(7.8-8.3,'k:','LineWidth',2)
xline(8.8-8.3,'k:','LineWidth',2)
xlim([-1.5 1.5])
ylim([-inf 0.1])
box on
set(gca,'FontSize',24,'LineWidth',3)
drawnow
if save_plots
    exportgraphics(gca,strcat('Microspec_S1_b',string(datetime("today")),'.png'),'Resolution',600) 
end

%% SUPPLEMENTARY FIGURE THERMAL OSCILLATIONS
large=round(length(freq_29Ghz_mean)/5);
large_29GHz=smooth(freq_29Ghz_mean,large);
difference_29GHz=smooth(freq_29Ghz_mean-large_29GHz,10);

large_20GHz=smooth(freq_20Ghz_mean,large);
difference_20GHz=smooth(freq_20Ghz_mean-large_20GHz,15);

figure('Name','Supplementary S1 d-e','Units','centimeters','Position',[2 2 15 15]);clf
subplot(2,1,1)
plot(freq_29Ghz_mm,freq_29Ghz_mean,'k','DisplayName','data 29','LineWidth',2)
hold on
% plot(freq_29Ghz_mm,small_29GHz,'k','DisplayName','29','LineWidth',2)
plot(freq_29Ghz_mm,large_29GHz,'k:','DisplayName','baseline 29','LineWidth',2)

plot(freq_20Ghz_mm,freq_20Ghz_mean,'r','DisplayName','data 20','LineWidth',2)
% plot(freq_20Ghz_mm,small_20GHz,'r','DisplayName','small movements 20','LineWidth',2)
plot(freq_20Ghz_mm,large_20GHz,'r:','DisplayName','baseline 20','LineWidth',2)
% legend show
xlabel('mm')
ylabel('\Delta ^\circ C')
xlim([-7 4])
box on
set(gca,'FontSize',24,'LineWidth',3)
drawnow

subplot(2,1,2)
plot(freq_29Ghz_mm,difference_29GHz,'k','DisplayName','difference 29','LineWidth',2)
hold on
plot(freq_20Ghz_mm,difference_20GHz,'r','DisplayName','difference 20','LineWidth',2)
% legend show
xlabel('mm')
ylabel('\Delta ^\circ C')
box on
set(gca,'FontSize',24,'LineWidth',3)
drawnow
xlim([-7 4])

if save_plots
    exportgraphics(gcf,strcat('Microspec_S1_de_',string(datetime("today")),'.png'),'Resolution',600) 
end

%% LOCAL FUNCTIONS

function [s_params freq] = vna_extract(input)

    % Reference impedance
    Z0 = 50;

    temp = read(rfdata.data,input);
    freq = temp.Freq; 
    s_params = extract(temp,'S_PARAMETERS',Z0);
end

function [output] = MAD(input)
%Boris Iglewicz and David Hoaglin (1993), “Volume 16: How to Detect and Handle Outliers”, The ASQC Basic References in Quality Control: Statistical Techniques

temp=0.6745*(input-median(input))/median(abs(input-median(input)));
output=false(1,length(input));
output(find(abs(temp)>3.5))=true;

end

function [summary] = table2(one, another)
global no_of_curves_sets abs_norm_means time_new abs_norm abs_no_norm plot_fits statistic

%stretch one to another
stretch_onetoanother_means=find_stretch(abs_norm_means(one,:),abs_norm_means(another,:));
for i=1:no_of_curves_sets(one)
    stretched_onetoanother(i,:)=evaluate_stretch(time_new, abs_norm{one}(i,:), stretch_onetoanother_means);
end

%get parameters for one, another and onetoanother
for i=1:no_of_curves_sets(one)
    [parameters_one.b(i),parameters_one.T10(i),parameters_one.OD(i)]=get_parameters(time_new,abs_no_norm{one}(i,:),plot_fits);
end

for i=1:no_of_curves_sets(another)
    [parameters_another.b(i),parameters_another.T10(i),parameters_another.OD(i)]=get_parameters(time_new,abs_no_norm{another}(i,:),plot_fits);
end

for i=1:no_of_curves_sets(one)
    [parameters_stretched.b(i),parameters_stretched.T10(i),parameters_stretched.OD(i)]=get_parameters(time_new,stretched_onetoanother(i,:),plot_fits);
end

%remove outliers using mad
parameters_one.b=parameters_one.b(~MAD(parameters_one.b));
parameters_one.T10=parameters_one.T10(~MAD(parameters_one.T10));
parameters_one.OD=parameters_one.OD(~MAD(parameters_one.OD));

parameters_another.b=parameters_another.b(~MAD(parameters_another.b));
parameters_another.T10=parameters_another.T10(~MAD(parameters_another.T10));
parameters_another.OD=parameters_another.OD(~MAD(parameters_another.OD));

parameters_stretched.b=parameters_stretched.b(~MAD(parameters_stretched.b));
parameters_stretched.T10=parameters_stretched.T10(~MAD(parameters_stretched.T10));
parameters_stretched.OD=parameters_stretched.OD(~MAD(parameters_stretched.OD));

% calculate stats with either ttest2 or kstest2 or Mann-Whitney U

if statistic=='t'
    %stats before stretch
    %b
    [~,stats_onetoanother_b_p]=ttest2(parameters_one.b, parameters_another.b,'Vartype','unequal','Alpha',0.01);
    %T10
    [~,stats_onetoanother_T10_p]=ttest2(parameters_one.T10, parameters_another.T10,'Vartype','unequal','Alpha',0.01);
    %OD
    [~,stats_onetoanother_OD_p]=ttest2(parameters_one.OD, parameters_another.OD,'Vartype','unequal','Alpha',0.01);


    %stats after stretch
    %b
    [~,stats_anothertostretched_b_p]=ttest2(parameters_stretched.b, parameters_another.b,'Vartype','unequal','Alpha',0.01);
    %T10
    [~,stats_anothertostretched_T10_p]=ttest2(parameters_stretched.T10, parameters_another.T10,'Vartype','unequal','Alpha',0.01);
    %OD
    [~,stats_anothertostretched_OD_p]=ttest2(parameters_stretched.OD, parameters_another.OD,'Vartype','unequal','Alpha',0.01);
end

if statistic=='ks'
    %stats before stretch
    %b
    [~,stats_onetoanother_b_p]=kstest2(parameters_one.b, parameters_another.b,'Tail','unequal','Alpha',0.01);
    %T10
    [~,stats_onetoanother_T10_p]=kstest2(parameters_one.T10, parameters_another.T10,'Tail','unequal','Alpha',0.01);
    %OD
    [~,stats_onetoanother_OD_p]=kstest2(parameters_one.OD, parameters_another.OD,'Tail','unequal','Alpha',0.01);


    %stats after stretch
    %b
    [~,stats_anothertostretched_b_p]=kstest2(parameters_stretched.b, parameters_another.b,'Tail','unequal','Alpha',0.01);
    %T10
    [~,stats_anothertostretched_T10_p]=kstest2(parameters_stretched.T10, parameters_another.T10,'Tail','unequal','Alpha',0.01);
    %OD
    [~,stats_anothertostretched_OD_p]=kstest2(parameters_stretched.OD, parameters_another.OD,'Tail','unequal','Alpha',0.01);
end


if statistic=='w'
    %stats before stretch
    %b
    [stats_onetoanother_b_p,~]=ranksum(parameters_one.b, parameters_another.b,'tail','both','alpha',0.01);
    %T10
    [stats_onetoanother_T10_p,~]=ranksum(parameters_one.T10, parameters_another.T10,'tail','both','alpha',0.01);
    %OD
    [stats_onetoanother_OD_p,~]=ranksum(parameters_one.OD, parameters_another.OD,'tail','both','alpha',0.01);


    %stats after stretch
    %b
    [stats_anothertostretched_b_p,~]=ranksum(parameters_stretched.b, parameters_another.b,'tail','both','alpha',0.01);
    %T10
    [stats_anothertostretched_T10_p,~]=ranksum(parameters_stretched.T10, parameters_another.T10,'tail','both','alpha',0.01);
    %OD
    [stats_anothertostretched_OD_p,~]=ranksum(parameters_stretched.OD, parameters_another.OD,'tail','both','alpha',0.01);
end

summary=[stats_onetoanother_OD_p, stats_onetoanother_T10_p, stats_onetoanother_b_p, stats_anothertostretched_T10_p];

end


function [stretch]=find_stretch(curve,target)
target_t50=find(target>0.5*max(target),1);
curve_t50=find(curve>0.5*max(curve),1);
stretch=target_t50/curve_t50;
end

function [stretched]=evaluate_stretch(time, curve, stretch)
stretched=interp1(time*stretch,curve,time,'nearest','extrap');
end

function [b, T10,OD]=get_parameters(Time, Abs, plot_things)
indice(1)=find(Abs>0.1*mean(Abs(end-20:end)),1);
indice(2)=find(Abs>0.40*mean(Abs(end-20:end)),1);
pol_fit=polyfit(log(Time(indice(1):indice(2))),log(Abs(indice(1):indice(2))),1);

b=pol_fit(1);
T10=Time(indice(1));
OD=Abs(end);

if plot_things
    figure('Name','b and t_1_0');
    log_time=log(Time(indice(1):indice(2)));
    temp_extrapolation_b=pol_fit(1).*log_time+pol_fit(2);
    x=exp(log_time);y=exp(temp_extrapolation_b);

    subplot(1,2,1)
    plot(Time,Abs,'k');
    hold on;
    plot(Time(indice(1):indice(2)),Abs(indice(1):indice(2)),'r','LineWidth',4);
    plot(x, y,'g','LineWidth',2)
    xline(T10)
    ylim([0.0 2])
    xlim([0 300])

    subplot(1,2,2)
    loglog(Time,Abs,'k');
    hold on;
    loglog(Time(indice(1):indice(2)),Abs(indice(1):indice(2)),'r','LineWidth',4);
    loglog(x, y,'g','LineWidth',2)
    xline(T10)
    ylim([0.05 2])
    xlim([0 300])

    drawnow
    pause(0.2)
    close(gcf)
end
end

