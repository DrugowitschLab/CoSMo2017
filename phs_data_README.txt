Palmer, Hauk & Shadlen (2005) dataset
-------------------------------------
Notes by Jan Drugowitsch, July 2017

The phs_[subj_id].mat files contain the behavioral data from Experiment 1 of
Palmer, Huk & Shadlen (2005). The effect of stimulus strength on the speed and
accuracy of a perceptual decision. Journal of Vision 5, 376-404.

The dataset has been modified from the original dataset as follows:
- Remove 'bad' trials
- Assign random choices to 0% coherence trials
- Combine coherence and motion direction into signed coherence
- Convert RTs from ms in s
- Convert 'correct' and 'motion direction' into 'choice'

Each phs_[subj_id].mat contains three vectors, with one element per trial:
- rt: reaction time in seconds
- choice: 0 - "left", 1 - "right"
- cohs: signed coherences, 
        positive/negative - rightward/leftward motion
        magnitude: motion coherence
