;	BalloonTip @ Xords - Matthew Wolff (2022)

; use: BalloonTip("blablablah","Title:",2955,22,false,5)
;		|| BalloonTip("blablablah",2955,22) 
;		|| BalloonTip("blablablah")
; return,
 
BalloonTip(txt,title="",x="",y="",isGuiExist="",Dur="") {
static init, hedwnd
	isint(title)? (Dur:=isGuiExist, isGuiExist:=Y
	, Y:=X, X:=title, title:="") : (), (Dur=""?Dur:=5)
	(isint(isGuiExist)?isGuiExist>1?Dur:=isGuiExist,isGuiExist:="")
	(!X?X:=a_Screenwidth-400 :()),	(!Y?Y:=a_Screenheight-80)
	if isGuiExist
		gui,add,edit,disabled x%X% y%Y% w1 h1 hwndhedwnd
	;else,if(init) {
	;	win_animate(hEditx,"hide slide vpos",900) 
	;	try gui,testt:destroy
	;}
	init:= True
	gui,testt:new,-dpiscale
	gui,testt:add,edit,disabled x%X% y%Y% w1 h1 hwndhedwnd

	return,_ShowBalloonTip(hedwnd,title,txt,""), 
}

_ShowBalloonTip(hEdit,p_Title,p_Text,p_Icon:=0) {
	static EM_SHOWBALLOONTIP:= 0x1503
	loop,parse,% "TTI_NONE,TTI_INFO,TTI_WARNING,TTI_ERROR
	,TTI_INFO_LARGE,TTI_WARNING_LARGE,TTI_ERROR_LARGE",`,
		static (%a_loopfield%):= A_index
	cbSize:= (A_PtrSize=8)? 32:16, wTitle:=p_Title, wText:=p_Text
	if !isUnicode() {
		(StrLen(p_Title)? VarSetCapacity(wTitle,StrLen(p_Title)*2,0)
		,StrPut(p_Title,&wTitle,"UTF-16"))
		(StrLen(p_Text)? VarSetCapacity(wText,StrLen(p_Text)*2,0)
		,StrPut(p_Text,&wText,"UTF-16"))
	}	
	VarSetCapacity(EDITBALLOONTIP,cbSize)
	NumPut(cbSize, EDITBALLOONTIP,0,"Int")
	NumPut(&wTitle,EDITBALLOONTIP,(A_PtrSize=8)? 8:4,"Ptr")
	NumPut(&wText, EDITBALLOONTIP,(A_PtrSize=8)? 16:8,"Ptr")
	NumPut(p_Icon, EDITBALLOONTIP,(A_PtrSize=8)? 24:12,"Int")
	SendMessage,EM_SHOWBALLOONTIP,0,&EDITBALLOONTIP,,ahk_id %hEdit%
	Return,ErrorLevel
}

HideBalloonTip(hEdit) {
	Static EM_HIDEBALLOONTIP:= 0x1504
	SendMessage,EM_HIDEBALLOONTIP,0,0,,ahk_id %hEdit%
	Return,ErrorLevel
}

BallClean(Dur,hEdit) {
	(Dur<1000?Dur*=1000)
	sleep,% Dur
	HideBalloonTip(hEdit)
	gui,testt:destroy
}

isint(V) {
	if V is integer
		 return,1
	else,return,0
}

isUnicode() {
	if A_IsUnicode
		 return,1
	else,return,0
}
