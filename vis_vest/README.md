# Optimal multisensory decision-making tutorial

Notes by Jan Drugowitsch, July 2017. Please see `vis_vest_tutorial.pdf` for further details.

## Behavioral data
vis_vest_*subj_id*.mat: [Drugowitsch et al. (2014)](https://doi.org/10.7554/eLife.03005) data for the three-coherence condition  
`vis_vest_README.txt`: describes the format of vis_vest_*subj_id*.mat files  

## Behavioral analysis
`plot_psych_chron.m`: plots the chronometric / psychometric curve for all coherences  
`test_standard_cue_comb.m`: tests if data follows principles of standard Bayesian cue combination theory  

## Fitting
`fit_cumul_gauss.m`: fits a cumulative Gaussian to the psychometric curve  
`test_fit_cumul_gauss.m`: demonstrates the use of `fit_cumul_gauss.m`  

## Decision-making models
`sim_behavior.m`: simulates experimental conditions with diffusion models and plots the resulting chronometric / psychometric curves  
`sim_weighted_diffusion.m`: simulates Bayes-optimal evidence accumulation with a diffusion model  

## Support functions
`va_profile.m`: returns the velocity/acceleration profile used in the experiment  
`plot_va_profile.m`: demonstrates the use of `va_profile.m`  
`cond_color.m`: returns the plot color for different conditions  
`extract_cond.m`: extracts trials for a particular condition from the full dataset  

