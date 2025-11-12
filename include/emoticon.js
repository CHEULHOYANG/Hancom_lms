function AddData(str,idx)
{
	form = document.emoticon_form;

   	// 리턴, 더블쿼테이션, 싱글쿼테이션, 백슬래시 처리 sonsea
	var re, sq, dq, bs, qq;
	var r1, r2, r3;

	re = /cR_/g;
	sq = /sQ_/g;
	dq = /dQ_/g;
	bs = /bS_/g;

	r1 = str.replace(re, "\r\n");
	r1 = r1.replace(sq, "'");
	r1 = r1.replace(dq, "\"");
	r1 = r1.replace(bs, "\\");

	form.message.value = r1;
   	form.ContentIdx.value = idx;

    cal_byte(form.message.value);
}

function cal_byte(query)
{
       var tmpStr;
       var temp=0;
       var onechar;
       var tcount;
       tcount = 0;

       tmpStr = new String(query);
       temp = tmpStr.length;

       for (k=0;k<temp;k++)
       {
            onechar = tmpStr.charAt(k);

            if (escape(onechar).length > 4) {
                 tcount += 2;
            }
            else if (onechar!='\r') {
                 tcount++;
            }
            else if(onechar!='\n') {
                 tcount++;
            }
       }

       document.emoticon_form.cbyte.value = tcount;


}

function cutText()
{
       cut_string(document.emoticon_form.message.value, 80);
}

function cut_string(query,max)
{
       var tmpStr;
       var temp=0;
       var onechar;
       var tcount;
       tcount = 0;

       tmpStr = new String(query);
       temp = tmpStr.length;

       for(k=0;k<temp;k++)
       {
            onechar = tmpStr.charAt(k);

            if(escape(onechar).length > 4) {
                 tcount += 2;
            }
            else if(onechar!='\r') {
                 tcount++;
            }
            else if(onechar!='\n') {
                 tcount++;
            }
            if(tcount>max) {
                 tmpStr = tmpStr.substring(0,k);
                 break;
            }
       }

       if (max == 80) {
            document.emoticon_form.message.value = tmpStr;
            cal_byte(tmpStr);
       }

       return tmpStr;
}

function SendtToMessage1()
{
	   var form = document.emoticon_form;
       var onechar;
       var tcount = 0;
       var re, r1, r2;
       var trgPhone, message, temp, temp1, trgUrl, trgUrl1;

       var re = / /g;
       var murl;


       if(form.message.value=='') {
            alert("내용을 입력해주세요!");
            form.message.focus();
            return;
       }

    if (form.origctn2.value.length < 3)
    {
    	alert ('보내는 사람 폰번호를 입력해 주세요');
       form.origctn2.focus();
       return;
    }

    if (isNaN(form.origctn2.value))
    {
      	alert ('숫자로만 입력해야 합니다.!!');
       form.origctn2.value = '';
    	form.origctn2.focus();
       return;
    }

    if (form.origctn3.value.length < 3)
    {
    	alert ('보내는 사람 폰번호를 입력해 주세요');
       form.origctn3.focus();
       return;
    }

    if (isNaN(form.origctn3.value))
    {
      	alert ('숫자로만 입력해야 합니다.!!');
       form.origctn3.value = '';
    	form.origctn3.focus();
       return;
    }
       tcount = document.emoticon_form.cbyte.value;






        form.submit();
}
function SendtToMessage()
{
	   var form = document.emoticon_form;
       var onechar;
       var tcount = 0;
       var re, r1, r2;
       var trgPhone, message, temp, temp1, trgUrl, trgUrl1;

       var re = / /g;
       var murl;


       if(form.message.value=='') {
            alert("내용을 입력해주세요!");
            form.message.focus();
            return;
       }

       if (form.destctn2.value.length < 3)
    {
    	alert ('받는 사람 폰번호를 입력해 주세요');
       form.destctn2.focus();
       return;
    }

    if (isNaN(form.destctn2.value))
    {
      	alert ('숫자로만 입력해야 합니다.!!');
       form.destctn2.value = '';
    	form.destctn2.focus();
       return;
    }

    if (form.destctn3.value.length < 3)
    {
    	alert ('받는 사람 폰번호를 입력해 주세요');
       form.destctn3.focus();
       return;
    }

    if (isNaN(form.destctn3.value))
    {
      	alert ('숫자로만 입력해야 합니다.!!');
       form.destctn3.value = '';
    	form.destctn3.focus();
       return;
    }

    if (form.origctn2.value.length < 3)
    {
    	alert ('보내는 사람 폰번호를 입력해 주세요');
       form.origctn2.focus();
       return;
    }

    if (isNaN(form.origctn2.value))
    {
      	alert ('숫자로만 입력해야 합니다.!!');
       form.origctn2.value = '';
    	form.origctn2.focus();
       return;
    }

    if (form.origctn3.value.length < 3)
    {
    	alert ('보내는 사람 폰번호를 입력해 주세요');
       form.origctn3.focus();
       return;
    }

    if (isNaN(form.origctn3.value))
    {
      	alert ('숫자로만 입력해야 합니다.!!');
       form.origctn3.value = '';
    	form.origctn3.focus();
       return;
    }
       tcount = document.emoticon_form.cbyte.value;





        form.submit();
}

function cal_pre()
{
       var tmpStr, tcount;
       tmpStr = document.emoticon_form.message.value;

       cal_byte(tmpStr);

}

function clear2() {
	if (!document.emoticon_form.cbyte.value)
    {
		document.emoticon_form.message.value = "";
	}
}

function AddChar(char)
{
       document.emoticon_form.message.value += char;
       cal_byte(document.emoticon_form.message.value);
}

function Cancel()
{
	document.emoticon_form.reset();
	document.emoticon_form.message.value="";
}