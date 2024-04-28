#forest.py
import numpy as np
from scipy import stats, optimize
import matplotlib.pyplot as plt
import pandas as pd
from zepid.graphics import EffectMeasurePlot

df = pd.read_sas('bor.sas7bdat')
def confint(subgrp):
    df2=df[ (subgrp)]
    df3=df[ ((df['avalc']==b'PR') | (df['avalc']==b'CR')) & (subgrp)]
    count=df3.shape[0]
    nobs=df2.shape[0]
    alpha=0.05
    alpha_2=alpha/2
    q_=100*count/nobs

    ci_low = stats.beta.ppf(alpha_2, count, nobs - count + 1)
    ci_upp = stats.beta.isf(alpha_2, count + 1, nobs - count)

    if np.ndim(ci_low) > 0:
        ci_low[q_ == 0] = 0
        ci_upp[q_ == 1] = 1
    else:
        ci_low = 100*ci_low if (q_ != 0) else 0
        ci_upp = 100*ci_upp if (q_ != 1) else 1
    return q_, ci_low, ci_upp


q1_, ci_low1, ci_upp1=confint(df['race']==b'Asian')
q2_, ci_low2, ci_upp2=confint(df['race']==b'White')

q3_, ci_low3, ci_upp3=confint(df['sex']==b'Male')
q4_, ci_low4, ci_upp4=confint(df['sex']==b'Female')

q5_, ci_low5, ci_upp5=confint(df['region']==b'Japan')
q6_, ci_low6, ci_upp6=confint(df['region']==b'USA')


labs = ["RACE='ASIAN'","RACE='WHITE'" ,"SEX='MALE'", "SEX='FEMALE'", "REGION='JAPAN'", "REGION='USA'"]
measure = [q1_, q2_, q3_, q4_, q5_, q6_]
lower = [ci_low1, ci_low2, ci_low3, ci_low4, ci_low5, ci_low6]
upper = [ci_upp1, ci_upp2, ci_upp3, ci_upp4, ci_upp5, ci_upp6]

p = EffectMeasurePlot(label=labs, effect_measure=measure, lcl=lower, ucl=upper)
p.labels(effectmeasure='ORR')
p.colors(pointshape="o")
ax=p.plot(figsize=(7,3), t_adjuster=0.05, max_value=100, min_value=0 )
plt.tight_layout()
plt.title("Forest plot for ORR")
plt.show()

