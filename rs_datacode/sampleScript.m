% Sample script demonstrating how to use the data structure to look at
% rasters of the spikes.
% created by MKMK  Jan 2006
%
% What you need to know about the data structure:
% there are 3 basic structures in the structure:
% data{1} - is an overview of the datafile, it includes headers of the
% other two structures. data{1}.trialfields tells you what is in each
% column of data{2}, and data{1}.trialcells tells you what is in each
% column of data{3}.
%
% This data file does not include all data recorded. Some trials were
% excluded, usually because fixation was broken. The trial column in data{2}
% is the name of the original trial number, The goodtrial column in data{3}
% is just an index (1 through last number) into the trials that are good
% (and therefor in this file) to make an easy index.
%
% Many of the columns in data{2} you will not care about. The ones you will
% probably care about are the timing colums and a few others, here is a list
% of what these stand for. If you find you need more information, and can't
% tell what column will give you the information, please let me know.
%
%'coh'      coherence of trial (multiplied by 10 - ie. 32 is a coherence of
%           3.2%)
%'dir'      direction of stimulus (0 - 360)
%'trgchoice'    target subject chose (target 1 or 2)
%'correct'  whether the subject was correct (1 - correct, 0 - error)
%
% the timing data - Unfortunately there were some problems recording some
% of these numbers, so you may end up with NaNs in places. Usually this is
% not the case, but if your code starts acting wacky, look for Nans in the
% data. The eye data can be determined from the eye position data if it is
% necessary.

%'trgon'    targets on
%'trgoff'   targets off
%'ston'     stimulus on
%'stoff'    stimulus off
%'fpoff'    fixation point off
%'sac'      time of saccade
%'trgac'    time eyes landed on target
%'fpon'     fixation point on
%'rew'      time of reward
%
% There are two columns in data{3} to be concerned about.
%
% 'raster'  spike times
% 'atim'    time of start of spike recording relatvie to fixation point
%           coming on
%
% the error column tells you if there was an error in the recording, but
% this will generally be obvious (no spike times)

% GetSpikeData

load n585c
% all spike data
rawspikes = data{3}(:,1);
% the start of the recording of the spikes is not timed to the beginning of
% the trial, so we need to adjust the spike data. data{3} column 2 is the
% number of ms away from the fixation point coming on that the spike
% recording began, so we want to add this to the spike times, and get rid
% of any spikes that are negative, so everything starts at fixation point
% coming on

StartCol = data{3}(:,2);
spikes = cell(size(rawspikes));
for i = 1:length(StartCol)
    newStart = StartCol{i};
    if newStart > 0
        disp(['trial ' num2str(i)])
        disp('Warning: recording started after fpon')
        % here just add the amount of recording time, some spikes at the
        % beginning are probably missing
        spikes{i} = rawspikes{i}{:} + newStart;
    elseif newStart < 0
        % here have to get the spikes that are greater than the fpon and then
        % add the fpon time (which is negative)
        % need to get the spikes out of the pesky cell
        temp = rawspikes{i}{:};
        spikes{i} = temp(temp>=abs(newStart)) + newStart;
    else
        % we are going to assume if there is no time given, the recording
        % started at fpon
        spikes{i} = rawspikes{i}{:};
    end
end

% let's line up the responses so that stim on is always at the same time, so
% we can see what the response is like between the stim on and the saccade
% more easily. To do this we just subtract the number of stim on to all of the
% spikes, and this just slides them over that amount, making stim on zero.
% Although stim on is now effectively zero, this just means that we can
% line up all of the trials so that stim on is always at the same time, but
% we can still adjust the plot to see whatever block of time before the
% stim on that we want. Could use whatever marker we wanted to line up the
% spikes, for example the saccade time if you were most interested in
% comparing spikes directly before the saccade. Or change nothing if you
% wanted to compare directly after the fixation came on.
stonAll = data{2}(:,34);

for i = 1:length(spikes)
    spikes{i} = spikes{i} - stonAll(i);
end
% we will be putting up markers to tell us where events take place, so we
% need to make sure these are also changed by the same amount.

sacAll = data{2}(:,37) - stonAll(:);
stonAll = data{2}(:,34) - stonAll(:);

% example of extracting spikes for a trial (trial 4)(can also get directly from data
% structure by using data{3}{n}{:}), but we wanted to fix the timing first
onetrial = spikes{4};

% constants for all figures:
% for this demonstration most interested in area between stimulus on and
% saccade, so a just a few hundred ms should do it. Depending on what you
% wanted to plot could choose to go much earlier or much later.
plotstart = -100;
maxlength = 500;
ticksize = 0.5;

% now lets make a raster plot of the trials where the stimulus was going
% toward target 1, and the subject got the trial correct (also went to
% target 1)
% first find the trial numbers
numbs = find(data{2}(:,12)==1 & data{2}(:,13));
% get the spikes for those trials
st1 = spikes(numbs);
ind = 1:length(numbs);
% We will put some markers on the plot so we know what happens when.
ston = stonAll(numbs);
sac = sacAll(numbs);

figure

for i = 1:length(st1)
    x = st1{i};
    a = [x x nans(size(x))]';
    b = repmat([i-ticksize/2 i+ticksize/2 nan],size(a,2),1)';
    c = size(b,2);
    h = plot(a(:,:),b(:,:),'b','EraseMode','none');
    axis([plotstart maxlength 0 i+1]);
    hold on
    markers = [ston(i) sac(i)];
    rast = plot(markers,i + 0.5,'^');
    legend(rast,'stim on','saccade')
end
title('Target 1 Correct')

% I didn't check to see if there was spike data for all of these trials, so
% a couple of trials appear where there are no spikes. 

% for fun lets look at the other target now:

% In the interest of making this simple, I have cut and pasted the code
% above, for the next few blocks of code, and just changed which trials are
% being plotted instead of using a subfunction, which would really be
% preferable for good coding. :-)

% now lets make a raster plot of the trials where the stimulus was going
% toward target 2, and the subject got the trial correct (also went to
% target 2)
% first find the trial numbers
clear st1 numbs
numbs = find(data{2}(:,12)==2 & data{2}(:,13));
% get the spikes for those trials
st1 = spikes(numbs);
ind = 1:length(numbs);
% We will put some markers on the plot so we know what happens when.
ston = stonAll(numbs);
sac = sacAll(numbs);

figure
for i = 1:length(st1)
    x = st1{i};
    a = [x x nans(size(x))]';
    b = repmat([i-ticksize/2 i+ticksize/2 nan],size(a,2),1)';
    c = size(b,2);
    h = plot(a(:,:),b(:,:),'b','EraseMode','none');
    axis([plotstart maxlength 0 i+1]);
    hold on
    markers = [ston(i) sac(i)];
    rast = plot(markers,i + 0.5,'^');
    legend(rast,'stim on','saccade')
end
title('Target 2 Correct')

% You should be able to tell that the depending on which stimulus was
% showing the spike rates were different between the onset of the stimulus
% and the time of the saccade.

% how about the error data for each?

% now lets make a raster plot of the trials where the stimulus was going
% toward target 1, and the subject got the trial correct (also went to
% target 1)
clear st1 numbs
% first find the trial numbers
numbs = find(data{2}(:,12)==1 & data{2}(:,13)==0);
% get the spikes for those trials
st1 = spikes(numbs);
ind = 1:length(numbs);
% We will put some markers on the plot so we know what happens when.
ston = stonAll(numbs);
sac = sacAll(numbs);

figure
for i = 1:length(st1)
    x = st1{i};
    a = [x x nans(size(x))]';
    b = repmat([i-ticksize/2 i+ticksize/2 nan],size(a,2),1)';
    c = size(b,2);
    h = plot(a(:,:),b(:,:),'b','EraseMode','none');
    axis([plotstart maxlength 0 i+1]);
    hold on
    markers = [ston(i) sac(i)];
    rast = plot(markers,i + 0.5,'^');
    legend(rast,'stim on','saccade')
end
title('Target 1 Incorrect')

% now lets make a raster plot of the trials where the stimulus was going
% toward target 1, and the subject got the trial correct (also went to
% target 1)
clear st1 numbs
% first find the trial numbers
numbs = find(data{2}(:,12)==2 & data{2}(:,13)==0);
% get the spikes for those trials
st1 = spikes(numbs);
ind = 1:length(numbs);
% We will put some markers on the plot so we know what happens when.
ston = stonAll(numbs);
sac = sacAll(numbs);

figure
for i = 1:length(st1)
    x = st1{i};
    a = [x x nans(size(x))]';
    b = repmat([i-ticksize/2 i+ticksize/2 nan],size(a,2),1)';
    c = size(b,2);
    h = plot(a(:,:),b(:,:),'b','EraseMode','none');
    axis([plotstart maxlength 0 i+1]);
    hold on
    markers = [ston(i) sac(i)];
    rast = plot(markers,i + 0.5,'^');
    legend(rast,'stim on','saccade')
end
title('Target 2 Incorrect')
% You should be able to tell now whether Target 1/Target 2 in the title
% referred to the stimulus or the direction of the saccade by how the spike
% rate matches the other two figures where the direction of the saccade and
% the stimulus direction are the same. The spike rate tells you which
% direction the subject perceived, and therefor which direction the subject
% looked.
