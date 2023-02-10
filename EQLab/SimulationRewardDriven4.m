(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
Unprotect[npredictors];
<<EQLab2`



(* ::Input::Initialization:: *)

SUPERARRAYNAME=(Join[SUPERARRAYNAME,{"BELIEF"}]//DeleteDuplicates);
(*ArraysNamesSimRewardDriven={"BiasAffPair","BeliefFinal"};*)
ConstNamesSimRewardDriven={"PredictivePower"};
(*VarNamesSimRewardDriven={"beliefin\[Alpha]","affinity","bias","randomwalkh"};*)




(* ::Input::Initialization:: *)
(*measurements*)

UserMeasure[]:=RandomReal[]//Which[#<ProbabilityPlus,1,True,-1]&(*simple yes or no answer with equal probability*)
(*forecasts*)
predictivepower2[xrandom_,meas_]:=Which[meas==1,1-xrandom^6,meas==-1,xrandom^6]
predictivepower1[xrandom_,meas_]:=Which[meas==1,1-xrandom^2,meas==-1,xrandom^2]
predictivepower0[xrandom_,meas_]:=Which[meas==1,1-xrandom,meas==-1,xrandom]
predictivepowerm1[xrandom_,meas_]:=Which[meas==1,xrandom^(2) ,meas==-1,1-xrandom^(2) ]
predictivepowerm2[xrandom_,meas_]:=Which[meas==1,xrandom^(6) ,meas==-1,1-xrandom^(6) ]

predictivepowerOLD[xrandom_,meas_,g_]:=Which[(*should correspond to p(\[Nu],di) in Eq 17*)
g==2,predictivepower2[xrandom,meas],
g==1,predictivepower1[xrandom,meas],
g==0,predictivepower0[xrandom,meas],
g==-1,predictivepowerm1[xrandom,meas],
g==-2,predictivepowerm2[xrandom,meas]
]

Unprotect[INFOPREDICTIVEPOWER];
INFOPREDICTIVEPOWER="";
Protect[INFOPREDICTIVEPOWER];
BuildPredictivePowerFunction[dmax_:4,dsteps_:8]:=Module[
{forecastavgMAX,forecastavgNeutral,
dValues,\[Nu]Values,
predictivepowerPositived,
predictivepowerNegatived,
info=""
},

(*power for best predictive power 1-x^\[Nu]*)
forecastavgMAX=\[Nu]/(1+\[Nu])/.\[Nu]->21;(*2\[Sigma]*);
(*forecastavgMAX=\[Nu]/(1+\[Nu])/.\[Nu]\[Rule]6;(*OLD*)*)
(*power for neutral predictive power 1-x^\[Nu]*)
forecastavgNeutral=\[Nu]/(1+\[Nu])/.\[Nu]->1;
(*value of d assigned to best predictive power*)
dMAX=dmax;
(*number of steps for d, between worst and best predictive power*)
dSTEPS=dsteps;
(*size of step for random walk and affinity updating*)
dSTEPSIZE=2 dmax/dsteps;

\[Nu]Values=Table[avg/(1-avg),{avg,Range[forecastavgNeutral,forecastavgMAX,(forecastavgMAX-forecastavgNeutral)/(dsteps/2)]}];
Print["\[Nu] values = ",\[Nu]Values//N];

dValues=Range[0,dmax,dmax/(dsteps/2)];(*d values always symmetric d=[-a,...,0,...,a]*)
dValues=Join[-dValues[[2;;-1]],dValues]//Sort;

predictivepowerPositived=Table[ToString[dValues[[dsteps/2+i]]]<>"->(1-#^("<>ToString[\[Nu]Values[[i]]//N]<>")&)",{i,1,\[Nu]Values//Length}];
predictivepowerNegatived=Table[ToString[dValues[[i]]]<>"->(#^("<>ToString[(\[Nu]Values//Drop[#,1]&//Reverse)[[i]]//N]<>")&)",{i,1,dsteps/2}];
predictivepowerd=Association@@ToExpression/@Join[predictivepowerNegatived,predictivepowerPositived];

(*for info files*)
info=info<>"######## predictive power function genereted by calling: "<>"'BuildPredictivePowerFunction["<>ToString[dmax]<>","<>ToString[dsteps]<>"]'\n";
info=info<>"dMAX = "<>ToString[dMAX]<>"\n";
info=info<>"dSTEPS = "<>ToString[dSTEPS]<>"\n";
info=info<>"dSTEPSIZE = "<>ToString[dSTEPSIZE]<>"\n";
info=info<>"forecastavgMAX = "<>ToString[forecastavgMAX//N]<>"\n";
info=info<>"PowerValues = "<>ToString[\[Nu]Values//N]<>"\n";
info=info<>"forecastavg = "<>ToString[
Join[
(1-Range[forecastavgNeutral,forecastavgMAX,(forecastavgMAX-forecastavgNeutral)/(dsteps/2)])//Reverse,
Range[forecastavgNeutral,forecastavgMAX,(forecastavgMAX-forecastavgNeutral)/(dsteps/2)]
]//DeleteDuplicates//N
]<>"\n";
Unprotect[INFOPREDICTIVEPOWER];INFOPREDICTIVEPOWER=info;Protect[INFOPREDICTIVEPOWER];

]

predictivepower[xrandom_,meas_,d_]:=Which[meas==1,predictivepowerd[d][xrandom],meas==-1,1-predictivepowerd[d][xrandom]]

BuildPredictivePowerFunction[]




(* ::Input::Initialization:: *)


(*Random walk update of belief according to draft*)
RandomWalk[]:=Module[
{rewards,maxreward,avgrewards,leadingexpert,stepplus={},stepminus={}},

RandomSeed[];
stepplus=Table[
Which[(*if \[Nu]1<h, proceed with random walk upwards*)
Random[]<=randomwalkh[[i]],dSTEPSIZE,
True,0
],
{i,1,beliefin\[Alpha]//Length}];

stepminus=Table[
Which[(*if \[Nu]2<h, proceed with random walk downwards*)
Random[]<=randomwalkh[[i]],-dSTEPSIZE,
True,0
],
{i,1,beliefin\[Alpha]//Length}];


(*update d_i according to random walk*)
beliefin\[Alpha]=beliefin\[Alpha]+stepplus+stepminus;


(*make sure that  -2 \[LessEqual] d_i \[LessEqual] 2, if not, force out of bounds values to wither +1 or -1*)
beliefin\[Alpha]=Table[
Which[
(beliefin\[Alpha][[i]]<-dMAX),(*new*)beliefin\[Alpha][[i]]=-dMAX(*new*)(*OLD*)(*beliefin\[Alpha][[i]]=-dMAX+1*)(*OLD*),
(beliefin\[Alpha][[i]]>  dMAX), (*new*)beliefin\[Alpha][[i]]=   dMAX(*new*)(*OLD*)(*beliefin\[Alpha][[i]]=dMAX-1*) (*OLD*),
True,beliefin\[Alpha][[i]]
],
{i,1,beliefin\[Alpha]//Length}
];

]


(* ::Input::Initialization:: *)




(* ::Input::Initialization:: *)

R0=50;(*20 experts, dmax=4 unit steps, ==> <rtot> = 100. Here using half that.*)
UpdateBelievein\[Alpha]Affinity[exp_]:=Module[
{rewards,maxreward,avgrewards,Largerewards,r0,rjtotal,leadingexpert,changebelief={},beliefin\[Alpha]TEMP,it,x=1,y=0},
rewards=CREWARD[[-1,All,-1]];
maxreward=Max[rewards];
avgrewards=Mean[rewards];
rjtotal=Plus@@(exp[[All,INDEX["r"]]][[-1]]);

x=1/2;y=1/2;(*OLD*)

Largerewards=x * avgrewards+y*maxreward;

r0=R0;(*new*)

(*r0=0.0;(*OLD*)*)

leadingexpert=Position[rewards,maxreward]//Flatten//Part[#,1]&;

RandomSeed[];

changebelief=Table[
TrueQ[
!(Random[]<Exp[- affinity[[i]](rjtotal/(rjtotal+r0))((Largerewards-rewards[[i]])/Largerewards )])   
]
,{i,1,beliefin\[Alpha]//Length}];(*new*)
(*changebelief=Table[
TrueQ[
!(Random[]<Exp[- affinity[[i]]((Largerewards-rewards[[i]])/Largerewards )])   
]
,{i,1,beliefin\[Alpha]//Length}];(*OLD*)*)

beliefin\[Alpha]=Table[
Which[
changebelief[[i]],beliefin\[Alpha][[i]]+dSTEPSIZE * Sign[  beliefin\[Alpha][[leadingexpert]]-beliefin\[Alpha][[i]]  ],
True,beliefin\[Alpha][[i]]
],
{i,1,beliefin\[Alpha]//Length}
];


];



(* ::Input::Initialization:: *)
UpdateBelievein\[Alpha][exp_]:=Module[
{},
RandomWalk[];
UpdateBelievein\[Alpha]Affinity[exp];
(*AppendTo[BeliefCurrent,beliefin\[Alpha]];*)
]



(* ::Input::Initialization:: *)

PrintBelievein\[Alpha][]:=Module[
{names=PLOTLEGENDS[[1,1;;npredictors]],output},
output=Table[names[[i]]<>"->"<>ToString[beliefin\[Alpha][[i]]]<>"\n",{i,1,npredictors}]//StringJoin;
Print[Style["------ Current belief in theory \[Alpha] ---------",Red,Large]];
Print[Style["after ",Bold,Large],Style[BeliefCurrent//Length,Bold,Large,Blue],Style[" questions.",Bold,Large]];
Print[Style[output,Blue,Large]]
]




(* ::Input::Initialization:: *)
FORECASTMAX=0.99;
UserPredict[exp_,newquestion_]:=Module[
{forecasts={},tags,forecasts2={}},
tags=PredictivePower//Keys;
AppendTo[BeliefCurrent,beliefin\[Alpha]];
Which[
(exp//Length)>= 2,UpdateBelievein\[Alpha][exp];,
True,Nothing
];

forecasts=Table[Random[]//PredictivePower[i][#,newquestion[[2]]]&,{i,tags}];(*new*)
(*forecasts=Table[RandomReal[{0.001,0.999}]//PredictivePower[i][#,newquestion[[2]]]&,{i,tags}];(*OLD*)*)
forecasts2=Which[1-FORECASTMAX<=#<=FORECASTMAX,#,1-FORECASTMAX>#,1-FORECASTMAX,#>FORECASTMAX,FORECASTMAX]&/@forecasts;(*new*)

forecasts2(*new*)
(*forecasts(*OLD*)*)
]


(* ::Input::Initialization:: *)

(*resolutions*)
B0=0.7;
UserResolve[exp_,newquestion_]:=Module[
{objectiveSij,objectiveSjavg,b0,resolutions,wj,i},
objectiveSij=ObjectiveSurprisal[newquestion];
objectiveSjavg=Mean[objectiveSij];
wj=newquestion[[2]];
b0=B0;
RandomSeed[];
resolutions=Table[
Which[
Random[]<Exp[-bias[[i]]*(objectiveSij[[i]]/(objectiveSjavg +b0))] , wj,
True,-wj
],
{i,1,newquestion[[1]]//Length}
](*new*)
(*resolutions=Table[
Which[
Random[]<Exp[-bias[[i]]*(objectiveSij[[i]]/objectiveSjavg -1)] , wj,
True,-wj
],
{i,1,newquestion[[1]]//Length}
](*OLD*)*)

]

InitSimulationRewardDriven[INITbeliefin\[Alpha]_List,INITaffinity_List,INITbias_List,INITrandomwalkh_List]:=Module[
{},

(*variables*)
Clear["npredictors*"];
npredictorsUSER=INITbeliefin\[Alpha]//Length;

beliefin\[Alpha]=INITbeliefin\[Alpha];
affinity=INITaffinity;
bias=INITbias;
randomwalkh=INITrandomwalkh;
BiasValues={};AffinityValues={};

BeliefCurrent={};
(*BELIEF={};*)

ProbabilityPlus=0.5;
Init[];
(*constant*)
Unprotect/@ConstNamesSimRewardDriven;
PredictivePower=Table["\"E"<>ToString[i]<>"\"\[Rule](predictivepower[#1,#2,beliefin\[Alpha][["<>ToString[i]<>"]]]&)",{i,1,npredictors}]//ToExpression//Apply[Association];
Protect/@ConstNamesSimRewardDriven;


]

InitExperimentRewardDriven[INITbeliefin\[Alpha]_List,INITaffinity_List,INITbias_List,INITrandomwalkh_List]:=Module[
{},

(*variables*)

beliefin\[Alpha]=INITbeliefin\[Alpha];
affinity=INITaffinity;
bias=INITbias;
randomwalkh=INITrandomwalkh;
BeliefCurrent={};
CONSECUTIVETRUECOUNT=0;
PREVIOUSTRUE=False;

]

StoreBeliefCurrent[]:=Module[
{index=EXPERIMENT//Length},

Unprotect[BELIEF];
(*AppendTo[BELIEF,BeliefCurrent];*)
BELIEF[[index]]=BeliefCurrent;
Protect[BELIEF];

]

(*condition to stop simulation (jogh)*)
CONSECUTIVETRUECOUNT=0;
PREVIOUSTRUE=False;
NSTABLE=4;(*baseline value*)
RTHRESHOLD=4.04;(*20 players , dmax=4, unit steps gives <rtot> = 2.02. Here using double *)
UserStop[]:=Module[
{condition1,out},

condition1=And[Length[CREWARD[[-1,1]]]>=NSTABLE,(CREWARD[[-1,All,-1]]-CREWARD[[-1,All,-2]]//Apply[Plus])<RTHRESHOLD];

If[CONSECUTIVETRUECOUNT<NSTABLE,
If[
!TrueQ[condition1],
CONSECUTIVETRUECOUNT=0;PREVIOUSTRUE=False;
(*Print["cond1=",condition1,"previous=",PREVIOUSTRUE,"CONSECUTIVETRUECOUNT=",CONSECUTIVETRUECOUNT]*),
If[
!PREVIOUSTRUE,
CONSECUTIVETRUECOUNT=1;PREVIOUSTRUE=True;(*Print["cond1=",condition1,"previous=",PREVIOUSTRUE,"CONSECUTIVETRUECOUNT=",CONSECUTIVETRUECOUNT]*),
CONSECUTIVETRUECOUNT++(*;Print["cond1=",condition1,"previous=",PREVIOUSTRUE,"CONSECUTIVETRUECOUNT=",CONSECUTIVETRUECOUNT]*)
]
],
Nothing
];
out=And[condition1,CONSECUTIVETRUECOUNT>=NSTABLE];
(*Print["out=",out];*)
out
]
(*condition to stop simulation (TR)*)
(*rTHRESHOLD=1/50*npredictors;
nSTABLE=10;
UserStop[]:=And[(REWARD[[-1,All,-1]]//StandardDeviation)<0.3,(AREWARD[[-1,1]]//Length)>10];*)

(*load user function into EQLab*)
SetUserFunctions[]


