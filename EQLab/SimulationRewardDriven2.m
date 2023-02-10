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
ConstNamesSimRewardDriven={"PredictivePower"};
VarNamesSimRewardDriven={"beliefin\[Alpha]","affinity","bias","randomwalkh"};



(* ::Input::Initialization:: *)
(*measurements*)

UserMeasure[]:=RandomReal[]//Which[#<ProbabilityPlus,1,True,-1]&(*simple yes or no answer with equal probability*)
(*forecasts*)
predictivepower2[xrandom_,meas_]:=Which[meas==1,1-xrandom^6,meas==-1,xrandom^6]
predictivepower1[xrandom_,meas_]:=Which[meas==1,1-xrandom^2,meas==-1,xrandom^2]
predictivepower0[xrandom_,meas_]:=Which[meas==1,1-xrandom,meas==-1,xrandom]
predictivepowerm1[xrandom_,meas_]:=Which[meas==1,xrandom^(2) ,meas==-1,1-xrandom^(2) ]
predictivepowerm2[xrandom_,meas_]:=Which[meas==1,xrandom^(6) ,meas==-1,1-xrandom^(6) ]

predictivepower[xrandom_,meas_,g_]:=Which[(*should correspond to p(\[Nu],di) in Eq 17*)
g==2,predictivepower2[xrandom,meas],
g==1,predictivepower1[xrandom,meas],
g==0,predictivepower0[xrandom,meas],
g==-1,predictivepowerm1[xrandom,meas],
g==-2,predictivepowerm2[xrandom,meas]
]



(* ::Input::Initialization:: *)


(*Random walk update of belief according to draft*)
RandomWalk[]:=Module[
{rewards,maxreward,avgrewards,leadingexpert,stepplus={},stepminus={}},


stepplus=Table[
Which[(*if \[Nu]1<h, proceed with random walk upwards*)
Random[]<=randomwalkh[[i]],1,
True,0
],
{i,1,beliefin\[Alpha]//Length}];

stepminus=Table[
Which[(*if \[Nu]2<h, proceed with random walk downwards*)
Random[]<=randomwalkh[[i]],-1,
True,0
],
{i,1,beliefin\[Alpha]//Length}];


(*update d_i according to random walk*)
beliefin\[Alpha]=beliefin\[Alpha]+stepplus+stepminus;


(*make sure that  -2 \[LessEqual] d_i \[LessEqual] 2, if not, force out of bounds values to wither +1 or -1*)
beliefin\[Alpha]=Table[
Which[
(beliefin\[Alpha][[i]]<-2),beliefin\[Alpha][[i]]=-2,
(beliefin\[Alpha][[i]]>  2),beliefin\[Alpha][[i]]=   2,
True,beliefin\[Alpha][[i]]
],
{i,1,beliefin\[Alpha]//Length}
];

]


(* ::Input::Initialization:: *)




(* ::Input::Initialization:: *)

UpdateBelievein\[Alpha]Affinity[]:=Module[
{rewards,maxreward,avgrewards,Largerewards,r0,leadingexpert,changebelief={},beliefin\[Alpha]TEMP,it},
rewards=CREWARD[[-1,All,-1]];
maxreward=Max[rewards];
avgrewards=Mean[rewards];
Largerewards=(maxreward+avgrewards)/2;
r0=0.5;

leadingexpert=Position[rewards,maxreward]//Flatten//Part[#,1]&;


changebelief=Table[
TrueQ[
!(Random[]<Exp[- affinity[[i]]((Largerewards-rewards[[i]])/(Largerewards + r0))]) 
]
,{i,1,beliefin\[Alpha]//Length}];

beliefin\[Alpha]=Table[
Which[
changebelief[[i]],beliefin\[Alpha][[i]]+Sign[  beliefin\[Alpha][[leadingexpert]]-beliefin\[Alpha][[i]]  ],
True,beliefin\[Alpha][[i]]
],
{i,1,beliefin\[Alpha]//Length}
];


];



(* ::Input::Initialization:: *)
UpdateBelievein\[Alpha][]:=Module[
{},
RandomWalk[];
UpdateBelievein\[Alpha]Affinity[];
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
UserPredict[exp_,newquestion_]:=Module[
{forecasts={},tags},
tags=PredictivePower//Keys;
AppendTo[BeliefCurrent,beliefin\[Alpha]];
Which[
(exp//Length)>1,UpdateBelievein\[Alpha][];,
True,Nothing
];
forecasts=Table[RandomReal[{0.001,0.999}]//PredictivePower[i][#,newquestion[[2]]]&,{i,tags}];
forecasts
]


(* ::Input::Initialization:: *)

(*resolutions*)

UserResolve[exp_,newquestion_]:=Module[
{objectiveSij,objectiveSjavg,b0,resolutions,wj,i},
objectiveSij=ObjectiveSurprisal[newquestion];
objectiveSjavg=Mean[objectiveSij];
wj=newquestion[[2]];
b0=0.7;

resolutions=Table[
Which[
Random[]<Exp[-bias[[i]]*(objectiveSij[[i]]/(objectiveSjavg +b0))] , wj,
True,-wj
],
{i,1,newquestion[[1]]//Length}
]

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

]

StoreBeliefCurrent[]:=Module[
{index=EXPERIMENT//Length},

Unprotect[BELIEF];
(*AppendTo[BELIEF,BeliefCurrent];*)
BELIEF[[index]]=BeliefCurrent;
Protect[BELIEF];

]

(*condition to stop simulation*)
UserStop[]:=((beliefin\[Alpha]//DeleteDuplicates//Length)==1)(*&&Length[BeliefCurrent]>100*);

(*load user function into EQLab*)
SetUserFunctions[]