<?xml version="1.0" encoding="euc-kr"?><%  Response.ContentType = "text/xml" %>
<!DOCTYPE cate_root[
	<!ELEMENT cate_root (isrows*)>
	<!ELEMENT isrows (iscols+)>
		<!ELEMENT iscols (#PCDATA)>
]><% Dim key,keygbn,keyary
key = Request.Form("key")
keygbn = Request.Form("keygbn")
keyAry = Request.Form("keyary")

Dim pgView
 if key = "" or keygbn = "" or keyary = "" then
 	pgView = False
 else
 	pgView = True
 end if %>
<cate_root><% if pgView then %><!-- #include file="../../include/dbcon.asp" --><%

	Dim sql,strMsg

	''keygbn 0:사용안함,1:사용함
	if int(keygbn) > 0 then
		strMsg = "사용함으로 설정했습니다"
	else
		strMsg = "사용안함으로 설정했습니다."
	end if

	sql = "update PopInfoTab set pop_gbn=" & keygbn & " where pop_idx=" & key
	db.execute(sql)
	db.close
	set db = nothing %>
	<isrows>
		<iscols><%=strMsg%></iscols>
		<iscols><%=keyary%></iscols><% if int(keygbn) > 0 then %>
		<iscols><![CDATA[<span style="cursor:pointer;color:#666666;" onclick="UsePop('<%=key%>',0,'<%=keyary%>');">사용중]]></iscols><% else %>
		<iscols><![CDATA[<span style="cursor:pointer;color:#CC0000;" onclick="UsePop('<%=key%>',1,'<%=keyary%>');">사용안함]]></iscols><% end if %>
	</isrows><% end if %>
</cate_root>