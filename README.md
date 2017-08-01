# Scripts for CoSMo 2017 summer school

Notes by Jan Drugowitsch, July 2017

## Datasets
phs_*subj_id*.mat: Palmer, Huk & Shadlen (2006) data  
`phs_data_README.txt`: describes the format of phs_*subj_id*.mat files  
rs_*subj_id*.mat: Roitman & Sahdlen (2002) data  
`rs_data_README.txt`: describes the format of rs_*subj_id*.mat files

## Behavioral data plots
`plot_psych_chron.m`: Plots chronometric / psychometric curves  
`plot_speed_accuracy.m`: Plots chronometric / psychometric curve with RT median splits  
`plot_rt_quant.m`: Generates RT quantile plots  
`plot_rt_dist.m`: Plots RT distributions  
`plot_pcorrect_over_time.m`: Plots how p(correct) changes over time  

## Fitting behavior
`fit_psych_chron.m`: Fits psychometric / chronometric curve with diffusion model  
`plot_fitted_rt_dists.m`: Fits behavior with diffusion model and plots RT distributions  

## Decision-making models
`collapse_gain.m`: Script comparing rewards between constant and collapsing-bound DDMs  
`plot_fpt_vary_bound_example.m`: Plots RT distribution examples for constant vs. collapsing bounds  
`fpt_moments.m`: Returns the RT moments for given RT distributions  
`accum_evidence_reward.m`: Plots expected reward for accumulating evidence  
`accum_evidence_discrete.m`: Plots discrete-time evidence accumulation with point-wise prior  
`accum_evidence_continuous.m`: Plots continuous evidence accumulation with point-wise prior  
`accum_evidence_gauss.m`: Plots continuous evidence accumulation with Gaussian prior  

## Dynamic programming
`dp_discretized_g.m`: Returns a vector of discretized beliefs  
`dp_value_iteration_point_hyp.m`: Performs value iteration to find value function for point-wise prior  
`dp_getvalues_gauss_hyp.m`: Uses backwards induction to find value function for Gaussian prior  
`dp_g_trans_point_hyp.m`: Returns the belief transition matrix for point-wise prior  
`dp_g_trans_gauss_hyp.m`: Returns the belief transition matrix for Gaussian prior  
`dp_valueintersect.m`: Interpolates the belief at which two value functions intersect
`plot_dp_bound_direct_maximization.m`: Performs direct diffusion model reward maximization  
`plot_dp_valueintersect_point.m`: Plots value function intersection for point-wise prior  
`plot_dp_valueintersect_gauss.m`: Plots value function intersection for Gaussian prior  
`plot_g_trans_point_hyp.m`: Plots belief transition matrix examples for point-wise prior  
`plot_g_trans_gauss_hyp.m`: Plots belief transition matrix examples for Gaussian prior  
`plot_dp_diffusion_point.m`: Plots optimal diffusion model example for point-wise prior  
`plot_dp_diffusion_gauss.m`: Plots optimal diffusion model example for Gaussian prior  
`plot_const_bound_gauss.m`: Plots bound in belief for constant-bounded DDM for Gaussian prior  
