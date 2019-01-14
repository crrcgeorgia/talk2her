// Replication code -- recode

// Talk to Her: How Party-voter Linkages Increase Partisanship in Georgia
// Koba Turmanidze

// This publication uses the panel component of June 2016 and November 2016 survey waves 
// Surveys are carried out by CRRC-Georgia on behalf of NDI
// Survey data and documentation can be downloaded from https://caucasusbarometer.org/en/downloads

*******************************************************************************

clear all
use "Merged_Wave_24_25_16.07.18.dta"

/// "treatment" (contacted by a party)

** party contact
*c_01 - United National Movement
*c_02 - Georgian Dream - Democratic Georgia
*c_03 - Shalva Natelashvili - Labour Party
*c_04 - New Rights
*c_05 - Nino Burjanadze - Democratic Movement
*c_06 - Usupashvili-Republicans
*c_07 - Topadze Industrialists - Our Georgia
*c_08 - Irakli Alasania - Free Democrats
*c_09 - Tamaz Metchiauri For United Georgia
*c_10 - New Political Center Girchi
*c_11 - Paata Burchuladze - State for People
*c_12 - Alliance of Patriots of Georgia, United Opposition
*c_13 - National Forum
*c_14 - Jondi Baghaturia - Georgian Group

** type of contact
recode c_15(1=1)(-2=.)(else=0), gen(c15)
recode c_16(1=1)(-2=.)(else=0), gen(c16)
recode c_17(1=1)(-2=.)(else=0), gen(c17)
recode c_22(1=1)(-2=.)(else=0), gen(c22)

gen cn_25a=0
replace cn_25a=1 if c15==1|c16==1|c17==1|c22==1
replace cn_25a=. if c15==.|c16==.|c17==.|c22==.
lab var cn_25a "Contacted by candidate/representative personally? {wave 25}"

** contacted by any party
gen cn_25b=0 if wave==25
replace cn_25b=1 if wave==25 & ///
(c_01==1 | ///
c_02==1 | ///
c_03==1 | ///
c_04==1 | ///
c_05==1 | ///
c_06==1 | ///
c_07==1 | ///
c_08==1 | ///
c_09==1 | ///
c_10==1 | ///
c_11==1 | ///
c_12==1 | ///
c_13==1 | ///
c_14==1)
replace cn_25b=. if wave==25 & (c_01==-3 | c_01==-2)
lab var cn_25b "Contacted on behalf of a party? {wave 25}"

**
gen cn_25=0
replace cn_25=1 if cn_25a==1&cn_25b==1
replace cn_25=. if cn_25a==.|cn_25b==.
lab var cn_25 "Contacted personally on behalf of a party? {wave 25}"

** contacted by any party individually (If you were contacted, was it a candidate or his/her representative?)
recode c_23(1/3=1)(-1=0)(-7=0)(else=.) if wave==25, gen(cn_25_c)
lab var cn_25_c "Contacted by a party individually? {wave 25}"


/// outcome variables -- party identification
*******************************************************************************

** PID
recode p_03 (-2 -1 60=0 "Nonpartisan")(1/50=1 "Partisan")(else=.), gen(pid_a1)
recode p_03 (-1 60=0 "Nonpartisan")(1/50=1 "Partisan")(else=.), gen(pid_a2)
recode p_03 (-2 -1 60=0 "Nonpartisan")(9=1 "GD")(1/8 10/50=2 "Oppostion")(else=.), gen(pid_b1)
recode p_03 (-1 60=0 "Nonpartisan")(9=1 "GD")(1/8 10/50=2 "Oppostion")(else=.), gen(pid_b2)
recode p_03 (-2 -1 60=0 "Nonpartisan")(9=1 "GD")(7=2 "UNM")(1/6 8 10/50=3 "Oppostion")(else=.), gen(pid_c1)
recode p_03 (-1 60=0 "Nonpartisan")(9=1 "GD")(7=2 "UNM")(1/6 8 10/50=3 "Oppostion")(else=.), gen(pid_c2)

lab var pid_a1 "Nonpartisan {RA=0}"
lab var pid_a2 "Nonpartisan {RA=.}"
lab var pid_b1 "Partisanship {RA=0}"
lab var pid_b2 "Partisanship {RA=.}"
lab var pid_c1 "Partisanship {RA=0}"
lab var pid_c2 "Partisanship {RA=.}"

/// covariates -- party
*******************************************************************************

** vote to party
recode p_05 (-2 -1 60=0 "No party")(1/50=1 "Partisan")(else=.), gen(votep_a1)
recode p_05 (-1 60=0 "No party")(1/50=1 "Partisan")(else=.), gen(votep_a2)
recode p_05 (-2 -1 60=0 "No party")(9=1 "GD")(1/8 10/50=2 "Oppostion")(else=.), gen(votep_b1)
recode p_05 (-1 60=0 "No party")(9=1 "GD")(1/8 10/50=2 "Oppostion")(else=.), gen(votep_b2)
recode p_05 (-2 -1 60=0 "No party")(9=1 "GD")(7=2 "UNM")(1/6 8 10/50=3 "Other")(else=.), gen(votep_c1)
recode p_05 (-1 60=0 "No party")(9=1 "GD")(7=2 "UNM")(1/6 8 10/50=3 "Other")(else=.), gen(votep_c2)

lab var votep_a1 "Vote to party -- dummy {RA=0}"
lab var votep_a2 "Vote to party -- dummy {RA=.}"
lab var votep_b1 "Vote to party -- with GD {RA=0}"
lab var votep_b2 "Vote to party -- with GD {RA=.}"
lab var votep_c1 "Vote to party -- with GD & UNM {RA=0}"
lab var votep_c2 "Vote to party -- with GD & UNM {RA=.}"

** never vote to party
recode p_08 (-2 -1 60=0 "No party")(1/50=1 "A party")(else=.), gen(voten_a1)
recode p_08 (-1 60=0 "No party")(1/50=1 "A party")(else=.), gen(voten_a2)
recode p_08 (-2 -1 60=0 "No party")(9=1 "GD")(1/8 10/50=2 "Oppostion")(else=.), gen(voten_b1)
recode p_08 (-1 60=0 "No party")(9=1 "GD")(1/8 10/50=2 "Oppostion")(else=.), gen(voten_b2)
recode p_08 (-2 -1 60=0 "No party")(9=1 "GD")(7=2 "UNM")(1/6 8 10/50=3 "Other")(else=.), gen(voten_c1)
recode p_08 (-1 60=0 "No party")(9=1 "GD")(7=2 "UNM")(1/6 8 10/50=3 "Other")(else=.), gen(voten_c2)

lab var voten_a1 "Never vote to party -- dummy {RA=0}"
lab var voten_a2 "Never vote to party -- dummy {RA=.}"
lab var voten_b1 "Never vote to party -- with GD {RA=0}"
lab var voten_b2 "Never vote to party -- with GD {RA=.}"
lab var voten_c1 "Never vote to party -- with GD & UNM {RA=0}"
lab var voten_c2 "Never vote to party -- with GD & UNM {RA=.}"

** which party will win?
recode p_09 (-2 -1 60=0 "No party")(1/50=1 "A party")(else=.), gen(votew_a1)
recode p_09 (-1 60=0 "No party")(1/50=1 "A party")(else=.), gen(votew_a2)
recode p_09 (-2 -1 60=0 "No party")(9=1 "GD")(1/8 10/50=2 "Oppostion")(else=.), gen(votew_b1)
recode p_09 (-1 60=0 "No party")(9=1 "GD")(1/8 10/50=2 "Oppostion")(else=.), gen(votew_b2)
recode p_09 (-2 -1 60=0 "No party")(9=1 "GD")(7=2 "UNM")(1/6 8 10/50=3 "Other")(else=.), gen(votew_c1)
recode p_09 (-1 60=0 "No party")(9=1 "GD")(7=2 "UNM")(1/6 8 10/50=3 "Other")(else=.), gen(votew_c2)

lab var votew_a1 "Which party will win? -- dummy {RA=0}"
lab var votew_a2 "Which party will win? -- dummy {RA=.}"
lab var votew_b1 "Which party will win? -- with GD {RA=0}"
lab var votew_b2 "Which party will win? -- with GD {RA=.}"
lab var votew_c1 "Which party will win? -- with GD & UNM {RA=0}"
lab var votew_c2 "Which party will win? -- with GD & UNM {RA=.}"

** turnout
recode p_02 (-2 -1 1/9=0 "No")(10=1 "Yes")(else=.), gen(turn_pre_a)
recode p_02 (-1 1/9=0 "No")(10=1 "Yes")(else=.), gen(turn_pre_b)
lab var turn_pre_a "Reported turnout {RA=0"
lab var turn_pre_b "Reported turnout {RA=.}"

recode p_22 (-2 -1 0=0 "No")(1=1 "Yes")(else=.), gen(turn_post_a)
recode p_22 (-1 0=0)(1=1 "Yes")(else=.), gen(turn_post_b)
lab var turn_post_a "Reported turnout {RA=0"
lab var turn_post_b "Reported turnout {RA=.}"

** partisanship
recode e_02 (-1 0=0 "No")(1=1 "Yes")(else=.), gen(eleval) 
lab var eleval "Most important when deciding whether elections ran well - Party I support"

** decided before elections
recode p_01 (1=1)(0=0)(else=.), gen(decided)
lab var decided "If elections were held tomorrow would you say you are decided/undecided?"

** know your mp?
recode o_01 (-1 0=0 "No")(1=1 "Yes")(else=.), gen(knowmp)
lab var knowmp "Knows her MP correctly?"

** expect from your mp
recode o_02(-1 0=0 "No")(1=1 "Yes")(else=.), gen(mpgood)
recode o_03(-1 0=0 "No")(1=1 "Yes")(else=.), gen(mpbad)
lab var mpgood "MP will represent your interests"
lab var mpbad "MP will represent own interests"

/// covariates -- other
*******************************************************************************

** settlement type
recode settype_m (1=1 "Tbilisi")(2=0 "Urban")(3=2 "Rural")(4=3 "Minority"), gen(settype)
lab var settype "Settlement type"

** gender
recode sex (1=0 "Male")(2=1 "Female"), gen(female)
lab var female "Female"

** age
gen age=age_m
lab var age "Age"

** age groups
recode age_m (18/37=0 "18-37")(38/57=1 "38-59")(58/100=2 ">59"), gen(agegr)
lab var agegr "Age groups"

** education -- 3 groups 
recode r_01 (1/3=0 "Secondary")(4=1 "Technical")(5/6=2 "Tertiary")(else=.), gen(edu)

** education -- 2 groups 
recode r_01 (1/4=0 "No tertiary")(5/6=1 "Tertiary")(else=.), gen(edu2)

** employment status -- 3 groups
gen empl=.
replace empl=1 if r_02==1
replace empl=0 if r_03==1 | r_03==6
replace empl=2 if r_03==2 | r_03==3 | r_03==4 | r_03==5 | r_03==7 | r_03==8 | r_03==9 
lab var empl "Employment status"
lab define empl 2 "No labor force" 0 "Unemployed" 1 "Employed"
lab values empl empl

** employment status -- 2 groups
recode empl (0 2=0 "Not employed")(1=1 "Employed"),gen(empl2)

** HH posessions -- totals 
mvdecode r_10-r_19, mv(-9/-1)
egen poss = rowtotal(r_10-r_19)
lab var poss "HH posessions of durable goods"

** number of people attendinng interview
recode t4(2=1)(3/12=0)(else=.), gen(attint)
lab var attint "Was the respondent alone during the interview?"

** interviewer asessments
recode r_20(1=1)(2/5=0)(else=.), gen(r_20r)
recode r_21(1=1)(2/5=0)(else=.), gen(r_21r)
recode r_22(1=1)(2/5=0)(else=.), gen(r_22r)
recode r_23(1=1)(2/5=0)(else=.), gen(r_23r)
recode r_24(4/5=1)(1/3=0)(else=.), gen(r_24r)
recode r_25(10=1)(0/9=0)(else=.), gen(r_25r)
recode r_26(10=1)(0/9=0)(else=.), gen(r_26r)

** HH income and expenditure
recode r_05(-2 -1=0)(7 8=1)(6=2)(5=3)(4=4)(3=5)(2 1=6)(else=.), gen(income6)
recode r_06(-2 -1=0)(7 8=1)(6=2)(5=3)(4=4)(3=5)(2 1=6)(else=.), gen(expend6)
lab var income6 "Income brackets {DK/RA=0}"
lab var expend6 "Expenditure brackets {DK/RA=0}"

** HH income and expenditure
recode r_05(-2/-1=2 "Not disclosed")(6/8=0 "Below subsistance")(1/5=1 "Above subsistance")(else=.), gen(income1)
recode r_06(-2/-1=2 "Not disclosed")(6/8=0 "Below subsistance")(1/5=1 "Above subsistance")(else=.), gen(expend1)
lab var income1 "Income brackets"
lab var expend1 "Expenditure brackets"
tab income1, gen(income1_)
tab expend1, gen(expend1_)

recode r_05(-2/-1 1/5=0 "High/Not disclosed")(4/8=1 "Low income")(else=.), gen(income2)
recode r_06(-2/-1 1/5=0 "High/Not disclosed")(4/8=1 "Low expenditure")(else=.), gen(expend2)
lab var income2 "Low income {<800 GEL}"
lab var expend2 "Low expenditure {<800 GEL}"

** HH size
lab var hhsize "Number of all adult HH members"

gen adultn=nadhh_m
lab var adultn "Number of adult HH members"

gen child=hhsize-adultn
lab var child "Number of children in HH" 

** married
recode r_04(2 4=1 "Married")(1 3 5=0 "Not married")(else=.), gen(marry)

** Internet use
recode m_01 (1 2=1 "Often")(-1 3/6=0 "Never")(else=.), gen(inter)
lab var inter "Frequency of internet use"

** media
recode m_19	(-1 1/3=0 "No trust")(4/5=1 "Trust")(else=.), gen(imedi)
lab var imedi "Do you trust/distrust? - Imedi"
recode m_20	(-1 1/3=0 "No trust")(4/5=1 "Trust")(else=.), gen(R2)
lab var R2	"Do you trust/distrust? - Rustavi 2"
recode m_21	(-1 1/3=0 "No trust")(4/5=1 "Trust")(else=.), gen(gpb)
lab var gpb	"Do you trust/distrust? - GPB1"

** gender
recode g_04 (-1 1 2=0 "Not important")(3/4=1 "Imortant")(else=.), gen(mfbalance)
lab var mfbalance "Importance of balanced representation of male-female candidates for party"
recode g_05 (-1 1 2=0 "Not positive")(3=1 "Positive")(else=.), gen(mpwomen)
lab var mpwomen "What kind of impact would increasing the number of women MPs have on Georgia?"

/// covariates -- running tally
*******************************************************************************

** expected economic conditions
recode r_07 (-1 1/3=0 "Not improve")(4/5=1 "Improve")(else=.), gen(expect)
lab var expect "Expected economic conditions for the next year"

** HH conditions since 2012
recode i_01 (-1 1 2=0 "Not better")(3=1 "Better")(else=.), gen(hhcond)
lab var hhcond "HH conditions since 2012"

** change of situation
recode i_25 (1=-1)(-1 2=0)(3=1)(else=.), gen(i1)
recode i_26 (1=-1)(-1 2=0)(3=1)(else=.), gen(i2)
recode i_27 (1=-1)(-1 2=0)(3=1)(else=.), gen(i3)
recode i_28 (1=-1)(-1 2=0)(3=1)(else=.), gen(i4)
recode i_29 (1=-1)(-1 2=0)(3=1)(else=.), gen(i5)
recode i_30 (1=-1)(-1 2=0)(3=1)(else=.), gen(i6)
recode i_31 (1=-1)(-1 2=0)(3=1)(else=.), gen(i7)
recode i_32 (1=-1)(-1 2=0)(3=1)(else=.), gen(i8)
recode i_33 (1=-1)(-1 2=0)(3=1)(else=.), gen(i9)
recode i_34 (1=-1)(-1 2=0)(3=1)(else=.), gen(i10)
recode i_35 (1=-1)(-1 2=0)(3=1)(else=.), gen(i11)
recode i_36 (1=-1)(-1 2=0)(3=1)(else=.), gen(i12)

egen polsit=rowtotal(i1-i12)
recode polsit(-12/-1=0 "Negative")(0/12=1 "Not negative"), gen(polsit2)
lab var polsit "Change of situation in policy areas"
lab var polsit2 "Change of situation in policy areas"
drop i1-i12

** country's direction
recode a_01 (-1 1/3=0 "Not right")(4/5=1 "Right")(else=.), gen(dire)
lab var dire "Country's direction - right?"

** attitudes to government
// central government in wave 24, local government in wave 25
gen gchange=.
replace gchange=0 if wave==24&(a_02==1|a_02==2|a_02==-1)
replace gchange=0 if wave==25&(a_03==1|a_03==2|a_03==-1)
replace gchange=1 if wave==24&(a_02==3|a_02==4)
replace gchange=1 if wave==25&(a_03==3|a_03==4)
lab var gchange "Government makes changes that matter for you"

** vote decision
recode p_11 (-7 -1 2 3=0 "Else")(1=1 "Before campaign")(else=.), gen(whendec)
lab var whendec "When decided to vote?"

** checked voters' list
recode e_01 (-1 0=0 "No")(1=1 "Checked")(else=.), gen(check)
lab var check "Did you check yourself in the voters' lists prior to election day?"

** foreign relations
recode f_03(1/2=1 "EU")(-1 3 4 5=0 "Not EU")(else=.), gen(euappr)
lab var euappr "EU support"


***
order wave oldid id_m panel_m psu_m hhid stratum_m substratum_m ///
cn_25a - euappr ///
r_20-r_26 r_20r-r_26r p_12-p_21 e_12-e_13 ce_02-ce_05 m_19-m_21

save "Merged_Wave_24_25_recoded_long.dta", replace


*******************************************************************************
*******************************************************************************
*******************************************************************************

clear all
use "Merged_Wave_24_25_recoded_long.dta", replace

keep wave oldid id_m panel_m psu_m hhid stratum_m substratum_m ///
cn_25a - m_21


** reshape

reshape wide id_m panel_m psu_m hhid stratum_m substratum_m ///
cn_25a - m_21,  i(oldid) j(wave)

gen oddage=age25-age24
fre oddage
keep if oddage==0|oddage==1

** labels

lab define gchange 0 "Not positive" 1 "Positive" 
lab values gchange25 gchange
lab define expect1 0 "Will not improve" 1 "Will improve" 
lab values expect25 expect1

gen pid_24a=pid_a124
gen pid_24b=pid_b124
gen pid_24c=pid_c124
gen pid_25a=pid_a125
gen pid_25b=pid_b125
gen pid_25c=pid_c125

gen voten_24a=voten_a124
gen voten_24b=voten_b124
gen voten_24c=voten_c124

gen votew_24a=votew_a124
gen votew_24b=votew_b124
gen votew_24c=votew_c124

gen votep_24a=votep_a124
gen votep_24b=votep_b124
gen votep_24c=votep_c124

** pid dummies
tab pid_24c, gen(pid_24_)
tab pid_25c, gen(pid_25_)

gen pid_24_np=pid_24_1
gen pid_24_gd=pid_24_2
gen pid_24_unm=pid_24_3
gen pid_24_other=pid_24_4

gen pid_25_np=pid_25_1
gen pid_25_gd=pid_25_2
gen pid_25_unm=pid_25_3
gen pid_25_other=pid_25_4

** never vote for party dummies
tab voten_24c, gen(voten_)
gen voten_np=voten_1
gen voten_gd=voten_2
gen voten_unm=voten_3
gen voten_other=voten_4

** expected winner dummies
tab votew_24c, gen(votew_)
gen votew_np=votew_1
gen votew_gd=votew_2
gen votew_unm=votew_3
gen votew_other=votew_4

gen cn=cn_2525
gen cn_c=cn_25_c25

lab define contact 0 "Not contacted" 1 "Contacted" 
lab values cn contact
lab var cn "Contacted personally on behalf of a party? {wave 25}"

lab define pid1 0 "Nonpartisan" 1 "Partisan"  
lab define pid2 0 "Nonpartisan" 1 "GD" 2 "Opposition" 
lab define pid3 0 "Nonpartisan" 1 "GD" 2 "UNM" 3 "Opposition" 

lab define p1 0 "No party" 1 "A party" 
lab define p2 0 "No party" 1 "GD" 2 "Opposition"
lab define p3 0 "No party" 1 "GD" 2 "UNM" 3 "Other"

gen turn_pre=turn_pre_a24
gen turn_post=turn_post_a25
lab var turn_pre "Reported future turnout"
lab var turn_post "Reported past turnout"
lab define turn_24 0 "Will not vote" 1 "Will vote"
lab values turn_pre turn_24
lab define turn_25 0 "Did not vote" 1 "Voted"
lab values turn_post turn_25

lab values pid_24a pid1
lab values pid_25a pid1
lab values pid_24b pid2
lab values pid_25b pid2
lab values pid_24c pid3
lab values pid_25c pid3

lab values votep_24a p1
lab values votep_24b p2
lab values votep_24c p3

lab values voten_24a p1
lab values voten_24b p2
lab values voten_24c p3

lab values votew_24a p1
lab values votew_24b p2
lab values votew_24c p3

gen psu=psu_m24
drop psu_m25

gen settype=settype24
drop settype25

gen age=age24
drop age25

gen agegr=agegr24
drop agegr25

gen female=female24
drop female25

egen respass=rowtotal(r_20r24-r_26r24)
lab var respass "Respondent assessment index"

order oldid id_m24 id_m25 psu settype age agegr female marry* respass ///
cn pid_* voten_* votew_* votep_* ///
turn_pre turn_post ///
edu* empl* poss* attint* income* expend* adultn* child* marry* inter* imedi* R2* ///
expect* hhcond* polsit* polsit* dire* gchange* check* whendec* euappr* decided* knowmp* mpgood* mpbad*

save "Merged_Wave_24_25_recoded_wide_2608.dta", replace
///////////////////////////////////////////////////////////////////////////////
