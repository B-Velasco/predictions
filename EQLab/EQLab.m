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
FunctionsAreInitizialed=False;


(* ::Input::Initialization:: *)
npredictorsDEFAULT=4;
nquestionsDEFAULT=20;


(* ::Input::Initialization:: *)
VARNAME={
"npredictors",
"nquestions"
};
SUPERARRAYNAME={
"EXPERIMENT",(*indices are:  iexperiment,iquestion*)
"PLOTS",           (*indices are:  iexperiment,iquestion*)
"CSURPRISAL",(*cumulative surprisals, indices are : iexperiment, iplayer,iquestion*)
"CREWARD"  ,        (*cumulative rewards, indices are : iexperiment, iplayer,iquestion*)
"ASURPRISAL"          (*cumulative rewards, indices are : iexperiment, iplayer,iquestion*)
};


(* ::Input::Initialization:: *)
index1=<| 
"forecast"->1,
"measurement"->2,
"resolution"->3,
"outcome"->4,
"surprisal"->5,
"reward"->6
|>;

index2=<| 
"p"->1,
"m"->2,
"v"->3,
"q"->4,
"s"->5,
"r"->6
|>;
INDEX=Join[index1,index2];
Protect[index1,index2,INDEX]

(*to search plots by key*)
ASSOCIATIONPLOTS[iexp_]:=
<|
"p"->PLOTS[[iexp,1,1]],"m"->PLOTS[[iexp,1,2]],"v"->PLOTS[[iexp,1,3]],
"q"->PLOTS[[iexp,2,1]],"s"->PLOTS[[iexp,2,2]],"r"->PLOTS[[iexp,2,3]],
"sstat"->PLOTS[[iexp,3,1]],"savgj"->PLOTS[[iexp,3,2]],"rcumul"->PLOTS[[iexp,3,3]]
|>;



(* ::Input::Initialization:: *)
InitVariables[]:=Module[
{ivar=1,ivarmax=(VARNAME//Length),userdefined=False,
var="",user="",default=""},
For[ivar=1,ivar<=ivarmax,ivar++,
var=VARNAME[[ivar]];
user=VARNAME[[ivar]]<>"USER";
default=VARNAME[[ivar]]<>"DEFAULT";
userdefined=(user//ToExpression//NumberQ);
Which[userdefined,var<>"="<>user,True,var<>"="<>default]//ToExpression;
]
]

InitSuperarrays[]:=Module[
{isuperarray=1,isuperarraymax=(SUPERARRAYNAME//Length),userdefined=False,
superarray="",user="",default=""},
For[isuperarray=1,isuperarray<=isuperarraymax,isuperarray++,
superarray=SUPERARRAYNAME[[isuperarray]];
superarray<>"={}"//ToExpression;

(*protect super arrays from user modification*)
SUPERARRAYNAME[[isuperarray]]<>"//Protect"//ToExpression
]
]


Init[]:=Module[
{},
InitVariables[];
InitSuperarrays[];
]

Init[];



(* ::Input::Initialization:: *)
Outcome[question_]:=question[[3]]//Mean//N//Sign;

Surprisal[question_]:=Table[Which[NumericQ[question[[1,i]]]&&NumericQ[question[[4]]],Which[question[[4]]>0,-Log[question[[1,i]]],question[[4]]<0,-Log[1-question[[1,i]]],question[[4]]==0,0],True,I],{i,1,question[[1]]//Length}];
Reward[question_]:=Module[
{R,pi,si,pc,c=1,q,V,smean,\[CapitalDelta]s,ri,ipredictor,r={}(*List of rewards *)},
smean=question[[5]]//Mean;
\[CapitalDelta]s=question[[5]]//StandardDeviation;
V=question[[3]]//Mean//Abs;
R=\[CapitalDelta]s*V//Abs;
pc=Exp[-smean-c*\[CapitalDelta]s];

q=question[[4]];

For[ipredictor=1,ipredictor<=npredictors,ipredictor++,

pi=question[[1,ipredictor]];

si=question[[5,ipredictor]];

ri=Which[
q>0,R Log[pi/pc],
q<0,R Log[(1-pi)/pc],
q==0,0
];



AppendTo[r,ri];


];

r

]



(* ::Input::Initialization:: *)

blankpredictorcontainer[]:=Module[
{forecast},
forecast=ConstantArray[0,npredictors]
]

blankpredictorcontainer[init_]:=Module[
{forecast},
forecast=ConstantArray[init,npredictors]
]

blankquestion[]:=Module[
{question,
p,m,v,q,s,r},

p=blankpredictorcontainer[];
m=0;
v=blankpredictorcontainer[];
q=0;
s=blankpredictorcontainer[Indeterminate];
r=blankpredictorcontainer[];

question={
p,
m,
v,
q,
s,
r
};

question
]


blankexperiment[]:=Module[
{experiment,
p,m,v,q,s},
experiment={}
]



(* ::Input::Initialization:: *)

SetAttributes[askquestion,HoldAll];
SetAttributes[predict,HoldAll];
SetAttributes[measure,HoldAll];
SetAttributes[resolve,HoldAll];
SetAttributes[outcome,HoldAll];
SetAttributes[surprisal,HoldAll];
SetAttributes[reward,HoldAll];

predict[experiment_,newquestion_]:=Module[
{p},
p=PREDICT[experiment];
newquestion=newquestion//ReplacePart[1->p];
]

measure[newquestion_]:=Module[
{m},
m=MEASURE[];
newquestion=newquestion//ReplacePart[2->m];
]

resolve[experiment_,newquestion_]:=Module[
{v},
v=RESOLVE[experiment,newquestion];
newquestion=newquestion//ReplacePart[3->v];
]

outcome[newquestion_]:=Module[
{q},
q=Outcome[newquestion];
newquestion=newquestion//ReplacePart[4->q];
]

surprisal[newquestion_]:=Module[
{s},
s=Surprisal[newquestion];
newquestion=newquestion//ReplacePart[5->s];
]

reward[newquestion_]:=Module[
{r},
r=Reward[newquestion];
newquestion=newquestion//ReplacePart[6->r];
]


askquestion[experiment_]:=Module[
{newquestion=blankquestion[]},

predict[experiment,newquestion];
measure[newquestion];
resolve[experiment,newquestion];
outcome[newquestion];
surprisal[newquestion];
reward[newquestion];

AppendTo[experiment,newquestion]

]



(* ::Input::Initialization:: *)

defaultforecastinit=Table[Random[],{i,1,npredictors}];Protect[defaultforecastinit]

DefaultPredict[exp_]:=Module[
{ipredictor,n=(exp//Length),\[Rho]new,RHOnew={}},(*internal variables*)

For[ipredictor=1,ipredictor<=npredictors,ipredictor++,(*loop over users*)

If[(*to execute commands that depend on the question number 'n+1' *)
n==0,(*if*)

\[Rho]new=defaultforecastinit[[ipredictor]],(*then*)

\[Rho]new=exp[[n,1,ipredictor]](*else*)

];

AppendTo[RHOnew,\[Rho]new];

];

RHOnew

]

DefaultMeasure[]:=(Random[]//Which[#<0.4,1,True,-1]&);


(*to match function prototype *)
DefaultResolve[experiment_,question_]:=DefaultResolve[question];
(*actual function*)
DefaultResolve[question_]:=Table[Random[]//Which[#<0.05,-question[[2]],True,question[[2]]]&,{i,1,question[[1]]//Length}]









(* ::Input::Initialization:: *)
PLOTSTYLE1={
ASPECTRATIO->5/8,
IMAGESIZE->360,
IMAGEPADDING->{{0, 20}, {0,20}},
PLOTRANGEPADDING->Scaled[.1],
PLOTMARKERS->"OpenMarkers",
PLOTRANGE->Full,
LABELSTYLE->Directive[Black,Bold,Medium]
};
PLOTSTYLE2={
ASPECTRATIO->5/8,
IMAGESIZE->400,
IMAGEPADDING->{{0, 20}, {0,20}},
PLOTRANGEPADDING->Scaled[.1],
PLOTMARKERS->"OpenMarkers",
PLOTRANGE->Full,
LABELSTYLE->Directive[Black,Bold,Medium]
};
PLOTSTYLE3={
ASPECTRATIO->5/8,
IMAGESIZE->360,
IMAGEPADDING->{{0, 20}, {0,20}},
PLOTRANGEPADDING->Scaled[.1],
PLOTMARKERS->{"OpenMarkers",Tiny},
PLOTRANGE->Full,
LABELSTYLE->Directive[Black,Bold,Medium]
};

pPlot[iexperiment_]:=(Table[EXPERIMENT[[iexperiment,All,1]][[All,i]],{i,1,npredictors}]//ListLogLinearPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(p\), \(\(\\\ \)\(i\\\ j\)\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE1);
mPlot[iexperiment_]:=(EXPERIMENT[[iexperiment,All,2]]//ListLogLinearPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(m\), \(\(\\\ \)\(j\)\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE1);

vPlot[iexperiment_]:=(Table[EXPERIMENT[[iexperiment,All,3]][[All,i]],{i,1,npredictors}]//ListLogLinearPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(v\), \(\(\\\ \)\(i\\\ j\)\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE1);

qPlot[iexperiment_]:=(EXPERIMENT[[iexperiment,All,4]]//ListLogLinearPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(q\), \(\(\\\ \)\(j\)\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE1);


sPlot[iexperiment_]:=(Table[EXPERIMENT[[iexperiment,All,5]][[All,i]],{i,1,npredictors}]//ListLogLinearPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(s\), \(\(\\\ \)\(i\\\ j\)\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE1);

rPlot[iexperiment_]:=(Table[EXPERIMENT[[iexperiment,All,6]][[All,i]],{i,1,npredictors}]//ListLogLogPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(r\), \(\(\\\ \)\(i\\\ j\)\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE1);


sStatPlot[iexperiment_]:=(Table[(Around[EXPERIMENT[[iexperiment,All,5]][[i]]//Mean,EXPERIMENT[[iexperiment,All,5]][[i]]//StandardDeviation]),{i,1,EXPERIMENT[[iexperiment,All,5]]//Length}]//ListLogLinearPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->{marker1,0.016},PlotStyle->Directive[Red],PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(s\), \(\(\\\ \)\(j\)\)]\)\[PlusMinus]\[CapitalDelta]s"},LabelStyle->LABELSTYLE(*,Epilog\[Rule]{Directive[Red,Thick],Line[{{0,prob},{100,prob}}]}*)]&/.PLOTSTYLE1);


savgPlot[iexperiment_]:=(ASURPRISAL[[iexperiment]]//ListPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","<\!\(\*SubscriptBox[\(s\), \(i\)]\)\!\(\*SubscriptBox[\(>\), \(1 \[Rule] j\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE3);

rcumPlot[iexperiment_]:=(CREWARD[[iexperiment]]//ListPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(r\), \(ij\)]\)(cumul.)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE3);


marker1=Graphics[{Blue,Disk[]}];


(* ::Input::Initialization:: *)
getcumulative[list_]:=Module[
{i,length=list//Length,cumulative},

cumulative=ConstantArray[0,length];

cumulative[[1]]=list[[1]];

For[i=2,i<=length,i++,

cumulative[[i]]=list[[i]]+cumulative[[i-1]]

];
cumulative
]


getaveragej[list_]:=Module[
{j,length=list//Length,cumulative,averagej},

cumulative=getcumulative[list];
averagej=ConstantArray[0,length];

For[j=1,j<=length,j++,

averagej[[j]]=cumulative[[j]]/j;

];
averagej
]






(* ::Input::Initialization:: *)
SetDefaultFunctions[]:=Module[
{},
PREDICT=DefaultPredict;
MEASURE=DefaultMeasure;
RESOLVE=DefaultResolve;

Unprotect[FunctionsAreInitizialed];
FunctionsAreInitizialed=True;
Protect[FunctionsAreInitizialed];

]

SetUserFunctions[]:=Module[
{isprotected=FunctionsAreInitizialed//Attributes//MemberQ[#,Protected]&},



PREDICT=UserPredict;
MEASURE=UserMeasure;
RESOLVE=UserResolve;

Unprotect[FunctionsAreInitizialed];
FunctionsAreInitizialed=True;
Protect[FunctionsAreInitizialed];

]


CalcCumulative[iexperiment_]:=Module[
{S={},R={},CS={},CR={}},
S=EXPERIMENT[[iexperiment,All,INDEX["s"]]]//Transpose;
R=EXPERIMENT[[iexperiment,All,INDEX["r"]]]//Transpose;
CS=getcumulative/@S;
CR=getcumulative/@R;
Unprotect[CSURPRISAL,CREWARD];
CSURPRISAL[[iexperiment]]=CS;
CREWARD[[iexperiment]]=CR;
Protect[CSURPRISAL,CREWARD];
]


CalcCumulative[]:=Module[
{length=CSURPRISAL//Length},
If[length>0, 
CalcCumulative[length],
Print["No experiments present."];
]
]

CalcAveragej[iexperiment_]:=Module[
{S={},AS={}},
S=EXPERIMENT[[iexperiment,All,INDEX["s"]]]//Transpose;
AS=getaveragej/@S;
Unprotect[ASURPRISAL];
ASURPRISAL[[iexperiment]]=AS;
Protect[ASURPRISAL];
]


CalcAveragej[]:=Module[
{length=CSURPRISAL//Length},
If[length>0, 
CalcAveragej[length],
Print["No experiments present."];
]
]

CalcStat[iexperiment_]:=Module[
{},
CalcCumulative[iexperiment];
CalcAveragej[iexperiment];
]

CalcStat[]:=Module[
{},
CalcCumulative[];
CalcAveragej[];
]



RunExperiment[]:=Module[
{experiment=blankexperiment[],iquestion},

(*to set  default functions if user has not define their own *)
If[
!FunctionsAreInitizialed,
SetDefaultFunctions[],
Unprotect[FunctionsAreInitizialed];
FunctionsAreInitizialed=True;
Protect[FunctionsAreInitizialed]
];

For[iquestion=1,iquestion<=nquestions,iquestion++,
askquestion[experiment]
];

(*these to keep superarray sizes consistent*)
"Unprotect["<>#<>"]"&/@(SUPERARRAYNAME//DeleteCases["EXPERIMENT"])//ToExpression;
"AppendTo["<>#<>",False]"&/@(SUPERARRAYNAME//DeleteCases["EXPERIMENT"])//ToExpression;
"Protect["<>#<>"]"&/@(SUPERARRAYNAME//DeleteCases["EXPERIMENT"])//ToExpression;

(*store experiment in superarray*)
EXPERIMENT//Unprotect;
AppendTo[EXPERIMENT,experiment];
EXPERIMENT//Protect;

(*calculate cumulative s,r and average s*)
CalcStat[]
]


MakePlots[iexperiment_]:=Module[
{plots={},length=(EXPERIMENT//Length),cantdoplot},


cantdoplot=(
TrueQ[length<iexperiment^2//Sqrt]||
(length==0)||
(!IntegerQ[iexperiment])
);

If[
cantdoplot,(*if*)

Print["Experiment i = ",iexperiment," no present."],(*then*)

plots={
{pPlot[iexperiment], mPlot[iexperiment],vPlot[iexperiment]}, 
{qPlot[iexperiment],sPlot[iexperiment],rPlot[iexperiment]},
{sStatPlot[iexperiment],savgPlot[iexperiment],rcumPlot[iexperiment]}
};



PLOTS//Unprotect;
PLOTS[[iexperiment]]=plots;
PLOTS//Protect;

]
]


MakePlots[]:=Module[
{length=EXPERIMENT//Length},
If[length>0,
MakePlots[length],
Print["No experiment to plot."]
]
]



ShowPlots[iexperiment_]:=Module[
{length=PLOTS//Length,indexissue=False,notpresent=False,cantshowplot,grid},

indexissue=
(
TrueQ[length<(iexperiment^2//Sqrt)]||
(length==0)||
(!IntegerQ[iexperiment])
);

notpresent=Which[indexissue,indexissue,True,TrueQ[!PLOTS[[iexperiment]]]];

If[notpresent,MakePlots[iexperiment],Nothing];

If[
indexissue,(*if*)

Print["Plots i = ",iexperiment," not present."];(*then*)
grid=0,

grid=Grid[PLOTS[[iexperiment]],Spacings->{2,3}](*else*)


];
grid
]

ShowPlots[]:=Module[
{length=PLOTS//Length,grid},
If[length>0, 
grid=ShowPlots[length],
Print["No plots to show."];
grid=0
];
grid
]

(*warning: does not check if plot is present *)
ShowPlots[iexp_,key_]:=Module[
{output,failmessage="second argument must be one of: "},
failmessage=failmessage<>(ASSOCIATIONPLOTS[1]//Normal//Part[#,All,1]&//ToString//StringReplace[{" "->"",","->"\",\"","{"->"{\"","}"->"\"}"}]);

output=ASSOCIATIONPLOTS[iexp][key]/._Missing->failmessage//Show
]


(*CalcCumulative[iexperiment_]:=Module[
{S={},R={},CS={},CR={}},
S=EXPERIMENT[[iexperiment,All,INDEX["s"]]]//Transpose;
R=EXPERIMENT[[iexperiment,All,INDEX["r"]]]//Transpose;
CS=getcumulative/@S;
CR=getcumulative/@R;
Unprotect[CSURPRISAL,CREWARD];
CSURPRISAL[[iexperiment]]=CS;
CREWARD[[iexperiment]]=CR;
Protect[CSURPRISAL,CREWARD];
]


CalcCumulative[]:=Module[
{length=CSURPRISAL//Length},
If[length>0, 
CalcCumulative[length],
Print["No experiments present."];
]
]*)
