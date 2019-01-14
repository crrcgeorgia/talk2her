// Replication code -- models

// Talk to Her: How Party-voter Linkages Increase Partisanship in Georgia
// Koba Turmanidze

// This publication uses the panel component of June 2016 and November 2016 survey waves 
// Surveys are carried out by CRRC-Georgia on behalf of NDI
// Survey data and documentation can be downloaded from https://caucasusbarometer.org/en/downloads

*******************************************************************************

********************************************************************************

graph set window fontface "Times New Roman"

*** Contrast marginal effects positieve and negative partisanship(s) 

clear all
use "Merged_Wave_24_25_recoded_wide_2608.dta", replace

***
local wave_24 i.hhcond24 i.dire24 i.gchange24 i.euappr24 i.turn_pre ///
i.expend224 c.poss24 i.empl224 i.edu224 i.female i.agegr i.settype i.attint24

local wave_25 i.hhcond25 i.dire25 i.gchange25 i.euappr25 i.knowmp25 i.turn_post ///
i.expend225 c.poss25 i.empl225 i.edu225 i.female i.agegr i.settype i.attint25

*** Model 1 -- Pre-election POSITIVE partisanship
qui: logit pid_25a i.cn i.pid_24c `wave_24', vce (cluster psu)
qui: margins pid_24c, pwcompare(pveffects sort) mcompare(sidak) post asobserved vce(unconditional)

marginsplot, name(a, replace) ///
horizontal unique xline(0, lcolor(red) lwidth(thin) lpattern(dash)) ///
recast(scatter) yscale(reverse) ///
title("(a) Positive partisanship (wave 24 covar)", color(dknavy*.8) tstyle(size(msmall)) span) ///
graphregion(color(white)) ///
xlabel(-.4(.1).4) xtitle(Comparisons of Pr(Partisanship), color(dknavy*.8) tstyle(size(small))) ///
plot1opts(lpatt(solid) lwidth(thin) lcolor(navy) mcolor(navy) msym(d) mcol(navy))

qui: logit pid_25a i.cn i.pid_24c `wave_25', vce (cluster psu)
qui: margins pid_24c, pwcompare(pveffects sort) mcompare(sidak) post asobserved vce(unconditional)

marginsplot, name(b, replace) ///
horizontal unique xline(0, lcolor(red) lwidth(thin) lpattern(dash)) ///
recast(scatter) yscale(reverse) ///
title("(b) Positive partisanship (wave 25 covar)", color(dknavy*.8) tstyle(size(msmall)) span) ///
graphregion(color(white)) ///
xlabel(-.4(.1).4) xtitle(Comparisons of Pr(Partisanship), color(dknavy*.8) tstyle(size(small))) ///
plot1opts(lpatt(solid) lwidth(thin) lcolor(navy) mcolor(navy) msym(d) mcol(navy))

graph combine a b


*** Model 2 -- Pre-election NEGATIVE partisanship
qui: logit pid_25a i.cn i.voten_24c `wave_24', vce (cluster psu)
qui: margins voten_24c, pwcompare(pveffects sort) mcompare(sidak) post asobserved vce(unconditional)

marginsplot, name(c, replace) ///
horizontal unique xline(0, lcolor(red) lwidth(thin) lpattern(dash)) ///
recast(scatter) yscale(reverse) ///
title("(c) Negative partisanship (wave 24 covar)", color(dknavy*.8) tstyle(size(msmall)) span) ///
graphregion(color(white)) ///
xlabel(-.4(.1).4) xtitle(Comparisons of Pr(Partisanship), color(dknavy*.8) tstyle(size(small))) ///
plot1opts(lpatt(solid) lwidth(thin) lcolor(navy) mcolor(navy) msym(d) mcol(navy))

qui: logit pid_25a i.cn i.voten_24c `wave_25', vce (cluster psu)
qui: margins voten_24c, pwcompare(pveffects sort) mcompare(sidak) post asobserved vce(unconditional)

marginsplot, name(d, replace) ///
horizontal unique xline(0, lcolor(red) lwidth(thin) lpattern(dash)) ///
recast(scatter) yscale(reverse) ///
title("(d) Negative partisanship (wave 25 covar)", color(dknavy*.8) tstyle(size(msmall)) span) ///
graphregion(color(white)) ///
xlabel(-.4(.1).4) xtitle(Comparisons of Pr(Partisanship), color(dknavy*.8) tstyle(size(small))) ///
plot1opts(lpatt(solid) lwidth(thin) lcolor(navy) mcolor(navy) msym(d) mcol(navy))

graph combine c d

///////////////////////////////////////////////////////////////////////////////

///// Graph 1 -- Covariates of partisanship -- all parties
///////////////////////////////////////////////////////////////////////////////

clear all
use "Merged_Wave_24_25_recoded_wide_2608.dta", replace

*** covariates -- wave 25
local wave_25 i.hhcond25 i.dire25 i.gchange25 i.euappr25 i.knowmp25 ///
i.expend225 c.poss25 i.empl225 i.edu225 i.female i.agegr i.settype i.attint25

*** Model 1 -- lagged POSITIVE partisanship -- pre-election  
qui: logit pid_25a i.cn i.pid_24a i.turn_pre `wave_25', vce (cluster psu)
qui: margins, dydx(*) post
est store Positive

*** Model 2 -- lagged NEGATIVE partisanship -- pre-election 
qui: logit pid_25a i.cn i.voten_24a i.turn_pre `wave_25', vce (cluster psu)
qui: margins, dydx(*) post
est store Negative

***
coefplot ///
(Positive, label("") lpatt(solid)lcol(ebblue)msym(d)mcol(ebblue)ciopts(lpatt(solid)lcol(ebblue)lwidth(thin))) || ///
(Negative, label("") lpatt(solid)lcol(ebblue)msym(d)mcol(ebblue)ciopts(lpatt(solid)lcol(ebblue)lwidth(thin))), ///
plotlabels() bylabels("Model 1" "Model 2") ///
drop(_cons 3.pid_24c 3.voten_24c 3.votew_24c) xscale(r(-.2 .25)) xlabel(-.2 "-.2" -.1 "-.1" 0 "0" .1 ".1" .2 ".2") ///
xline(0, lcolor(orange) lwidth(thin) lpattern(dash)) ///
xtitle(Effects on probability of partisanship) levels(95) nobaselevels ///
order(1.cn 1.pid_24a 1.voten_24a 1.votew_gd ///
1.hhcond25 1.dire25 1.gchange25 1.euappr25 1.knowmp25 1.turn_pre ///
1.edu225 1.empl225 poss25 1.expend225 1.attint25 1.agegr 2.agegr 1.female ///
1.settype 2.settype 3.settype) ///
coeflabels(1.cn="Contacted during campaign" ///
1.pid_24a="Lagged partisanship (positive)" 1.voten_24a="Lagged partisanship (negative)" ///
1.hhcond25="Improved HH conditions" 1.dire25="Country's direction right" ///
1.gchange25="Government approval" 1.euappr25="EU membership approval" 1.knowmp25="Political knowledge" 1.turn_pre="Political participation" ///
1.edu225="Tertiary education" 1.empl225="Employed" poss25="Posession of durable goods" ///
1.attint25="Not alone at the interview" 1.agegr="Age 38 to 57" 2.agegr="Age 58 and older" ///
1.female="Female" 1.settype="Capital" 2.settype="Rural" 3.settype="Minority", ///
wrap(40) notick labcolor(black*.8) labsize(vsmall) labgap(2)) /// 
byopt(rows(1) graphregion(color(white)) ///
title("Graph 1. Covariates of post-election partisanship", color(dknavy*.9) tstyle(size(mlarge)) span) ///
subtitle("Marginal effects. Logit estimates of panel data, 95% CIs", color(dknavy*.8) tstyle(size(msmall)) span) ///
note("NDI/CRRC 2016"))

***
graph export "Graph_1.png", width(3000) replace 
**********************************************************************************************************

///// Graph 1a -- Covariates of partisanship -- GD and UNM
/////////////////////////////////////////////////////////////////////////////// 
clear all
use "Merged_Wave_24_25_recoded_wide_2608.dta", replace

*** covariates -- wave 25
local wave_25 i.hhcond25 i.dire25 i.gchange25 i.euappr25 i.knowmp25 ///
i.expend225 c.poss25 i.empl225 i.edu225 i.female i.agegr i.settype i.attint25

*** Model 1 -- lagged POSITIVE partisanship -- pre-election 
qui: mlogit pid_25c i.cn i.pid_24a i.turn_pre `wave_25', vce (cluster psu)
qui margins, dydx(*) predict(outcome(1)) post
est store Positive_GD

qui: mlogit pid_25c i.cn i.pid_24a i.turn_pre `wave_25', vce (cluster psu)
qui margins, dydx(*) predict(outcome(2)) post
est store Positive_UNM

*** Model 2 -- lagged NEGATIVE partisanship -- pre-election 
qui: mlogit pid_25c i.cn i.voten_24a i.turn_pre `wave_25', vce (cluster psu)
qui margins, dydx(*) predict(outcome(1)) post
est store Negative_GD

qui: mlogit pid_25c i.cn i.voten_24a i.turn_pre `wave_25', vce (cluster psu)
qui margins, dydx(*) predict(outcome(2)) post
est store Negative_UNM

***
coefplot ///
(Positive_GD, lpatt(solid)lcol(blue)msym(d)mcol(blue)ciopts(lpatt(solid)lcol(blue)lwidth(thin))) ///
(Positive_UNM, lpatt(solid)lcol(maroon)msym(t)mcol(maroon)ciopts(lpatt(solid)lcol(maroon)lwidth(thin))) || ///
(Negative_GD, lpatt(solid)lcol(blue)msym(d)mcol(blue)ciopts(lpatt(solid)lcol(blue)lwidth(thin))) ///
(Negative_UNM, lpatt(solid)lcol(maroon)msym(t)mcol(maroon)ciopts(lpatt(solid)lcol(maroon)lwidth(thin))), ///
plotlabels() bylabels("Model 1" "Model 2" "Model 3") ///
drop(_cons 3.pid_24c 3.voten_24c 3.votew_24c 1.edu225 1.empl225 poss25 ///
1.expend225 1.attint25 1.agegr 2.agegr 1.female 1.settype 2.settype 3.settype) ///
xscale(r(-.2 .2)) xlabel(-.2 "-.2" 0 "0" .2 ".2") ///
xline(0, lcolor(orange) lwidth(thin) lpattern(dash)) ///
xtitle(Effects on Probability of partisanship) levels(95) nobaselevels ///
order(1.cn 1.pid_24a 1.voten_24a 1.votew_gd ///
1.hhcond25 1.dire25 1.gchange25 1.euappr25 1.knowmp25 1.turn_pre ///
1.edu225 1.empl225 poss25 1.expend225 1.attint25 1.agegr 2.agegr 1.female ///
1.settype 2.settype 3.settype) ///
coeflabels(1.cn="Contacted during campaign" ///
1.pid_24a="Lagged partisanship (positive)" 1.voten_24a="Lagged partisanship (negative)" ///
1.hhcond25="Improved HH conditions" 1.dire25="Country's direction right" ///
1.gchange25="Government approval" 1.euappr25="EU membership approval" 1.knowmp25="Political knowledge" 1.turn_pre="Political participation" ///
1.edu225="Tertiary education" 1.empl225="Employed" poss25="Posession of durable goods" ///
1.attint25="Not alone at the interview" 1.agegr="Age 38 to 57" 2.agegr="Age 58 and older" ///
1.female="Female" 1.settype="Capital" 2.settype="Rural" 3.settype="Minority", ///
wrap(40) notick labcolor(black*.8) labsize(vsmall) labgap(2)) /// 
byopt(rows(1) graphregion(color(white)) ///
title("Graph 1a. Covariates of post-election partisanship", color(dknavy*.9) tstyle(size(mlarge)) span) ///
subtitle("Marginal effects. Multinomial logit estimates of panel data, 95% CIs", color(dknavy*.8) tstyle(size(msmall)) span) ///
note("NDI/CRRC 2016")) ///
legend(label(2 "Georgian Dream")label(4 "United National Movement") order(2 4) pos(6) rows(1) region(lcolor(white)))

***
graph export "Graph_1a.png", width(3000) replace  
**********************************************************************************************************

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>**<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<**>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


///// Graph 4 -- Instrumenla variable models
//// Seemingly unrelated bivariate 2SLS 
////////////////////////////////////////////////////////////////////////////////

clear all
use "Merged_Wave_24_25_recoded_wide_2608.dta", replace

egen respass_std=std(respass)

** 2nd covariates 
local stage_2 i.hhcond25 i.dire25 i.gchange25 i.euappr25 i.knowmp25 i.turn_pre ///
i.expend225 c.poss25 i.empl225 i.edu225 i.female i.agegr i.settype i.attint25

// Biprobit & 2SLS models

** lagged POSITIVE partisanship -- pre-election 
qui: biprobit (pid_25a = i.cn pid_24a `stage_2') (pid_24a = c.respass_std), cluster(psu)
qui margins, dydx(*) predict(pmarg1) force post
est store M1a

*** lagged NEGATIVE partisanship -- pre-election
qui: biprobit (pid_25a = i.cn voten_24a `stage_2') (voten_unm = c.respass_std), cluster(psu)
qui margins, dydx(*) predict(pmarg1) force post
est store M2a

***
coefplot (M1a, label("") lpatt(solid)lcol(ebblue)msym(d)mcol(ebblue)ciopts(lpatt(solid)lcol(ebblue))) ///
|| M2a, ///
plotlabels() bylabels("Model 1" "Model 2" "Model 3") ///
name() ///
drop(_cons 1.edu225 1.empl225 poss25 ///
1.expend225 1.attint25 1.agegr 2.agegr 1.female 1.settype 2.settype 3.settype) ///
xscale(r(-.05 .4)) xlabel(0 "0" .1 ".1" .2 ".2" .3 ".3") ///
xline(0, lcolor(orange) lwidth(thin) lpattern(dash)) ///
xtitle(Effects on probability of partisanship) levels(95) nobaselevels ///
order(1.cn pid_24a voten_24a votew_gd ///
1.hhcond25 1.dire25 1.gchange25 1.euappr25 1.knowmp25 1.turn_pre ///
1.edu225 1.empl225 poss25 1.expend225 1.attint25 1.agegr 2.agegr 1.female ///
1.settype 2.settype 3.settype) ///
coeflabels(1.cn="Contacted during campaign" ///
pid_24a="Lagged partisanship (positive)" voten_24a="Lagged partisanship (negative)" ///
1.hhcond25="Improved HH conditions" 1.dire25="Country's direction right" ///
1.gchange25="Government approval" 1.euappr25="EU membership approval" 1.knowmp25="Political knowledge" 1.turn_pre="Political participation" ///
1.edu225="Tertiary education" 1.empl225="Employed" poss25="Posession of durable goods" ///
1.attint25="Not alone at the interview" 1.agegr="Age 38 to 57" 2.agegr="Age 58 and older" ///
1.female="Female" 1.settype="Capital" 2.settype="Rural" 3.settype="Minority", ///
wrap(40) notick labcolor(black*.8) labsize(vsmall) labgap(2)) /// 
byopt(rows(1) graphregion(color(white)) ///
title("Graph 4. Marginal effects of covariates on post-election partisanship", color(dknavy*.9) tstyle(size(mlarge)) span) ///
subtitle("Bivariate probit estimates of panel data, 95% CIs", color(dknavy*.8) tstyle(size(msmall)) span) ///
note("NDI/CRRC 2016"))

graph export "Graph_4.png", width(3000) replace 
**************************************************************************************************************

///// Graph 4a -- Instrumenla variable models
//// Seemingly unrelated bivariate probit & 2SLS 
////////////////////////////////////////////////////////////////////////////////

clear all
use "Merged_Wave_24_25_recoded_wide_2608.dta", replace

egen respass_std=std(respass)

** 2nd covariates 
local stage_2 i.hhcond25 i.dire25 i.gchange25 i.euappr25 i.knowmp25 i.turn_pre ///
i.expend225 c.poss25 i.empl225 i.edu225 i.female i.agegr i.settype i.attint25

// Biprobit & 2SLS models

** lagged POSITIVE partisanship -- pre-election 
qui: biprobit (pid_25a = i.cn pid_24a `stage_2') (pid_24a = c.respass_std), cluster(psu)
qui margins, dydx(*) predict(pmarg1) force post
est store M1a

qui: ivreg2 pid_25a i.cn `stage_2' (pid_24a = c.respass_std), first cluster(psu)
qui margins, dydx(*) force post
est store M1b

*** lagged NEGATIVE partisanship -- pre-election
qui: biprobit (pid_25a = i.cn voten_24a `stage_2') (voten_unm = c.respass_std), cluster(psu)
qui margins, dydx(*) predict(pmarg1) force post
est store M2a

qui: ivreg2 pid_25a i.cn `stage_2' (voten_24a = c.respass_std), first cluster(psu)
qui margins, dydx(*) post
est store M2b

***
coefplot (M1a, label("Biprobit") lpatt(solid)lcol(ebblue)msym(d)mcol(ebblue)ciopts(lpatt(solid)lcol(ebblue))) ///
(M1b, label("2SLS") lpatt(solid)lcol(eltgreen)msym(t)mcol(eltgreen)ciopts(lpatt(solid)lcol(eltgreen))) ///
|| M2a M2b, ///
plotlabels() bylabels("Model 1" "Model 2") ///
name() ///
drop(_cons 1.edu225 1.empl225 poss25 ///
1.expend225 1.attint25 1.agegr 2.agegr 1.female 1.settype 2.settype 3.settype) ///
xscale(r(-.1 .6)) xlabel(0 "0" .2 ".2" .4 ".4" .6 ".6") ///
xline(0, lcolor(orange) lwidth(thin) lpattern(dash)) ///
xtitle(Effects on probability of partisanship) levels(95) nobaselevels ///
order(1.cn pid_24a voten_24a votew_gd ///
1.hhcond25 1.dire25 1.gchange25 1.euappr25 1.knowmp25 1.turn_pre ///
1.edu225 1.empl225 poss25 1.expend225 1.attint25 1.agegr 2.agegr 1.female ///
1.settype 2.settype 3.settype) ///
coeflabels(1.cn="Contacted during campaign" ///
pid_24a="Lagged partisanship (positive)" voten_24a="Lagged partisanship (negative)" ///
1.hhcond25="Improved HH conditions" 1.dire25="Country's direction right" ///
1.gchange25="Government approval" 1.euappr25="EU membership approval" 1.knowmp25="Political knowledge" 1.turn_pre="Political participation" ///
1.edu225="Tertiary education" 1.empl225="Employed" poss25="Posession of durable goods" ///
1.attint25="Not alone at the interview" 1.agegr="Age 38 to 57" 2.agegr="Age 58 and older" ///
1.female="Female" 1.settype="Capital" 2.settype="Rural" 3.settype="Minority", ///
wrap(40) notick labcolor(black*.8) labsize(vsmall) labgap(2)) /// 
byopt(rows(1) graphregion(color(white)) ///
title("Graph 4a. Marginal effects of covariates on post-election partisanship", color(dknavy*.9) tstyle(size(mlarge)) span) ///
subtitle("Instrumental variable estimates of panel data, 95% CIs", color(dknavy*.8) tstyle(size(msmall)) span) ///
note("NDI/CRRC 2016")) ///
legend(label(2 "BIPROBIT")label(4 "2SLS") order(2 4) pos(6) rows(1) region(lcolor(white)))

graph export "Graph_4a.png", width(3000) replace 
**************************************************************************************************************

///// Graph 5 -- Heterogenous treatment effects -- all parties
//// Seemingly unrelated bivariate probit models
////////////////////////////////////////////////////////////////////////////////

//  Marginal effects of party contacts on partisanship

clear all
use "Merged_Wave_24_25_recoded_wide_2608.dta", replace

egen respass_std=std(respass)

** 2nd stage covariates 
local stage_2 i.hhcond25 i.dire25 i.gchange25 i.euappr25 i.knowmp25 i.turn_pre ///
i.expend225 c.poss25 i.empl225 i.edu225 i.female i.agegr i.settype i.attint25

** lagged POSITIVE partisanship -- pre-election
qui: biprobit (pid_25a = i.cn##i.pid_24a `stage_2') (pid_24a = c.respass_std), cluster(psu)
qui margins, dydx(cn) at (pid_24a=(0 1)) predict(pmarg1) force post
est store M1

*** lagged NEGATIVE partisanship -- pre-election
qui: biprobit (pid_25a = i.cn##i.voten_24a `stage_2') (voten_24a = c.respass_std), cluster(psu)
qui margins, dydx(cn) at (voten_24a=(0 1)) predict(pmarg1) force post
est store M2

***
coefplot M1 || M2, ///
plotlabels() bylabels("Positive partisanship" "Negative partisanship") ///
name(BIPR1, replace) ///
drop(_cons) ///
xscale(r(-.1 .25)) xline(0, lcolor("orange") lwidth(vthin) lpattern(dash)) ///
xlabel(0 "0" .1 ".1" .2 ".2") xtitle(Effects on probability of partisanship) levels(95) nobaselevels ///
order(2._at 1._at) ///
coeflabels(2._at="Yes" 1._at="No", ///
wrap(40) notick labcolor(black*.8) labsize(small) labgap(1)) /// 
byopt(rows(1) graphregion(color(white)) ///
title("Graph 5. Marginal effects of contacts by lagged partisanship", color(dknavy*.9) tstyle(size(mlarge)) span) ///
subtitle("Bivariate probit estimates of panel data, 95% CIs", color(dknavy*.8) tstyle(size(msmall)) span) ///
graphregion(color(white)) ///
note("NDI/CRRC 2016"))

***
graph export "Graph_5.png", width(3000) replace 
*********************************************************************************************************************************


///// Graph 8 -- Heterogenous treatment effects -- GD and UNM 
//// Seemingly unrelated bivariate probit models
////////////////////////////////////////////////////////////////////////////////

clear all
use "Merged_Wave_24_25_recoded_wide_2608.dta", replace

egen respass_std=std(respass)

** 2nd stage covariates 
local stage_2 i.hhcond25 i.dire25 i.gchange25 i.euappr25 i.knowmp25 i.turn_pre ///
i.expend225 c.poss25 i.empl225 i.edu225 i.female i.agegr i.settype i.attint25

** lagged POSITIVE partisanship -- pre-election
qui: biprobit (pid_25_gd = i.cn##i.pid_24a `stage_2') (pid_24a = c.respass_std), cluster(psu)
qui margins, dydx(cn) at (pid_24a=(0 1)) predict(pmarg1) force post
est store M1a

qui: biprobit (pid_25_unm = i.cn##i.pid_24a `stage_2') (pid_24a = c.respass_std), cluster(psu)
qui margins, dydx(cn) at (pid_24a=(0 1)) predict(pmarg1) force post
est store M1b

*** lagged NEGATIVE partisanship -- pre-election
qui: biprobit (pid_25_gd = i.cn##i.voten_24a `stage_2') (voten_unm = c.respass_std), cluster(psu)
qui margins, dydx(cn) at (voten_24a=(0 1)) predict(pmarg1) force post
est store M2a

qui: biprobit (pid_25_unm = i.cn##i.voten_24a `stage_2') (voten_unm = c.respass_std), cluster(psu)
qui margins, dydx(cn) at (voten_24a=(0 1)) predict(pmarg1) force post
est store M2b

***
coefplot (M1a, label("Georgian Dream") lpatt(solid)lcol(blue)msym(d)mcol(blue)ciopts(lpatt(solid)lcol(blue))) ///
(M1b, label("United National Movement") lpatt(solid)lcol(maroon)msym(t)mcol(maroon)ciopts(lpatt(solid)lcol(maroon))) ///
|| M2a M2b, ///
plotlabels() bylabels("Positive partisanship" "Negative partisanship") ///
name(BIPR2, replace) ///
drop(_cons) ///
xscale(r(-.1 .25)) xline(0, lcolor("orange") lwidth(vthin) lpattern(dash)) ///
xlabel(0 "0" .1 ".1" .2 ".2") xtitle(Effects on probability of partisanship) levels(95) nobaselevels ///
order(2._at 1._at) ///
coeflabels(2._at="Yes" 1._at="No", ///
wrap(40) notick labcolor(black*.8) labsize(small) labgap(1)) /// 
byopt(rows(1) graphregion(color(white)) ///
title("Graph 8. Marginal effects of contacts by type of lagged partisanship", color(dknavy*.9) tstyle(size(mlarge)) span) ///
subtitle("Bivariate probit estimates of panel data, 95% CIs", color(dknavy*.8) tstyle(size(msmall)) span) ///
note("NDI/CRRC 2016")) ///
legend(label(2 "Georgian Dream")label(4 "United National Movement") order(2 4) pos(6) rows(1) region(lcolor(white)))

***
graph export "Graph_8.png", width(3000) replace 
*********************************************************************************************************************************
