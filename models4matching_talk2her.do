// Replication code -- models

// Talk to Her: How Party-voter Linkages Increase Partisanship in Georgia
// Koba Turmanidze

// This publication uses November 2012 and November 2016 survey waves
// Surveys are carried out by CRRC-Georgia on behalf of NDI
// Survey data and documentation can be downloaded from https://caucasusbarometer.org/en/downloads

*******************************************************************************

///// Graph 2. Marginal effects of covariates of partisanship // 2012 and 2016 matched data
///// Nearest Neighbor and Mahalanobis matching
///////////////////////////////////////////////////////////////////////////////////////////

graph set window fontface "Times New Roman"

clear all
use "wave_12_16_appended.dta", replace

local match_var i.cn ///
i.hhcond i.dire i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype   

***
qui: logistic pid_a1 `match_var' if appendcode==1, vce(cluster psu)
qui: margins, dydx(*) post
est store m1

***
qui: logistic pid_a1 `match_var' if appendcode==2, vce(cluster psu)
qui: margins, dydx(*) post
est store m2

***
qui: logistic pid_a1 `match_var' if appendcode==3, vce(cluster psu)
qui: margins, dydx(*) post
est store m3

/////////

***
qui: logistic pid_a1 `match_var' if appendcode==4, vce(cluster psu)
qui: margins, dydx(*) post
est store m4

***
qui: logistic pid_a1 `match_var' if appendcode==5, vce(cluster psu)
qui: margins, dydx(*) post
est store m5

***
qui: logistic pid_a1 `match_var' if appendcode==6, vce(cluster psu)
qui: margins, dydx(*) post
est store m6

***
coefplot (m1, label("") lpatt(solid)lwidth(none)lcol(erose)msym(d)mcol(erose)ciopts(lpatt(solid)lcol(erose))) ///
(m2, label("") lpatt(solid)lwidth(none)lcol(ebblue)msym(d)mcol(ebblue)ciopts(lpatt(solid)lcol(ebblue))) ///
(m3, label("") lpatt(solid)lwidth(none)lcol(eltgreen)msym(t)mcol(eltgreen)ciopts(lpatt(thin)lcol(eltgreen))) || ///
(m4, label("") lpatt(solid)lwidth(none)lcol(erose)msym(d)mcol(erose)ciopts(lpatt(solid)lcol(erose))) ///
(m5, label("") lpatt(solid)lwidth(none)lcol(ebblue)msym(d)mcol(ebblue)ciopts(lpatt(solid)lcol(ebblue))) ///
(m6, label("") lpatt(solid)lwidth(none)lcol(eltgreen)msym(t)mcol(eltgreen)ciopts(lpatt(thin)lcol(eltgreen))), ///
plotlabels("Pre-matched" "Nearest Neighbor" "Mahalanobis") bylabels("2012" "2016") ///
drop(_cons 1.settype 2.settype 3.settype 1.female 1.agegr20 2.agegr20 1.edu2 1.empl2 1.expend2) ///
xscale(r(-.2 .3)) xline(0, lcolor("orange") lwidth(vthin) lpattern(dash)) ///
xlabel(-.2 "-.2" -.1 "-.1" 0 "0" .1 ".1" .2 ".2") ///
xtitle(Effects on Probability of partisanship) levels(95) nobaselevels ///
orderby(:3) ///
coeflabels(1.cn="Contacted during campaign" ///
1.settype="Capital" 2.settype="Rural" 3.settype="Minority" ///
1.female="Female" ///
1.agegr20="Age 38 to  57" 2.agegr20="Age 58 and older" ///
1.edu2="Tertiary education" ///
1.empl2="Employed" ///
1.hhcond="Improved HH conditions" ///
1.gchange="Government approval" ///
1.dire="Country's direction right" ///
1.euappr="EU membership approval" ///
1.turn_post="Political participation" ///
1.knowmp="Political knowledge", ///
wrap(40) notick labcolor(black*.8) labsize(small) labgap(2)) /// 
byopt(rows(1) graphregion(color(white)) legend(region(lcolor(white)) rows(1)) ///
title("Graph 2. Marginal effects of covariates on post-election partisanship", color(dknavy*.9) tstyle(size(mlarge)) span) ///
subtitle("Logit estimates of matched data, 95% CIs", color(dknavy*.8) tstyle(size(msmall)) span) ///
note("NDI/CRRC 2012; NDI/CRRC 2016")) ///
legend(pos(6) rows(1) region(lcolor(white)))


graph export "Graph_2.png", width(3000) replace 
*******************************************************************************

///// Graph 3. Heterogenous treatment effects -- partisanship 
///// Mahalanobis
/////////////////////////////////////////////////////////////////////////////////


/// 2012

clear all
use "wave_12_16_appended.dta", replace

local match_var i.cn ///
i.hhcond i.dire i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype  

/// 2012

***
qui: logit pid_a1 i.cn##i.hhcond i.dire i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
margins, dydx(cn) at (hhcond=(0 1)) post
est store m1

***
qui: logit pid_a1 i.cn##i.dire i.hhcond i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
margins, dydx(cn) at (dire=(0 1)) post
est store m2

***
qui: logit pid_a1 i.cn##i.gchange i.hhcond i.dire i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
margins, dydx(cn) at (gchange=(0 1)) post
est store m3

***
qui: logit pid_a1 i.cn##i.euappr i.hhcond i.dire i.gchange ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
margins, dydx(cn) at (euappr=(0 1)) post
est store m4

***
qui: logit pid_a1 i.cn##i.knowmp i.hhcond i.dire i.gchange i.euappr ///
i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
margins, dydx(cn) at (knowmp=(0 1)) post
est store m5

***
qui: logit pid_a1 i.cn##i.turn_post i.hhcond i.dire i.gchange i.euappr ///
i.knowmp ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
margins, dydx(cn) at (turn_post=(0 1)) post
est store m6

coefplot m1 || m2 || m3 || m4 || m5 || m6, ///
plotlabels() bylabels("HH conditions improved?" ///
"Country's direction right?" ///
"Government approval" ///
"EU membership approval" ///
"Political knowledge" ///
"Political participation") ///
name(m_2012) ///
drop(_cons) ///
xscale(r(-.15 .3)) xline(0, lcolor("orange") lwidth(vthin) lpattern(dash)) ///
xlabel(-.1 "-.1" 0 "0" .1 ".1" .2 ".2") /// 
xtitle(Effects on Probability of partisanship) levels(95) nobaselevels ///
order(2._at 1._at) ///
coeflabels(2._at="Yes" 1._at="No", ///
wrap(40) notick labcolor(black*.8) labsize(small) labgap(1)) /// 
byopt(rows(4) graphregion(color(white)) ///
title("2012"))

/// 2016

***
qui: logit pid_a1 i.cn##i.hhcond i.dire i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
margins, dydx(cn) at (hhcond=(0 1)) post
est store m7

***
qui: logit pid_a1 i.cn##i.dire i.hhcond i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
margins, dydx(cn) at (dire=(0 1)) post
est store m8

***
qui: logit pid_a1 i.cn##i.gchange i.hhcond i.dire i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
margins, dydx(cn) at (gchange=(0 1)) post
est store m9

***
qui: logit pid_a1 i.cn##i.euappr i.hhcond i.dire i.gchange ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
margins, dydx(cn) at (euappr=(0 1)) post
est store m10

***
qui: logit pid_a1 i.cn##i.knowmp i.hhcond i.dire i.gchange i.euappr ///
i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
margins, dydx(cn) at (knowmp=(0 1)) post
est store m11

***
qui: logit pid_a1 i.cn##i.turn_post i.hhcond i.dire i.gchange i.euappr ///
i.knowmp ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
margins, dydx(cn) at (turn_post=(0 1)) post
est store m12

coefplot m7 || m8 || m9 || m10 || m11 || m12, ///
plotlabels() bylabels("HH conditions improved?" ///
"Country's direction right?" ///
"Government approval" ///
"EU membership approval" ///
"Political knowledge" ///
"Political participation") ///
name(m_2016) ///
drop(_cons) ///
xscale(r(-.15 .3)) xline(0, lcolor("orange") lwidth(vthin) lpattern(dash)) ///
xlabel(-.1 "-.1" 0 "0" .1 ".1" .2 ".2") ///
xtitle(Effects on Probability of partisanship) levels(95) nobaselevels ///
order(2._at 1._at) ///
coeflabels(2._at="Yes" 1._at="No", ///
wrap(40) notick labcolor(black*.8) labsize(small) labgap(1)) /// 
byopt(rows(4) graphregion(color(white)) ///
title("2016"))

graph combine m_2012 m_2016, ///
title("Graph 3. Marginal effects of contacts on post-election partisanship", color(dknavy*.9) tstyle(size(mlarge)) span) ///
subtitle("Logit estimates of matched data, 95% CIs", color(dknavy*.8) tstyle(size(msmall)) span) ///
graphregion(color(white)) ///
note("NDI/CRRC 2012; NDI/CRRC 2016") 

graph export "Graph_3.png", width(3000) replace 
*****************************************************************************************************************************

///// Graph 6. Treatment effects -- party identification 
/////////////////////////////////////////////////////////////////////////////////

clear all
use "wave_12_16_appended.dta", replace


/// 2012

local match_var i.cn ///
i.hhcond i.dire i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype   

***
qui: mlogit pid_b1 `match_var' if appendcode==2, vce(cluster psu)
qui: margins, dydx(cn) predict(outcome(0)) post
estimates store n1_12

***
qui: mlogit pid_b1 `match_var' if appendcode==2, vce(cluster psu)
qui: margins, dydx(cn) predict(outcome(1)) post
estimates store n2_12

***
qui: mlogit pid_b1 `match_var' if appendcode==2, vce(cluster psu)
qui: margins, dydx(cn) predict(outcome(2)) post
estimates store n3_12

///

***
qui: mlogit pid_b1 `match_var' if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) predict(outcome(0)) post
estimates store m1_12

***
qui: mlogit pid_b1 `match_var' if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) predict(outcome(1)) post
estimates store m2_12

***
qui: mlogit pid_b1 `match_var' if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) predict(outcome(2)) post
estimates store m3_12

***
coefplot (n1_12, label("") lpatt(solid)lcol(lavender)msym(o)mcol(lavender)ciopts(lpatt(solid)lcol(lavender))) ///
(n2_12, label("") lpatt(solid)lcol(blue)msym(d)mcol(blue)ciopts(lpatt(solid)lcol(blue))) ///
(n3_12, label("") lpatt(solid)lcol(maroon)msym(t)mcol(maroon)ciopts(lpatt(solid)lcol(maroon))) || ///
(m1_12, label("") lpatt(solid)lcol(lavender)msym(o)mcol(lavender)ciopts(lpatt(solid)lcol(lavender))) ///
(m2_12, label("") lpatt(solid)lcol(blue)msym(d)mcol(blue)ciopts(lpatt(solid)lcol(blue))) ///
(m3_12, label("") lpatt(solid)lcol(maroon)msym(t)mcol(maroon)ciopts(lpatt(solid)lcol(maroon))), ///
plotlabels("Nonpartisan" "GD" "UNM") bylabels("Nearest Neighbor Matching" "Mahalanobis Matching") ///
name(m_2012, replace) ///
drop(_cons) ///
xscale(r(-.22 .3)) xline(0, lcolor("orange") lwidth(vthin) lpattern(dash)) ///
ylabel(none) ytitle() ///
xlabel(-.2 "-.2" -.1 "-.1" 0 "0" .1 ".1" .2 ".2") xtitle(Effects on Probability of partisanship) levels(95) nobaselevels ///
orderby(:4) ///
coeflabels(, ///
wrap(40) notick labcolor(black*.8) labsize(small) labgap(2)) /// 
byopt(cols(1) graphregion(color(white)) ///
title("2012")) ///
legend(label(2 "Nonpartisan") label(4 "Georgian Dream") label(6 "United National Movement")order(4 6 2) pos(6) rows(2) region(lcolor(white)))

/// 2016

local match_var i.cn ///
i.hhcond i.dire i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype   

***
qui: mlogit pid_c1 `match_var' if appendcode==5, vce(cluster psu)
qui: margins, dydx(cn) predict(outcome(0)) post
estimates store n1_16

***
qui: mlogit pid_c1 `match_var' if appendcode==5, vce(cluster psu)
qui: margins, dydx(cn) predict(outcome(1)) post
estimates store n2_16

***
qui: mlogit pid_c1 `match_var' if appendcode==5, vce(cluster psu)
qui: margins, dydx(cn) predict(outcome(2)) post
estimates store n3_16

///

***
qui: mlogit pid_c1 `match_var' if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) predict(outcome(0)) post
estimates store m1_16

***
qui: mlogit pid_c1 `match_var' if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) predict(outcome(1)) post
estimates store m2_16

***
qui: mlogit pid_c1 `match_var' if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) predict(outcome(2)) post
estimates store m3_16

***
coefplot (n1_16, label("") lpatt(solid)lcol(lavender)msym(o)mcol(lavender)ciopts(lpatt(solid)lcol(lavender))) ///
(n2_16, label("") lpatt(solid)lcol(blue)msym(d)mcol(blue)ciopts(lpatt(solid)lcol(blue))) ///
(n3_16, label("") lpatt(solid)lcol(maroon)msym(t)mcol(maroon)ciopts(lpatt(solid)lcol(maroon))) || ///
(m1_16, label("") lpatt(solid)lcol(lavender)msym(o)mcol(lavender)ciopts(lpatt(solid)lcol(lavender))) ///
(m2_16, label("") lpatt(solid)lcol(blue)msym(d)mcol(blue)ciopts(lpatt(solid)lcol(blue))) ///
(m3_16, label("") lpatt(solid)lcol(maroon)msym(t)mcol(maroon)ciopts(lpatt(solid)lcol(maroon))), ///
plotlabels("Nonpartisan" "GD" "UNM") bylabels("Nearest Neighbor Matching" "Mahalanobis Matching") ///
name(m_2016, replace) ///
drop(_cons) ///
xscale(r(-.22 .3)) xline(0, lcolor("orange") lwidth(vthin) lpattern(dash)) ///
ylabel(none) ytitle() ///
xlabel(-.2 "-.2" -.1 "-.1" 0 "0" .1 ".1" .2 ".2") xtitle(Effects on Probability of partisanship) levels(95) nobaselevels ///
orderby(:4) ///
coeflabels(, ///
wrap(40) notick labcolor(black*.8) labsize(small) labgap(2)) /// 
byopt(cols(1) graphregion(color(white)) ///
title("2016")) ///
legend(label(2 "Nonpartisan") label(4 "Georgian Dream") label(6 "United National Movement")order(4 6 2) pos(6) rows(2) region(lcolor(white)))

***
graph combine m_2012 m_2016, ///
title("Graph 6. Marginal effects of contacts on post-election partisanship", color(dknavy*.9) tstyle(size(mlarge)) span) ///
subtitle("Multinomial logit estimates of matched data, 95% CIs", color(dknavy*.8) tstyle(size(msmall)) span) ///
graphregion(color(white)) ///
note("NDI/CRRC 2012; NDI/CRRC 2016")

graph export "Graph_6.png", width(3000) replace
******************************************************************************************************************************


///// Graph 7. Heterogenous treatment effects -- party identification 
///// Mahalanobis
/////////////////////////////////////////////////////////////////////////////////

clear all
use "wave_12_16_appended.dta", replace

local match_var i.cn ///
i.hhcond i.dire i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype  

/// 2012

***
qui: mlogit pid_b1 i.cn##i.hhcond i.dire i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) at (hhcond=(0 1)) predict(outcome(1)) post
est store m1_1

qui: mlogit pid_b1 i.cn##i.hhcond i.dire i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) at (hhcond=(0 1)) predict(outcome(2)) post
est store m1_2

***
qui: mlogit pid_b1 i.cn##i.dire i.hhcond i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) at (dire=(0 1)) predict(outcome(1)) post
est store m2_1

qui: mlogit pid_b1 i.cn##i.dire i.hhcond i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) at (dire=(0 1)) predict(outcome(2)) post
est store m2_2

***
qui: mlogit pid_b1 i.cn##i.gchange i.hhcond i.dire i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) at (gchange=(0 1)) predict(outcome(1)) post
est store m3_1

qui: mlogit pid_b1 i.cn##i.gchange i.hhcond i.dire i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) at (gchange=(0 1)) predict(outcome(2)) post
est store m3_2

***
qui: mlogit pid_b1 i.cn##i.euappr i.hhcond i.dire i.gchange ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) at (euappr=(0 1)) predict(outcome(1)) post
est store m4_1

qui: mlogit pid_b1 i.cn##i.euappr i.hhcond i.dire i.gchange ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) at (euappr=(0 1)) predict(outcome(2)) post
est store m4_2

***
qui: mlogit pid_b1 i.cn##i.knowmp i.hhcond i.dire i.gchange i.euappr ///
i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) at (knowmp=(0 1)) predict(outcome(1)) post
est store m5_1

qui: mlogit pid_b1 i.cn##i.knowmp i.hhcond i.dire i.gchange i.euappr ///
i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) at (knowmp=(0 1)) predict(outcome(2)) post
est store m5_2

***
qui: mlogit pid_b1 i.cn##i.turn_post i.hhcond i.dire i.gchange i.euappr ///
i.knowmp ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) at (turn_post=(0 1)) predict(outcome(1)) post
est store m6_1

qui: mlogit pid_b1 i.cn##i.turn_post i.hhcond i.dire i.gchange i.euappr ///
i.knowmp ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==3, vce(cluster psu)
qui: margins, dydx(cn) at (turn_post=(0 1)) predict(outcome(2)) post
est store m6_2


coefplot (m1_1, label("Georgian Dream") lpatt(solid)lcol(blue)msym(d)mcol(blue)ciopts(lpatt(solid)lcol(blue))) ///
(m1_2, label("United National Movement") lpatt(solid)lcol(maroon)msym(t)mcol(maroon)ciopts(lpatt(solid)lcol(maroon))) ///
|| m2_1 m2_2 || m3_1 m3_2 || m4_1 m4_2 || m5_1 m5_2 || m6_1 m6_2, ///
plotlabels() bylabels("HH conditions improved?" ///
"Country's direction right?" ///
"Government approval" ///
"EU membership approval" ///
"Political knowledge" ///
"Political participation") ///
name(m_2012, replace) ///
drop(_cons 0._at) ///
xscale(r(-.2 .3)) xline(0, lcolor("orange") lwidth(vthin) lpattern(dash)) ///
xlabel(-.2 "-.2" -.1 "-.1" 0 "0" .1 ".1" .2 ".2") ///
xtitle(Change in probability of partisanship) levels(95) nobaselevels ///
coeflabels(1._at="No" 2._at="Yes", ///
wrap(40) notick labcolor(black*.8) labsize(small) labgap(1)) /// 
order (2._at 1._at) ///
byopt(rows(3) graphregion(color(white)) ///
title("2012")) ///
legend(rows(1) region(lcolor(white)))

/// 2016

***
qui: mlogit pid_c1 i.cn##i.hhcond i.dire i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) at (hhcond=(0 1)) predict(outcome(1)) post
est store m1_1

qui: mlogit pid_c1 i.cn##i.hhcond i.dire i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) at (hhcond=(0 1)) predict(outcome(2)) post
est store m1_2

***
qui: mlogit pid_c1 i.cn##i.dire i.hhcond i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) at (dire=(0 1)) predict(outcome(1)) post
est store m2_1

qui: mlogit pid_c1 i.cn##i.dire i.hhcond i.gchange i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) at (dire=(0 1)) predict(outcome(2)) post
est store m2_2

***
qui: mlogit pid_c1 i.cn##i.gchange i.hhcond i.dire i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) at (gchange=(0 1)) predict(outcome(1)) post
est store m3_1

qui: mlogit pid_c1 i.cn##i.gchange i.hhcond i.dire i.euappr ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) at (gchange=(0 1)) predict(outcome(2)) post
est store m3_2

***
qui: mlogit pid_c1 i.cn##i.euappr i.hhcond i.dire i.gchange ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) at (euappr=(0 1)) predict(outcome(1)) post
est store m4_1

qui: mlogit pid_c1 i.cn##i.euappr i.hhcond i.dire i.gchange ///
i.knowmp i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) at (euappr=(0 1)) predict(outcome(2)) post
est store m4_2

***
qui: mlogit pid_c1 i.cn##i.knowmp i.hhcond i.dire i.gchange i.euappr ///
i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) at (knowmp=(0 1)) predict(outcome(1)) post
est store m5_1

qui: mlogit pid_c1 i.cn##i.knowmp i.hhcond i.dire i.gchange i.euappr ///
i.turn_post ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) at (knowmp=(0 1)) predict(outcome(2)) post
est store m5_2

***
qui: mlogit pid_c1 i.cn##i.turn_post i.hhcond i.dire i.gchange i.euappr ///
i.knowmp ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) at (turn_post=(0 1)) predict(outcome(1)) post
est store m6_1

qui: mlogit pid_c1 i.cn##i.turn_post i.hhcond i.dire i.gchange i.euappr ///
i.knowmp ///
i.expend2 i.empl2 i.edu2 i.female i.agegr20 i.settype ///
if appendcode==6, vce(cluster psu)
qui: margins, dydx(cn) at (turn_post=(0 1)) predict(outcome(2)) post
est store m6_2


coefplot (m1_1, label("Georgian Dream") lpatt(solid)lcol(blue)msym(d)mcol(blue)ciopts(lpatt(solid)lcol(blue))) ///
(m1_2, label("United National Movement") lpatt(solid)lcol(maroon)msym(t)mcol(maroon)ciopts(lpatt(solid)lcol(maroon))) ///
|| m2_1 m2_2 || m3_1 m3_2 || m4_1 m4_2 || m5_1 m5_2 || m6_1 m6_2, ///
plotlabels() bylabels("HH conditions improved?" ///
"Country's direction right?" ///
"Government approval" ///
"EU membership approval" ///
"Political knowledge" ///
"Political participation") ///
name(m_2016, replace) ///
drop(_cons 0._at) ///
xscale(r(-.2 .3)) xline(0, lcolor("orange") lwidth(vthin) lpattern(dash)) ///
xlabel(-.2 "-.2" -.1 "-.1" 0 "0" .1 ".1" .2 ".2") /// 
xtitle(Change in probability of partisanship) levels(95) nobaselevels ///
coeflabels(1._at="No" 2._at="Yes", ///
wrap(40) notick labcolor(black*.8) labsize(small) labgap(1)) /// 
order (2._at 1._at) ///
byopt(rows(3) graphregion(color(white)) ///
title("2016")) ///
legend(rows(1) region(lcolor(white)))

***
graph combine m_2012 m_2016, ycommon xcommon ///
title("Graph 7. Marginal effects of contacts on post-election partisanship", color(dknavy*.9) tstyle(size(mlarge)) span) ///
subtitle("Multinomial logit estimates of matched data, 95% CIs", color(dknavy*.8) tstyle(size(msmall)) span) ///
graphregion(color(white)) ///
note("NDI/CRRC 2012; NDI/CRRC 2016") 

graph export "Graph_7.png", width(3000) replace
*****************************************************************************************************************************
