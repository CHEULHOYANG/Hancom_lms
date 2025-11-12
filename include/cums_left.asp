<table width="180" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="140" background="../yes_img/e_img/img/cs_tel.gif"><table width="180" height="130" cellpadding="0" cellspacing="0">
      <tr height="46">
        <td width="178"></td>
      </tr>
      <tr height="34">
        <td><table width="100%" cellpadding="0" cellspacing="0">
            <tr>
              <td height="10" colspan="2"></td>
              </tr>
            <tr>
              <td width="56"></td>
              <td width="120"><b><font size=3px face="helvetica"><%=help_tel%></font></b></td>
            </tr>
        </table></td>
      </tr>

      <tr>
        <td><table width="100%" cellpadding="0" cellspacing="0">
            <tr height="14">
              <td height="10" colspan="2"></td>
              </tr>
            <tr height="14">
              <td width="26"></td>
              <td width="159">乞老 : <%=help_time1%></td>
            </tr>
            <tr height="14">
              <td width="26"></td>
              <td width="159">林富 : <%=help_time2%></td>
            </tr>
        </table></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td height="8"></td>
  </tr>
  <tr>
    <td height="8"><img src="../yes_img/pro_dwn_01.gif" width="180" height="35" /></td>
  </tr>
  <tr>
    <td height="8"><a href="http://windows.microsoft.com/en-US/windows/products/windows-media-player" target="_blank"><img src="../yes_img/pro_dwn_02.gif" width="180" height="37" border="0" /></a></td>
  </tr>
  <tr>
    <td height="8"><a href="http://windows.microsoft.com/ko-KR/internet-explorer/products/ie/home" target="_blank"><img src="../yes_img/pro_dwn_03.gif" width="180" height="39" border="0" /></a></td>
  </tr>
    <tr>
    <td height="8"><a href="../down/WM9Codecs.exe"><img src="../yes_img/pro_dwn_04.gif" width="180" height="39" border="0" /></a></td>
  </tr>    
  <tr>
    <td height="8"></td>
  </tr>    
  <tr>
    <td><% sql = "select bankname,banknumber,use_name from bank order by idx desc"
           set dr = db.execute(sql)
           dim isBank
            if not dr.bof or not dr.eof then
            	isBank =  True
            	dim bkRows,bkCols
            	bkRows = split(dr.GetString(2),chr(13))
            end if
            dr.close
          if isBank then %>

            <table width="180" border="0" cellpadding="0" cellspacing="0" background="../yes_img/32.gif">
              <tr>
                <td width="180"><img src="../yes_img/31.gif" width="180" height="7" /></td>
              </tr>
              <tr>
                <td align="center">
                <table width="160" border="0" cellspacing="0" cellpadding="0"><% for ii = 0 to UBound(bkRows) - 1
                bkCols = split(bkRows(ii),chr(9)) %>
                    <tr>
                      <td width="12" height="25"><img src="../img/le_bank_dot.gif" width="12" height="12" /></td>
                      <td><%=Replace(bkCols(0),"篮青","")%> <strong class="grey_h"><%=bkCols(1)%></strong></td>
                    </tr><% if ii < UBound(bkRows) - 1 then%>
                    <tr>
                      <td height="1" colspan="2" bgcolor="DFDFDF"></td>
                    </tr><% end if
                  Next %>
                    <tr>
                      <td height="25">&nbsp;</td>
                      <td><strong>抗陛林 : <%=bkCols(2)%></strong></td>
                    </tr>
                </table></td>
              </tr>
              <tr>
                <td><img src="../yes_img/33.gif" width="180" height="7" /></td>
              </tr>
            </table>
<% end if %></td>
  </tr>
  <tr>
    <td height="8"></td>
  </tr>
</table>