import pandas as pd 
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl

exposure = pd.read_excel('./MAT29C_exposure_population_land_area__27c_15c_country fixed.xlsx').set_index('Name')
landmetric = 'landfraction'

topx=50
exp_pop = exposure.sort_values(by='pop_9b_27C', ascending=False).iloc[:topx]*1e-6
exp_pop_27C = exp_pop['pop_9b_27C']
exp_pop_15C = exp_pop['pop_9b_15C']
exp_area = exposure.sort_values(by='landfraction_27C', ascending=False).iloc[:topx]
exp_area_27C = exp_area['landfraction_27C']
exp_area_15C = exp_area['landfraction_15C']

fig = plt.figure(figsize=(20,10))
gs = mpl.gridspec.GridSpec(figure=fig, nrows=1, ncols=4, wspace=0.0, width_ratios=[1,0.2,0.05,1.2])
axp = fig.add_subplot(gs[0,0])
axp2 = fig.add_subplot(gs[0,1])
axa = fig.add_subplot(gs[0,3])

c15='#86bbd6'
c27='#33658a'
p2left = 310

height=0.75

for idx, country_name in enumerate(exp_pop.index[::-1]):
    exp_p_15 = exp_pop_15C[country_name]
    exp_p_27 = exp_pop_27C[country_name]
    axp.barh(y=idx, width=exp_p_15, edgecolor=c15, facecolor=c15, height=height)
    axp.barh(y=idx, width=(exp_p_27-exp_p_15), left=exp_p_15, edgecolor=c27, facecolor=c27, height=height)
    
    if country_name in ['India','Nigeria']:
        axp2.barh(y=idx, width=exp_p_15, edgecolor=c15, facecolor=c15, height=height)
        axp2.barh(y=idx, width=(exp_p_27-p2left), left=p2left, edgecolor=c27, facecolor=c27, height=height)
        axp2.annotate(country_name, (exp_p_27+25,idx-0.2), xycoords=axp2.transData, va='center', ha='left', fontsize=12, zorder=200)
    else:
        axp2.annotate(country_name, (exp_p_27+1,idx-0.2), xycoords=axp.transData, va='center', ha='left', fontsize=12, annotation_clip=False, zorder=200)

renamer= {
    'Netherlands Antilles': 'Neth. Antilles',
    'United Arab Emirates': 'UAE',
    'British Indian Ocean Territory': 'Brit. Indian Ocean Terr.',
    'United States Minor Outlying Islands': 'US Minor Outlying Islands'
    }

for idx, country_name in enumerate(exp_area.index[::-1]):
    exp_a_15 = exp_area_15C[country_name]
    exp_a_27 = exp_area_27C[country_name]
    axa.barh(y=idx, width=exp_a_15, edgecolor=c15, facecolor=c15, height=height)
    axa.barh(y=idx, width=(exp_a_27-exp_a_15), left=exp_a_15, edgecolor=c27, facecolor=c27, height=height)

    axa.annotate(renamer.get(country_name, country_name), (exp_a_27+1,idx-0.2), xycoords=axa.transData, va='center', ha='left', fontsize=12, annotation_clip=False, zorder=200)

axa.axvline(100, alpha=0.2, color='grey')
axa.set_xticks(np.arange(0,120,20))
axa.set_xlim([1,120])
axa.set_xlabel('exposed landfraction (%)', fontsize=14)
axa.set_ylim([-1,topx])
axa.set_yticklabels([])
axa.set_yticks([])
axa.tick_params(axis='both', which='major', labelsize=12)
axp.tick_params(axis='both', which='major', labelsize=12)
axp2.tick_params(axis='both', which='major', labelsize=12)
axp2.set_xticks([400,500,600,700,800])
axp2.set_xticklabels(['',500,'','',800])

axp.set_xlim([0,104])
axp.set_ylim([-1,topx])
axp2.set_xlim([280,850])
axp2.set_ylim([-1,topx])
axp.set_yticklabels([])
axp.spines.right.set_visible(False)
axp2.spines.left.set_visible(False)
axp2.set_yticklabels([])
axp.set_yticks([])
axp2.set_yticks([])
axp.set_xlabel('exposed population (million)', fontsize=14)

axp2.plot([276,294],[-1.25,-0.75], lw=1,c='black', clip_on=False, zorder=300)
axp2.plot([298,316],[-1.25,-0.75], lw=1,c='black', clip_on=False, zorder=300)
axp2.plot([276,294],[topx-0.25,topx+0.25], lw=1,c='black', clip_on=False, zorder=300)
axp2.plot([298,316],[topx-0.25,topx+0.25], lw=1,c='black', clip_on=False, zorder=300)

rect1 = mpl.patches.Rectangle((279,-1.2), 25,1.5, lw=2, ec='none', fc='white', zorder=100, clip_on=False)
rect2 = mpl.patches.Rectangle((279,topx-1), 25,1.5, lw=2, ec='none', fc='white', zorder=100, clip_on=False)
axp2.add_patch(rect1)
axp2.add_patch(rect2)

rect3 = mpl.patches.Rectangle((100.5,23), 10,26.75, lw=2, ec='none', fc='white', zorder=100, clip_on=False)
axa.add_patch(rect3)

plt.savefig('Fig5.png', dpi=400, facecolor='white', bbox_inches='tight')