Roitman & Shadlen (2002) dataset
--------------------------------
Notes by Jan Drugowitsch, July 2017

Each rs_[subj_id].mat files contain the behavioral data from one monkey
performing the reaction time random dot motion experiment of Roitman &
Shadlen (2002). Response of neurons in the lateral intraparietal area during a
combined visual discrimination reaction time task. The Journal of
Neuroscience, 22(21), 9475-9489.

The dataset has been modified from the original dataset, available on
https://www.shadlenlab.columbia.edu/resources/RoitmanDataCode.html, as follows:
- Remove 'invalid' trials
- Only store choices and reaction times, and some additional timing data

Each rs_[subj_id].mat contains multiple vectors, with one element per trial:
- rt: reaction time in seconds
- choice: 0 - "left", 1 - "right"
- cohs: signed coherences, 
        positive/negative - rightward/leftward motion
        magnitude: motion coherence
Some additional timing data (see Roitman & Shadlen, 2002) is provided in
- fix_dur: fixation time
- rew_delay: reward delay
- target_delay: delay to target display
