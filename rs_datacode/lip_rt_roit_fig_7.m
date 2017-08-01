% lip_rt_roit_fig_7.m

% 4/27/00 jdr
% 12/27/00 updated to new matfiles-- jdr
% pop PSTH for correct, error trials, T1 in RF
% plus, comparison of resp for correct/error 
% 6/1/04 modified (streamlined), and documented for publishing on the web
% MKMK
% July 2017 - slight modifications to plotting, Jan Drugowitsch
 
close all
clear all
ColumnNames608  % script that identifies the columns of the data matrix
% for example: 
% R_DIR = 4 % direction of dots, 0 - zero coherence 
% R_TRG - direction monkey chooses

load T1RT.mat % data file 

% use the not equal, so that we get both the trials with dots going in the
% 1 dir, and the zero coherence trials where the dots were not moving
% coherently.  Zero coherence trials are therefor sorted by which direction
% the monkey looked.
L1c = x(:,R_DIR)~=2 & x(:,R_TRG)==1; % find all times dots were in the 1 
% dir or no coherent motion (not in the 2 dir), and the monkey looked in
% the 1 dir (correct + zero)
L2c = x(:,R_DIR)~=1 & x(:,R_TRG)==2; % find all times dots were in the 2 
% dir or no coherent motion (not in the 1 dir), and the monkey looked in
% the 2 dir (correct + zero)

% errors are not used in this analysis, but here is the code that would
% extract them:
%L1e = x(:,R_DIR)==2 & x(:,R_TRG)==1; % find all errors in dir 1,
                                     % shouldn't have any zero coh.
%L2e = x(:,R_DIR)==1 & x(:,R_TRG)==2; % find all errors in dir 2,
                                     % shouldn't have any zero coh.

ntrials = length(x(:,1));
cohlist = unique(x(:,R_COH));

Lcoh = x(:,R_COH)==0;  % initiate Lcoh

% axis for plotting
dot_ax = [-100:20:1000];
sac_ax = [-1000:20:300];

%output of makePSTH_excl100_200 - initiate variables to nans to save memory
% target 1
% mr1c - PSTH wrt dots on, mr1cD - PSTH wrt sac
% target 2
% mr2c - PSTH wrt dots on, mr2cD - PSTH wrt sac
mr1c = repmat(nan, length(cohlist),length(dot_ax));
mr1cD = repmat(nan, length(cohlist),length(sac_ax));
mr2c = repmat(nan, length(cohlist),length(dot_ax));
mr2cD = repmat(nan, length(cohlist),length(sac_ax));

% makePSTH_excl100_200 will eliminate some spikes:
% for psth aligned to stim on, excludes spikes before 100ms before sac
% for psth aligned to sac, excludes spikes after 200ms after stim on
% go through all coherences, Lcoh&L1c sorts out the correct for each
% coherence, dir 1, and Lcoh&L2c the correct for each coh, dir 2.
% s is a vector of cells containing the rasters, x is a matrix from which
% we can pull out the stim on time and the sac time
for i = 1:length(cohlist)
    Lcoh = x(:,R_COH)==cohlist(i);
    [mr1c(i,:), mr1cD(i,:)] =  makePSTH_excl100_200(s(Lcoh&L1c), ...
        x(Lcoh&L1c,R_TSTON),...
        x(Lcoh&L1c,R_TSAC),...
        dot_ax,sac_ax);
    [mr2c(i,:), mr2cD(i,:)] =  makePSTH_excl100_200(s(Lcoh&L2c), ...
        x(Lcoh&L2c,R_TSTON),...
        x(Lcoh&L2c,R_TSAC),...
        dot_ax,sac_ax);
    
end

% So now we have 4 matrices, 2 per plot (1 wrt the stim on 1 wrt the
% saccade) One matrix is a histogram of the amount of trials that could
% have spiked during this time segment (the segments are small enough that
% only one spike per cell could have occurred), the other the amount of
% spikes that actually occured during this time segment. All of the trials
% have been trimmed.

%remove response past median RT (for responses aligned to dots on) or
%remove responses before the the median RT for responses aligned to the
% saccade.  This is so that all of the traces we are plotting are based on
% more than half of the data.

% first initiate the matrices
m_mr1c = repmat(nan, length(cohlist),length(dot_ax));
m_mr1cD = repmat(nan, length(cohlist),length(sac_ax));
m_mr2c = repmat(nan, length(cohlist),length(dot_ax));
m_mr2cD = repmat(nan, length(cohlist),length(sac_ax));

mRT_1 = repmat(nan, length(cohlist),1);
mRT_2 = repmat(nan, length(cohlist),1);

% find the median rt for each coherence
for i = 1:length(cohlist)
  Lcoh = x(:,R_COH)==cohlist(i);
  mRT_1(i) = median(x(Lcoh&L1c,R_RT)); % 1 direction
  mRT_2(i) = median(x(Lcoh&L2c,R_RT)); % 2 direction
end

% make the new data set, all traces now based on more than half the data,
% if there isn't enough data, don't plot anything there

% this says that for every point on the dot_ax that is less than the
% average for that coherence, the new vector is equal to the old vector,
% otherwise there will still be nans in these positions.
% for the saccade, we have made the axis so that the saccade is at time
% zero.  the median rt is a number with respect to the stim on, but the rt tells
% us the time of the saccade, so if we look at the negative of this
% number, it will tell us when the stimulus came on and we should plot
% the points where more than half of the data is represented (ie. after
% this time)  Keep all points that are greater than the negative of the
% median rt.  
for i = 1:length(cohlist)
  i;
  m_mr1c(i,dot_ax <= mRT_1(i)-100)   = mr1c(i,dot_ax <= mRT_1(i)-100);
  m_mr1cD(i,sac_ax >= -mRT_1(i)+200) = mr1cD(i,sac_ax >= -mRT_1(i)+200);
  m_mr2c(i,dot_ax <= mRT_2(i)-100)   = mr2c(i,dot_ax <= mRT_2(i)-100);
  m_mr2cD(i,sac_ax >= -mRT_2(i)+200) = mr2cD(i,sac_ax >= -mRT_2(i)+200);

end


% here we plot the correct trials
% At this stage, m_mr1c and m_mr2c are coherence x time steps matrices with
% times since stimulus onset in dot_ax. nanrunmean(.) performs a running
% average, including n time steps before and after the current time.
figure('Color', 'white');
ax(1) = subplot(1,2,1);  hold on;
plot(dot_ax, nanrunmean(m_mr1c',1),'LineWidth',2)
plot(dot_ax, nanrunmean(m_mr2c',1),'--','LineWidth',2)
ax(2) = subplot(1,2,2);  hold on;
plot(sac_ax, nanrunmean(m_mr1cD',1),'LineWidth',2)
plot(sac_ax, nanrunmean(m_mr2cD',1),'--','LineWidth',2)

% make the plots prettier and set the axis limits
x1 = -100; x2 = 900;
x1D = -900; x2D = 100;
set(ax(1),'XLim',[x1 x2])
set(ax(2),'XLim',[x1D x2D])
p1 = get(ax(1),'Position');
p2 = get(ax(2),'Position');
set(ax(2),'Position', p2 .* [1 1 (x2D-x1D)/(x2-x1) 1])
set(ax,'TickDir','out','FontSize',14,'Box','off');
set(ax,'YLim',[20 70]) 
set(ax(2),'YColor','w')
set(gcf,'CurrentAxes',ax(2))
hl = line([0 0],[15 70]);
hl = line([-50 -50],[15 70]);
hl = line([-100 -100],[15 70]);
hl = line([-150 -150],[15 70]);
set(hl,'Color','k')
set(gcf,'CurrentAxes',ax(1))
h2  = line([0 0],[15 70]);
h2  = line([200 200],[15 70]);
h2  = line([390 390],[15 70]);
set(h2,'Color','k') 
xlabel('Time (ms)')
ylabel('Firing rate (sp/s)')



