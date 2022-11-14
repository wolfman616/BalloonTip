;	BalloonTip @ Xords - Matthew Wolff (2022)

; BalloonTip("blablablah","Title:",2955,22,false)
; return,
 
BalloonTip(txt,title,x="",y="",isGuiExist="",Dur:=5) {
	isint(title)? (Dur:=isGuiExist, isGuiExist:=y
	, y:=x, x:=title, title:="") : ()
	(!x?x:=a_screenwidth), (!y?y:=a_screenheight-20)
	if isGuiExist
		gui,add,edit,disabled x%x% y%y% w1 h1 hwndhWnd
	else {
		gui,testt:new,-dpiscale
		gui,testt:add,edit,disabled x%x% y%y% w1 h1 hwndhWnd
	}
	_ShowBalloonTip(hWnd,title,txt,"")
	(fn:= Func("BallKill").Bind(Dur,hWnd)).Call(Dur)
	return,
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

BallKill(Dur,hWnd) {
	sleep,% Dur*1000
	HideBalloonTip(hWnd)
	DllCall("SetParent","uint",hWnd,"uint","")
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