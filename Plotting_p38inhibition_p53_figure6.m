%%plotting p53 and p38i data of Figure 6

%load data
load('Figure6_p38inhibition.mat');

%separate groups
p53_ctl=Figure6_p38inhibition{1,2};
p53_inhib=Figure6_p38inhibition{2,2};

ctl_Names=Names{1,2};
inhib_Names=Names{2,2};
%%plot average p53 comparison of p53 between NCS and H2O2
figure(1)

    %%plotting p53 for comparison
    hold on
    %%plot_areaerrorbar2 based upon plot_areaerrorbar available on file
    %%exchange developed by Victor Martinez-Cagigal.  Added input parser
    %%for easier incorporation of X-axis and calculated std using nanstd
    %%for cell death plots where dead cells are replaced by nan.
    plot_areaerrorbar2(p53_ctl,'Xaxis',time,'LineColor','r','AreaColor','r');
    plot_areaerrorbar2(p53_inhib,'Xaxis',time,'LineColor','k','AreaColor','k');
    
    ylim([0 30000]);
    xlim([0 24]);
    xlabel('time (hrs)');
    ylabel('p53 (au)');
   legend('DMSO','','p38i','');



figure(2)
%%Plotting integrated p53 levels over full time span

    for i=1:length(p53_ctl(:,1))
        duration=time(~isnan(p53_ctl(i,:)));
        int_ctl(i)=trapz(duration,p53_ctl(i,1:length(duration)));     
    end


    for i=1:length(p53_inhib(:,1))
        duration=time(~isnan(p53_inhib(i,:)));
        int_inhib(i)=trapz(duration,p53_inhib(i,1:length(duration)));
    end



    mint_ctl=mean(int_ctl);
    sem_ctl=std(int_ctl)./sqrt(length(int_ctl));
    mint_inhib=mean(int_inhib);
    sem_inhib=std(int_inhib)./sqrt(length(int_inhib));
    [~,p]=ttest2(int_ctl,int_inhib);
    values=p;


samples=[mint_ctl;mint_inhib]';
error=[sem_ctl;sem_inhib]';


%%barwitherr available in file exchange developed by Martina Callaghan
barwitherr(error,samples);