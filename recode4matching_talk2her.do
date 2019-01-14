// Replication code -- recode

// Talk to Her: How Party-voter Linkages Increase Partisanship in Georgia
// Koba Turmanidze

// This publication uses November 2012 and November 2016 survey waves
// Surveys are carried out by CRRC-Georgia on behalf of NDI
// Survey data and documentation can be downloaded from https://caucasusbarometer.org/en/downloads

*******************************************************************************

////////////////////////////////////////////////////////////////////////////////
// Wave 12 -- November 2012
////////////////////////////////////////////////////////////////////////////////


******************************************************************************
/// 1. Recode
******************************************************************************

clear all
use "NDI_2012_November_Final_05.12.12.dta"

gen origid=id

/// 1.1. Create a "treatment" = wave 12 (contacted by a party)

recode q18_1(1=1)(-2=.)(else=0), gen(c1)
recode q18_2(1=1)(-2=.)(else=0), gen(c2)
recode q18_7(1=1)(-2=.)(else=0), gen(c7)

gen cn_12a=0
replace cn_12a=1 if c1==1|c2==1|c7==1
replace cn_12a=. if c1==.|c2==.|c7==.
lab var cn_12a "Contacted by candidate/representative personally? {wave 12}"

gen cn_12b=.
replace cn_12b=0 if q19_1==-7
replace cn_12b=1 if q19_1==1|q19_2==1|q19_3==1|q19_4==1|q19_5==1
lab var cn_12b "Contacted on behalf of a party? {wave 12}"

gen cn_12=0
replace cn_12=1 if cn_12a==1&cn_12b==1
replace cn_12=. if cn_12a==.|cn_12b==.
lab var cn_12 "Contacted during campaign?"
lab define cont 0 "Not contacted" 1 "Contacted"
lab values cn_12 cont

/// 1.2. Recode outcome variables
*******************************************************************************

** PID

recode q82_1 (-2 -1 10=0 "Nonpartisan")(1/8=1 "Partisan")(else=.), gen(pid_a1)
recode q82_1 (-1 10=0 "Nonpartisan")(1/8=1 "Partisan")(else=.), gen(pid_a2)
recode q82_1 (-2 -1 10=0 "Nonpartisan")(6=1 "GD")(1/5 7/8=2 "UNM/Other")(else=.), gen(pid_b1)
recode q82_1 (-1 10=0 "Nonpartisan")(6=1 "GD")(1/5 7/8=2 "UNM/Other")(else=.), gen(pid_b2)

lab var pid_a1 "Nonpartisan {RA=0}"
lab var pid_a2 "Nonpartisan {RA=.}"
lab var pid_b1 "Partisanship {RA=0}"
lab var pid_b2 "Partisanship {RA=.}"

tab pid_b1, gen(pid_b1_)
gen nonp_12 = pid_b1_1 //"Nonpartisan"
gen gd_12 = pid_b1_2 //"GD"
gen unm_12 = pid_b1_3 //"UNM/Other"

/// 1.3. Recode variables for matching
*******************************************************************************

** stratum
tab stratum, gen(stratum_)

** substratum
tab substratum, gen(substr_)

** settlement type
recode settype (1=1 "Tbilisi")(2=0 "Urban")(3=2 "Rural"), gen(stt)
drop settype
gen settype=stt
tab settype, gen(settype_)

** gender
recode sex (1=0 "Male")(2=1 "Female"), gen(female)
lab var female "Female"

** marrital status
recode q92 (2 4=1 "Yes")(1 3 5=0 "No")(else=.), gen(married)
lab var married "Are you married/cohabotating?"

** age groups
recode age (18/27=0)(28/37=1)(38/47=2)(48/57=3)(58/67=4)(68/100=5), gen(agegr10)
recode age (18/37=0)(38/57=1)(58/100=2), gen(agegr20)
tab agegr10, gen(agegr10_)
tab agegr20, gen(agegr20_)

** education -- 3 groups 
recode q85 (1/3=0 "Secondary")(4=1 "Technical")(5/6=2 "Tertiary")(else=.), gen(edu3)
lab var edu3 "Education"
tab edu3, gen(edu3_)

** education -- 2 groups 
recode q85 (1/4=0 "Less than tertiary")(5/6=1 "Tertiary")(else=.), gen(edu2)
lab var edu2 "Education"

** employment status -- 3 groups
gen empl3=.
replace empl3=1 if q86==1
replace empl3=0 if q88==1 | q88==6
replace empl3=2 if q88==2 | q88==3 | q88==4 | q88==5 | q88==7 | q88==8 | q88==9 
lab var empl3 "Employment status"
tab empl3, gen(empl3_)
lab var empl3_1 "Unemployed"
lab var empl3_2 "Employed"
lab var empl3_3 "No labor force"
lab var empl3 "Employment status"

** employment status -- 2 groups
recode q86 (1=1 "Employed")(0=0 "Not employed")(else=.), gen(empl2)
lab var empl2 "Employed"

** government employee
recode q87(1=1 "Yes")(0=0 "No")(-7=0)(else=.), gen(govempl)
lab var govempl "Government employee?"

** received persion from the government?
recode q89_4(1=1 "Yes")(0=0 "No")(else=.), gen(govpens)
lab var govpens "Received persion from the government?"

** received insurance from the government?
recode q89_5(1=1 "Yes")(0=0 "No")(else=.), gen(govins)
lab var govins "Received insurance from the government?"

** received a voucher from the government?
recode q89_6(1=1 "Yes")(0=0 "No")(else=.), gen(govvou)
lab var govvou "Received a voucher from the government?"

** personal income
recode q98(-2 -1=0)(7 8=1)(6=2)(5=3)(4=4)(1/3=5), gen(income6)
recode q98(-2/-1=2 "Not disclosed")(6/8=0 "Below subsistance")(1/5=1 "Above subsistance")(else=.), gen(income3)
recode q98(-2/-1 1/5=0 "Not disclosed/Above subsistance")(6/8=1 "Below subsistance")(else=.), gen(income2)
lab var income6 "Personal income brackets {6 groups}"
lab var income3 "Personal income brackets {3 groups}"
lab var income2 "Personal income brackets {2 groups}"
tab income6, gen(income6_)
tab income3, gen(income3_)

** HH monthly average spending
recode q95(-2 -1=0)(0/140=1)(141/270=2)(271/400=3)(401/700=4)(701/4000=5)(else=.), gen(expend6)
recode q95(-2/-1=2 "Not disclosed")(0/270=0 "Below subsistance")(271/5000=1 "Above subsistance")(else=.), gen(expend3)
recode q95(-2/-1 600/4000=0 "High/Not disclosed")(0/599=1 "Low expenditure")(else=.), gen(expend2)
lab var expend6 "HH monthly average spending {grouped from an open question}"
lab var expend3 "HH monthly average spending {grouped from an open question}"
lab var expend2 "HH Low expenditure {<600 GEL}"
tab expend6, gen(expend6_)
tab expend3, gen(expend3_)

** live where registered?
recode q91(1=1 "Yes")(0=0 "No")(else=.), gen(registr)
lab var registr "Live where registered?"

** attend religious services?
recode q94(1/3=2 "Once a week")(4/5=1 "Sometimes")(6/7=0 "Rarely/never")(else=.), gen(relatt3)
lab var relatt3 "Attend religious services?"
tab relatt3, gen(relatt3_)

recode q94(1/3=1 "Once a week")(4/7=0 "Less often")(else=.), gen(relatt2)
lab var relatt2 "Attend religious services"

** access to TV
recode q65_1(1=1 "Yes")(0=0 "No")(else=.), gen(antena)
recode q65_2(1=1 "Yes")(0=0 "No")(else=.), gen(satel)
recode q65_3(1=1 "Yes")(0=0 "No")(else=.), gen(cable)

** HH size
gen adultn=nadhh
lab var adultn "Number of adult HH members"

** number of people attendinng interview
recode t4(0=1 "No")(1/9=0 "Yes")(else=.), gen(attint)
lab var attint "Was the respondent alone during the interview?"


/// 1.4 Recode co-variates
*******************************************************************************

** country's direction
recode q11 (-1 1/3=0 "Not right")(4/5=1 "Right")(else=.), gen(dire)
lab var dire "Country's direction - right?"

** relative standing with other HHs
recode q96(1/2=0 "Poor")(3=1 "Average")(4/5=2 "Good")(else=.), gen(relcond)
lab var relcond "Relative standing with other HHs"

** change in economic conditions
recode q10 (-1 1 2=0 "Not better")(3=1 "Better")(else=.), gen(hhcond)
lab var hhcond "HH conditions since 2012"

** government makes changes
recode q13(-1 1 2=0 "No")(3/4=1 "Yes")(else=.), gen(gchange)
lab var gchange "Government makes changes that matter for you?"

** know your mp?
recode q40 (-1 0=0 "No")(1=1 "Yes")(else=.), gen(knowmp)
lab var knowmp "Knows her MP correctly?"

** expect from your mp
recode q39_1(-1 0=0 "No")(1=1 "Yes")(else=.), gen(mpgood)
recode q39_2(-1 0=0 "No")(1=1 "Yes")(else=.), gen(mpbad)
lab var mpgood "MP will represent your interests"
lab var mpbad "MP will represent own interests"

** reported future turnout
recode q80 (-2 -1 1/9=0 "No")(10=1 "Yes")(else=.), gen(turn_pre)
lab var turn_pre "Reported future turnout"

** reported past voting
recode q26(-2 -1 0=0 "No")(1=1 "Yes")(else=.), gen(turn_post)
lab var turn_post "Did you vote in October_1_2012 Parliamentary elections?"

** check voters list
recode q25(1=1 "Yes")(0=0 "No")(else=.), gen(checkl)
lab var checkl "Did you check yourself in the voters list prior to election day?"

** discussed your vote
recode q32(1=1 "Yes")(0=0 "No")(else=.), gen(discv)
lab var discv "Did you discuss your vote with anybody?"

** when decided to vote
recode q30 (-7 -1 2/5=0 "Else")(1=1 "Before campaign")(else=.), gen(whendec)
lab var whendec "When decided to vote?" 

** foreign affairs
recode q46_3 (-2 -1 0=0 "No")(1=1 "Yes")(else=.), gen(natoappr)
lab var natoappr "Approve NATO membership?"

recode q46_4(-2 -1 0=0 "No")(1=1 "Yes")(else=.), gen(euappr)
lab var euappr "Approve EU membership?"

******************************************************************************

order id psu geocode cn_12 pid_a1 - pid_b2 nonp_12 unm_12 gd_12 ///
stratum stratum_* substratum substr_* settype settype_* female married agegr10 ///
agegr10_* agegr20 agegr20_* edu2 edu3 edu3_* empl2 empl3 empl3_* govempl ///
govpens govins govvou registr ///
income6 income3 income2 income6_* income3_* ///
expend6 expend3 expend2 expend6_* expend3_* relatt2 ///
relatt3 relatt3_* antena satel cable adultn attint ///
dire relcond hhcond gchange knowmp mpgood mpbad turn_pre turn_post checkl discv whendec natoappr euappr

/// 1.5. Summary statistics
*******************************************************************************

local Summary_12 cn_12 pid_a1 pid_b1 nonp_12 unm_12 gd_12 ///
stratum_1 stratum_2 stratum_3 stratum_4 stratum_5 ///
settype_1 settype_2 settype_3 ///
agegr10_1 agegr10_2 agegr10_3 agegr10_4 agegr10_5 agegr10_6 ///
agegr20_1 agegr20_2 agegr20_3 /// 
female married edu3_1 edu3_2 edu3_3 empl3_1 empl3_2 empl3_3 govempl ///
govpens govins govvou registr ///
income6_1 income6_2 income6_3 income6_4 income6_5 income6_6 ///
income3_1 income3_2 income3_3 income2 ///
expend6_1 expend6_2 expend6_3 expend6_1 expend6_2 expend6_3 ///
expend3_1 expend3_2 expend3_3 expend2 ///
relatt3_1 relatt3_2 relatt3_3 antena satel cable adultn attint ///
dire relcond hhcond gchange knowmp mpgood mpbad turn_pre turn_post ///
checkl discv whendec natoappr euappr


logout, save(summary_12) excel replace: summarize `Summary_12'

/// 1.6. Check balance
*******************************************************************************
local Balance_12 ///
stratum_1 stratum_2 stratum_3 stratum_4 stratum_5 ///
settype_1 settype_2 settype_3 ///
agegr10_1 agegr10_2 agegr10_3 agegr10_4 agegr10_5 agegr10_6 ///
agegr20_1 agegr20_2 agegr20_3 /// 
female married edu3_1 edu3_2 edu3_3 empl3_1 empl3_2 empl3_3 govempl ///
govpens govins govvou registr ///
income6_1 income6_2 income6_3 income6_4 income6_5 income6_6 ///
income3_1 income3_2 income3_3 income2 ///
expend6_1 expend6_2 expend6_3 expend6_1 expend6_2 expend6_3 ///
expend3_1 expend3_2 expend3_3 expend2 ///
relatt3_1 relatt3_2 relatt3_3 antena satel cable adultn attint


//foreach x in `Balance_12' {
//logistic cn_12 `x'
//}

/// 1.7. Logistic model on treatment
*******************************************************************************

local psmodel_12 ///
stratum_2 stratum_3 stratum_4 stratum_5 ///
agegr10_2 agegr10_3 agegr10_4 agegr10_5 agegr10_6 ///
female married edu3_2 edu3_3 empl3_2 empl3_3 govempl ///
govpens govins govvou registr ///
expend6_2 expend6_3 expend6_4 expend6_5 expend6_6 ///
relatt3_2 relatt3_3 antena satel cable adultn attint

logistic cn_12 `psmodel_12', coef
predict p12

save "wave_12_tomatch.dta", replace

******************************************************************************
/// 2. Matching
******************************************************************************

clear all
use "wave_12_tomatch.dta", replace


/// 2.1. Nearest neighbor
*******************************************************************************

clear all
use "wave_12_tomatch.dta", replace
drop if p1==.
gen logit12=log((1-p12)/p12)  
sum logit12
display .25*.6464152
set seed 18092112
tempvar x
generate `x'=uniform()
sort `x'

**
psmatch2 cn_12, pscore(logit12) noreplacement descending
sort _id
g match=id[_n1]
g treat=id if _nn==1
drop if treat==.
sum treat
keep treat match
save "wave12_scheme_1.dta", replace

/// 2.2. Mahalanobis matching -- with propensity score
*******************************************************************************

clear all
use "wave_12_tomatch.dta", replace
drop if p1==.
gen logit12=log((1-p12)/p12)  
sum logit12
set seed 18092112
tempvar x
generate `x'=uniform()
sort `x'

** 
psmatch2 cn_12, mahal(stratum_2 stratum_3 stratum_4 stratum_5 ///
agegr10_2 agegr10_3 agegr10_4 agegr10_5 agegr10_6 ///
female married edu3_2 edu3_3 empl3_2 empl3_3 govempl ///
govpens govins govvou registr ///
expend6_2 expend6_3 expend6_4 expend6_5 expend6_6 ///
relatt3_2 relatt3_3 antena satel cable adultn attint ///
logit12)

**
sort _id
generate match=id[_n1]
generate treat=id if _n1 !=.
sort match
by match: g mj=_n
drop if treat==.
drop if mj != 1
sum match 
keep treat match
save "wave12_scheme_2.dta", replace

*******************************************************************************
/// 3. Merge treat and match
*******************************************************************************

/// 3.1. Nearest neighbor
*******************************************************************************
clear
use "wave12_scheme_1.dta", replace
keep treat
gen tx=1
rename treat id
save "C:\tmp\t1.dta", replace
use "wave12_scheme_1.dta", replace
keep match
gen tx=0
rename match id
append using "C:\tmp\t1.dta"
sort id
save "C:\tmp\t2.dta", replace

clear
use "wave_12_tomatch.dta", replace
sort id
merge id using "C:\tmp\t2.dta"
tab tx
drop if tx==.
save "wave12_match_1.dta", replace

** Check balance

local psmodel_12 ///
stratum_1 stratum_2 stratum_3 stratum_4 stratum_5 ///
settype_1 settype_2 settype_3 ///
agegr10_1 agegr10_2 agegr10_3 agegr10_4 agegr10_5 agegr10_6 ///
agegr20_1 agegr20_2 agegr20_3 /// 
female married edu3_1 edu3_2 edu3_3 empl3_1 empl3_2 empl3_3 govempl ///
govpens govins govvou registr ///
income6_1 income6_2 income6_3 income6_4 income6_5 income6_6 ///
income3_1 income3_2 income3_3 income2 ///
expend6_1 expend6_2 expend6_3 expend6_1 expend6_2 expend6_3 ///
expend3_1 expend3_2 expend3_3 expend2 ///
relatt3_1 relatt3_2 relatt3_3 antena satel cable adultn attint

//foreach x in `psmodel_12' {
//logistic cn_12 `x'
//}

/// 3.2. Mahalanobis matching -- with propensity score
*******************************************************************************

clear
use "wave12_scheme_2.dta", replace
keep treat
gen tx=1
rename treat id
save "C:\tmp\t1.dta", replace
use "wave12_scheme_2.dta", replace
keep match
gen tx=0
rename match id
append using "C:\tmp\t1.dta"
sort id
save "C:\tmp\t2.dta", replace

clear
use "wave_12_tomatch.dta", replace
sort id
merge id using "C:\tmp\t2.dta"
tab tx
drop if tx==.
save "wave12_match_2.dta", replace

** Check balance

local psmodel_12 ///
stratum_1 stratum_2 stratum_3 stratum_4 stratum_5 ///
settype_1 settype_2 settype_3 ///
agegr10_1 agegr10_2 agegr10_3 agegr10_4 agegr10_5 agegr10_6 ///
agegr20_1 agegr20_2 agegr20_3 /// 
female married edu3_1 edu3_2 edu3_3 empl3_1 empl3_2 empl3_3 govempl ///
govpens govins govvou registr ///
income6_1 income6_2 income6_3 income6_4 income6_5 income6_6 ///
income3_1 income3_2 income3_3 income2 ///
expend6_1 expend6_2 expend6_3 expend6_1 expend6_2 expend6_3 ///
expend3_1 expend3_2 expend3_3 expend2 ///
relatt3_1 relatt3_2 relatt3_3 antena satel cable adultn attint

//foreach x in `psmodel_12' {
//logistic cn_12 `x'
//}

///////////////////////////////////////////////////////////////////////////////
// Wave 25 -- November 2016
///////////////////////////////////////////////////////////////////////////////

******************************************************************************
/// 1. Recode
******************************************************************************

clear all
use "NDI_2016_Nov_2016.dta"

/// 1.1. Recode treatment (contacted by a party)
*******************************************************************************

** type of contact
recode c_15(1=1)(-2=.)(else=0), gen(c15)
recode c_16(1=1)(-2=.)(else=0), gen(c16)
recode c_17(1=1)(-2=.)(else=0), gen(c17)
recode c_22(1=1)(-2=.)(else=0), gen(c22)

gen cn_16a=0
replace cn_16a=1 if c15==1|c16==1|c17==1|c22==1
replace cn_16a=. if c15==.|c16==.|c17==.|c22==.
lab var cn_16a "Contacted by candidate/representative personally? {wave 25}"

** contacted by any party
gen cn_16b=0 if wave==25
replace cn_16b=1 if wave==25 & ///
(c_01==1 | c_02==1 | c_03==1 | c_04==1 | c_05==1 | c_06==1 | c_07==1 | ///
c_08==1 | c_09==1 | c_10==1 | c_11==1 | c_12==1 | c_13==1 | c_14==1)
replace cn_16b=. if wave==25 & (c_01==-3 | c_01==-2)
lab var cn_16b "Contacted on behalf of a party? {wave 25}"

**
gen cn_16=0
replace cn_16=1 if cn_16a==1&cn_16b==1
replace cn_16=. if cn_16a==.|cn_16b==.
lab var cn_16 "Contacted personally on behalf of a party? {wave 25}"
lab var cn_16 "Contacted during campaign?"
lab values cn_16 cont

/// 1.2. Recode outcome variables
*******************************************************************************

** PID
recode p_03 (-2 -1 60=0 "Nonpartisan")(1/23 50=1 "Partisan")(else=.), gen(pid_a1)
recode p_03 (-1 60=0 "Nonpartisan")(1/23 50=1 "Partisan")(else=.), gen(pid_a2)
recode p_03 (-2 -1 60=0 "Nonpartisan")(9=1 "GD")(1/8 10/23 50=2 "Other")(else=.), gen(pid_b1)
recode p_03 (-1 60=0 "Nonpartisan")(9=1 "GD")(1/8 10/23 50=2 "Other")(else=.), gen(pid_b2)
recode p_03 (-2 -1 60=0 "Nonpartisan")(9=1 "GD")(7=2 "UNM")(1/6 8 10/23 50=3 "Other")(else=.), gen(pid_c1)
recode p_03 (-1 60=0 "Nonpartisan")(9=1 "GD")(7=2 "UNM")(1/6 8 10/23 50=3 "Other")(else=.), gen(pid_c2)

lab var pid_a1 "PID with RA {1=partisan}"
lab var pid_a2 "PID without RA {1=partisan}"
lab var pid_b1 "PID with RA {1=oppostion 2=ruling party}"
lab var pid_b2 "PID without RA {1=oppostion 2=ruling party}"

lab var pid_a1 "Nonpartisan {RA=0}"
lab var pid_a2 "Nonpartisan {RA=.}"
lab var pid_b1 "Partisanship {RA=0}"
lab var pid_b2 "Partisanship {RA=.}"

tab pid_c1, gen(pid_c1_)
gen nonp_16 = pid_c1_1 //"Nonpartisan"
gen gd_16 = pid_c1_2 //"GD"
gen unm_16 = pid_c1_3 //"UNM"
gen other_16 = pid_c1_4 //Other"

/// 1.3. Recode variables for matching
*******************************************************************************

gen psu=psu_m
lab var psu "PSU"

** stratum
tab stratum, gen(stratum_)

** substratum
tab substratum, gen(substr_)

** settlement type
//tab settype, gen(settype_)

** gender
recode sex (1=0 "Male")(2=1 "Female"), gen(female)
lab var female "Female"

** marrital status
recode r_04 (2 4=1 "Yes")(1 3 5=0 "No")(else=.), gen(married)
lab var married "Are you married/cohabotating?"

** age groups
recode age_m (18/27=0)(28/37=1)(38/47=2)(48/57=3)(58/67=4)(68/100=5), gen(agegr10)
recode age_m (18/37=0)(38/57=1)(58/100=2), gen(agegr20)
tab agegr10, gen(agegr10_)
tab agegr20, gen(agegr20_)

** education -- 3 groups 
recode r_01 (1/3=0 "Secondary")(4=1 "Technical")(5/6=2 "Tertiary")(else=.), gen(edu3)
lab var edu3 "Education"
tab edu3, gen(edu3_)

** education -- 2 groups 
recode r_01 (1/4=0 "Less than tertiary")(5/6=1 "Tertiary")(else=.), gen(edu2)
lab var edu2 "Education"

** employment status -- 3 groups
gen empl3=.
replace empl3=1 if r_02==1
replace empl3=0 if r_03==1 | r_03==6
replace empl3=2 if r_03==2 | r_03==3 | r_03==4 | r_03==5 | r_03==7 | r_03==8 | r_03==9 
lab var empl3 "Employment status"
tab empl3, gen(empl3_)
lab var empl3_1 "Unemployed"
lab var empl3_2 "Employed"
lab var empl3_3 "No labor force"
lab var empl3 "Employment status"

** employment status -- 2 groups
recode r_02 (1=1 "Yes")(0=0 "No")(else=.), gen(empl2)
lab var empl2 "Employed"

** mother worked
recode r_09 (1/2=1 "Yes")(-1 3/4=0 "No")(else=.), gen(momwork)
lab var momwork "Mother's occupation for the most of your childhood?"

** HH income and expenditure
recode r_05(-2 -1=0)(7 8=1)(6=2)(5=3)(4=4)(3=5)(2 1=6)(else=.), gen(income6)
recode r_06(-2 -1=0)(7 8=1)(6=2)(5=3)(4=4)(3=5)(2 1=6)(else=.), gen(expend6)
lab var income6 "Income brackets {DK/RA=0}"
lab var expend6 "Expenditure brackets {DK/RA=0}"
tab income6, gen(income6_)
tab expend6, gen(expend6_)

** 
recode r_05(-2/-1=2 "Not disclosed")(6/8=0 "Below subsistance")(1/5=1 "Above subsistance")(else=.), gen(income3)
recode r_06(-2/-1=2 "Not disclosed")(6/8=0 "Below subsistance")(1/5=1 "Above subsistance")(else=.), gen(expend3)
lab var income3 "Income brackets"
lab var expend3 "Expenditure brackets"
tab income3, gen(income3_)
tab expend3, gen(expend3_)

**
recode r_05(-2/-1 1/5=0 "High/Not disclosed")(4/8=1 "Low income")(else=.), gen(income2)
recode r_06(-2/-1 1/5=0 "High/Not disclosed")(4/8=1 "Low expenditure")(else=.), gen(expend2)
lab var income2 "Low income {<800 GEL}"
lab var expend2 "Low expenditure {<800 GEL}"

** HH posessions -- totals 
mvdecode r_10-r_19, mv(-9/-1)
egen poss = rowtotal(r_10-r_19)
lab var poss "HH posessions of durable goods"

** Internet use
recode m_01 (1/2=1 "Yes")(-1 3/6=0 "No")(else=.), gen(inter2)
lab var inter2 "Use internet at least once a week?"

** HH size
gen adultn=nadhh_m
lab var adultn "Number of adult HH members"

** number of people attendinng interview
recode t4(3/12=0 "No")(2=1 "Yes")(else=.), gen(attint)
lab var attint "Was the respondent alone during the interview?"

/// 1.4. Recode covariates
*******************************************************************************

** country's direction
recode a_01 (-1 1/3=0 "Not right")(4/5=1 "Right")(else=.), gen(dire)
lab var dire "Country's direction - right?"

** expected economic conditions
recode r_07 (-1 1/3=0 "Not improve")(4/5=1 "Improve")(else=.), gen(expect)
lab var expect "Expected economic conditions for the next year"

** HH conditions since 2012
recode i_01 (-1 1 2=0 "Not better")(3=1 "Better")(else=.), gen(hhcond)
lab var hhcond "HH conditions since 2012"

** government makes changes
// local government in wave 25
recode a_03(-1 1 2=0)(3/4=1)(else=.), gen(gchange)
lab var gchange "Government makes changes that matter for you"

** turnout
recode p_22 (-2 -1 0=0 "No")(1=1 "Yes")(else=.), gen(turn_post)
lab var turn_post "Reported turnout {RA=0"

** vote decision
recode p_11 (-7 -1 2 3=0 "Else")(1=1 "Before campaign")(else=.), gen(whendec)
lab var whendec "When decided to vote?" 

** checked voters' list
recode e_01 (-1 0=0 "No")(1=1 "Checked")(else=.), gen(check)
lab var check "Did you check yourself in the voters' lists prior to election day?"

** know your mp?
recode o_01 (-1 0=0 "No")(1=1 "Yes")(else=.), gen(knowmp)
lab var knowmp "Knows her MP correctly?"

** expect from your mp
recode o_02(-1 0=0 "No")(1=1 "Yes")(else=.), gen(mpgood)
recode o_03(-1 0=0 "No")(1=1 "Yes")(else=.), gen(mpbad)
lab var mpgood "MP will represent your interests"
lab var mpbad "MP will represent own interests"

** foreign relations
recode f_03(1/2=1 "EU")(3/4=2 "Russia")(-1 5=0 "Indifferent")(else=.), gen(euru)
recode f_03(1/2=1 "EU")(-1 3 4 5=0 "Not EU")(else=.), gen(euappr)
lab var euru "EU integration vs Russia"
lab var euappr "EU support"

*******************************************************************************
order id psu cn_16 pid_a1 - pid_c2 nonp_16 unm_16 gd_16 other_16 ///
stratum stratum_* substratum substr_* settype settype_* female married agegr10 ///
agegr10_* agegr20 agegr20_* edu2 edu3 edu3_* empl2 empl3 empl3_* momwork ///
income6 income3 income2 income6_* income3_* expend6 expend3 expend6_* expend3_* ///
poss inter2 adultn attint dire expect hhcond turn_post whendec check knowmp mpgood mpbad euru euappr

/// 1.5. Summary statistics
*******************************************************************************
local Summary_16 cn_16 pid_a1 - pid_c2 nonp_16 unm_16 gd_16 other_16 ///
stratum stratum_* substratum substr_* settype settype_* female married agegr10 ///
agegr10_* agegr20 agegr20_* edu2 edu3 edu3_* empl2 empl3 empl3_* momwork ///
income6 income3 income2 income6_* income3_* expend6 expend3 expend6_* expend3_* ///
poss inter2 adultn attint dire expect hhcond turn_post whendec check knowmp mpgood mpbad euru euappr 

logout, save(Summary_16) excel replace: summarize `Summary_16' 

/// 1.6. Check balance
*******************************************************************************
local Balance_16 pid_a1 nonp_16 unm_16 gd_16 other_16 ///
stratum_1 stratum_2 stratum_3 stratum_4 stratum_5 stratum_6 stratum_7 stratum_8 ///
settype_1 settype_2 settype_3 settype_4 female married ///
agegr10_1 agegr10_2 agegr10_3 agegr10_4 agegr10_5 agegr10_6 ///
agegr20_1 agegr20_2 agegr20_3 ///
edu2 edu3_1 edu3_2 edu3_3 empl2 empl3_1 empl3_2 empl3_3 momwork ///
income6_1 income6_2 income6_3 income6_4 income6_5 income6_6 income6_7 ///
expend6_1 expend6_2 expend6_3 expend6_4 expend6_5 expend6_6 expend6_7 ///
poss inter2 adultn attint ///
dire expect hhcond turn_post whendec check knowmp mpgood mpbad euru euappr

//foreach x in `Balance_16' {
//logistic cn_16 `x'
//}

/// 1.7. Logistic model on treatment
*******************************************************************************
local psmodel_16 ///
stratum_2 stratum_3 stratum_4 stratum_5 stratum_6 stratum_7 stratum_8 ///
female married ///
agegr10_2 agegr10_3 agegr10_4 agegr10_5 agegr10_6 ///
edu3_2 edu3_3 empl3_2 empl3_3 momwork ///
expend6_2 expend6_3 expend6_4 expend6_5 expend6_6 expend6_7 ///
poss inter2 adultn attint

logistic cn_16 `psmodel_16', coef
predict p16

save "wave_16_tomatch.dta", replace

******************************************************************************
/// 2. Matching
******************************************************************************

clear all
use "wave_16_tomatch.dta", replace

/// 2.1. Nearest neighbor
*******************************************************************************

clear all
use "wave_16_tomatch.dta", replace
drop if p1==.
gen logit16=log((1-p16)/p16)  
sum logit16
display .25*.5167605 
set seed 18092112
tempvar x
generate `x'=uniform()
sort `x'

**
psmatch2 cn_16, pscore(logit1) noreplacement descending
sort _id
g match=id[_n1]
g treat=id if _nn==1
drop if treat==.
sum treat
keep treat match
save "wave16_scheme_1.dta", replace

/// 2.2. Mahalanobis matching -- with propensity score
*******************************************************************************

clear all
use "wave_16_tomatch.dta", replace
drop if p1==.
gen logit16=log((1-p16)/p16)  
sum logit16
set seed 18092112
tempvar x
generate `x'=uniform()
sort `x'

** Mahalanobis with propensity score
psmatch2 cn_16, mahal(stratum_2 stratum_3 stratum_4 stratum_5 stratum_6 stratum_7 stratum_8 ///
female married ///
agegr10_2 agegr10_3 agegr10_4 agegr10_5 agegr10_6 ///
edu3_2 edu3_3 empl3_2 empl3_3 momwork ///
expend6_2 expend6_3 expend6_4 expend6_5 expend6_6 expend6_7 ///
poss inter2 adultn attint ///
logit16)

**
sort _id
generate match=id[_n1]
generate treat=id if _n1 !=.
sort match
by match: g mj=_n
drop if treat==.
drop if mj != 1
sum match 
keep treat match
save "wave16_scheme_2.dta", replace

*******************************************************************************
/// 3. Merge treat and match
*******************************************************************************

/// 3.1. Nearest neighbor within caliper .25*SD
*******************************************************************************
clear
use "wave16_scheme_1.dta", replace
keep treat
gen tx=1
rename treat id
save "C:\tmp\t1.dta", replace
use "wave16_scheme_1.dta", replace
keep match
gen tx=0
rename match id
append using "C:\tmp\t1.dta"
sort id
save "C:\tmp\t2.dta", replace

clear
use "wave_16_tomatch.dta", replace
sort id
merge id using "C:\tmp\t2.dta"
tab tx
drop if tx==.
save "wave16_match_1.dta", replace

** Check balance
local psmodel_16 pid_a1 nonp_16 unm_16 gd_16 other_16 ///
stratum_1 stratum_2 stratum_3 stratum_4 stratum_5 stratum_6 stratum_7 stratum_8 ///
settype_1 settype_2 settype_3 settype_4 female married ///
agegr10_1 agegr10_2 agegr10_3 agegr10_4 agegr10_5 agegr10_6 ///
agegr20_1 agegr20_2 agegr20_3 ///
edu2 edu3_1 edu3_2 edu3_3 empl2 empl3_1 empl3_2 empl3_3 momwork ///
income6_1 income6_2 income6_3 income6_4 income6_5 income6_6 income6_7 ///
expend6_1 expend6_2 expend6_3 expend6_4 expend6_5 expend6_6 expend6_7 ///
poss inter2 adultn attint ///
dire expect hhcond turn_post whendec check knowmp mpgood mpbad euru euappr

//foreach x in `psmodel' {
//logistic cn_16 `x'
//}

/// 3.2. Mahalanobis matching -- with propensity score
*******************************************************************************

clear
use "wave16_scheme_2.dta", replace
keep treat
gen tx=1
rename treat id
save "C:\tmp\t1.dta", replace
use "wave16_scheme_2.dta", replace
keep match
gen tx=0
rename match id
append using "C:\tmp\t1.dta"
sort id
save "C:\tmp\t2.dta", replace

clear
use "wave_16_tomatch.dta", replace
sort id
merge id using "C:\tmp\t2.dta"
tab tx
drop if tx==.
save "wave16_match_2.dta", replace

** Check balance
local psmodel_16 pid_a1 nonp_16 unm_16 gd_16 other_16 ///
stratum_1 stratum_2 stratum_3 stratum_4 stratum_5 stratum_6 stratum_7 stratum_8 ///
settype_1 settype_2 settype_3 settype_4 female married ///
agegr10_1 agegr10_2 agegr10_3 agegr10_4 agegr10_5 agegr10_6 ///
agegr20_1 agegr20_2 agegr20_3 ///
edu2 edu3_1 edu3_2 edu3_3 empl2 empl3_1 empl3_2 empl3_3 momwork ///
income6_1 income6_2 income6_3 income6_4 income6_5 income6_6 income6_7 ///
expend6_1 expend6_2 expend6_3 expend6_4 expend6_5 expend6_6 expend6_7 ///
poss inter2 adultn attint ///
dire expect hhcond turn_post whendec check knowmp mpgood mpbad euru euappr

//foreach x in `psmodel' {
//logistic cn_16 `x'
//}

/// 4. Append original and matched data


clear all

append using "wave_12_tomatch.dta" "wave12_match_1.dta" "wave12_match_2.dta" "wave_16_tomatch.dta" "wave16_match_1.dta" "wave16_match_2.dta", gen(appendcode) 

lab var appendcode "Code of appended dataset"
lab define appcode 1 "Wave 12 -- Original" 2 "Wave 12 -- Nearest Neighbor" 3 "Wave 12 -- Mahalanobis" ///
4 "Wave 16 -- Original" 5 "Wave 16 -- Nearest Neighbor" 6 "Wave 16 -- Mahalanobis"
lab values appendcode appcode

gen cn=.
replace cn=cn_12 if appendcode==1
replace cn=cn_12 if appendcode==2
replace cn=cn_12 if appendcode==3
replace cn=cn_16 if appendcode==4
replace cn=cn_16 if appendcode==5
replace cn=cn_16 if appendcode==6

lab define contact_m 0 "Not contacted" 1 "Contacted" 
lab values cn contact_m
lab var cn "Contacted personally on behalf of a party?"

save "wave_12_16_appended.dta", replace
