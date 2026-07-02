$().ready(function(){
    let jsonData;

    /* ##############################################################################################
        교육생의 성적리스트 반환
    =============================================================================================== */
    function resultLoad(uid) {
        $("#resultArea tr").remove();
        if(!uid) uid="";
        $.ajax({
            url: "https://ci94t3nc1g.execute-api.ap-northeast-2.amazonaws.com/default/ian-loadresult",
            method:"GET",
            data:{
                "uid":uid
            },
            dataType: "text",/*json / text / html / xml / csv */
            success : function(data) {
                jsonList=JSON.parse(data);
                //console.log(JSON.stringify(jsonList));
                for(let row in jsonList) {
                    $tr = $("<tr></tr>");
                    let i=0;
                    let idx = 0;
                    for(var key in jsonList[row]) {
                        $td = $("<td></td>");
                        if(key=="fidx") {
                            idx = jsonList[row][key];
                            $chkbox = $("<input />");
                            $chkbox.prop("type","checkbox");
                            $chkbox.prop("name","idx");
                            $chkbox.val(idx) ;
                            $td.append($chkbox);
                        }
                        else {
                            str = jsonList[row][key];
                            if(key=="fdate") str = str.substr(0,10);
                            $td.text(str);
                        }
                        $tr.append($td);
                    }
                    $td = $("<td><a class=\"mp\" title=\"삭제\">Delete</a></td>");
                    $td.children("a").prop("idx",idx)
                    $tr.append($td);
                    $("#resultArea").append($tr);
                }
            },
            error:function(request,status,error){
                console.log(request);
                console.log("code:"+request.status);
                console.log("message:"+request.responseText);
                console.log("error:"+error);}
        });//e:$.ajax)
    }

    // 교육생의 성적 리스트 반환 함수 최초 자동 실행
    resultLoad();


    /* ##############################################################################################
        불러오기 버튼을 클릭하면 교육생 데이터를 반환받아 Select box에 표현
    =============================================================================================== */
    $("#btnReload").on("click",function() {
        $("option").remove();
        $("select").append("<option value=\"\">==== 교육생 선택 ====</option></select>")
        $.ajax({
            url: "https://qczcd1i9sa.execute-api.ap-northeast-2.amazonaws.com/default/ian-fun-ex1",
            method:"GET",
            dataType: "text",/*json / text / html / xml / csv */
            success : function(data) {
                jsonList=JSON.parse(data);
                //console.log(JSON.stringify(jsonList));
                for(var row in jsonList){
                    $option = $("<option></option>");
                    $option.val(jsonList[row]["fid"])
                    $option.text(jsonList[row]["fname"])
                    $("select").append($option);
                }
            },
            error:function(request,status,error){
                console.log(request);
                console.log("code:"+request.status);
                console.log("message:"+request.responseText);
                console.log("error:"+error);}
        });//e:$.ajax)
    });//e: $("#btnReload").on("click")
    $("#btnReload").click(); //위 불러오기 버튼을 클릭(이벤트 코드로 실행)
    $("#btnReload").prop("disabled",true);

    
    /* ##############################################################################################
        교육생 이름을 선택할 경우 성적 리스트에 선택한 교육생의 성적만 표현
    =============================================================================================== */
    $("select").on("change",function(ev) {
        resultLoad($(this).val());
    });//e:$("select").on("change")


    /* ##############################################################################################
        반드시 0~100사이의 숫자만 입력 할 수있게 제어
    =============================================================================================== */
    $(document).on("keyup","#kor, #eng, #mat", function(){
        if($(this).val()<0 || $(this).val()>100 ) {
            alert("점수는 0점 이상 100점 이하로만 입력해야 합니다.");
            $(this).val(0);
        }
    });

    
    /* ##############################################################################################
        성적 등록 버튼을 클릭한 경우
    =============================================================================================== */
    $(document).on("click","#btnLogin", function(){
        if($("#uid").val()=="") {
            alert("성적을 등록할 교육생을 선택하셔야 합니다.");
            $("#uid").focus();
            return;
        }
        if($("#kor").val()=="") {
            alert("국어 점수를 입력해주세요");
            $("#kor").focus();
            return;
        }
        if($("#eng").val()=="") {
            alert("영어 점수를 입력해주세요");
            $("#eng").focus();
            return;
        }
        if($("#mat").val()=="") {
            alert("수학 점수를 입력해주세요");
            $("#mat").focus();
            return;
        }
        $.ajax({
            url: "https://service-o1eyqtgf-1316543787.kr.apigw.tencentcs.com/release/ex-mysql-example1-3",
            data:$("#appendForm").serialize(),
            method:"GET",
            dataType: "text",/*json / text / html / xml / csv */
            success : function(data) {
                jsonData=JSON.parse(data);
                if(jsonData["msg"]=="success") resultLoad()
                else {
                    alert("성적을 등록중 에러가 발생하였습니다."+data);
                    location.reload();
                }
                //console.log(JSON.stringify(jsonList));
                //showReturnInfo(jsonList);
            },
            error:function(request,status,error){
                console.log(request);
                console.log("code:"+request.status);
                console.log("message:"+request.responseText);
                console.log("error:"+error);}
        });//e:$.ajax)
    });//e:$(document).on("click","#btnLogin")

    /* ##############################################################################################
        결과보기 버튼을 클릭한 경우
    =============================================================================================== */
    $(document).on("click","#btnLoding", function(){
        resultLoad();
    });


    /* ##############################################################################################
        목록 헤더의 체크박스를 통한 모두 선택 또는 모두 해제
    =============================================================================================== */
    $("#allChecked").on("change",function(ev) {
        $("input[name=idx]").prop("checked",this.checked);
    });//e:$("#allChecked").on("change")

    /* ##############################################################################################
        선택 삭제
    =============================================================================================== */
    $(document).on("click", ".mp", function(ev) {
        title = $(this).prop("title");
        idx = $(this).prop("idx");
        $parentTR =  $(this).parents("td").parents("tr");
        chkIdx = $(this).parents("td").parents("tr").children("td:first-child").children("input").val();
        chk = $(this).parents("td").parents("tr").children("td:first-child").children("input").prop("checked");
        if(!chk) {
            alert("선택한 목록이 없습니다. 목록의 체크박스에 체크릴 해야합니다.");
            return;
        }
        
        $("#idx").val(idx);
        $.ajax({
            url: "https://mcfda5jj22.execute-api.ap-northeast-2.amazonaws.com/default/ian-delete",
            data:$("#appendForm").serialize(),
            method:"GET",
            dataType: "text",/*json / text / html / xml / csv */
            data:{
                "idx":idx
            },
            success : function(data) {
                jsonData=JSON.parse(data);
                if(jsonData["msg"]=="success") {
                    $parentTR.remove();//resultLoad()
                }
                else {
                    alert("성적을 삭제중 에러가 발생하였습니다."+data);
                    //location.reload();
                }
            }
        });//e:$.ajax)
    });//e:


    /* ##############################################################################################
        수정을 위한 행  선택
    =============================================================================================== */
    $(document).on("click","#resultArea tr", function(ev) {
        idx = $(this).children("td:first-child").children("input").val();
        uid = $(this).children("td:nth-child(2)").text();
        kor = $(this).children("td:nth-child(5)").text();
        eng = $(this).children("td:nth-child(6)").text();
        mat = $(this).children("td:nth-child(7)").text();
        $("#idx").val(idx);
        $("#kor").val(kor);
        $("#eng").val(eng);
        $("#mat").val(mat);
        $options = $("#uid").children("option");
        for(key in $options) {
            if(!isNaN(key) && $($options[key]).val() == uid) $($options[key]).prop("selected",true);
            //for(key in obj)
        }
    });//e:


    /* ##############################################################################################
        수정
    =============================================================================================== */
    $(document).on("click","#btnChoEdit", function(){
        console.log($("#appendForm").serialize());
        $.ajax({
            url: "https://service-oosu6bj1-1316543787.kr.apigw.tencentcs.com/release/ex-mysql-example1-4",
            data:$("#appendForm").serialize(),
            method:"GET",
            dataType: "text",/*json / text / html / xml / csv */
            success : function(data) {
                jsonData=JSON.parse(data);
                if(jsonData["msg"]=="success") resultLoad()
                else {
                    alert("성적을 수정중 에러가 발생하였습니다."+data);
                    location.reload();
                }
                //console.log(JSON.stringify(jsonList));
                //showReturnInfo(jsonList);
            },
            error:function(request,status,error){
                //console.log(request);
                //console.log("code:"+request.status);
                //console.log("message:"+request.responseText);
                //console.log("error:"+error);
            }
        });//e:$.ajax)
    });//e:$(document).on("click","#btnLogin")

});//e:$().ready()