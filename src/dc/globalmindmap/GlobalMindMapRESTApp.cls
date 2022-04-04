Class dc.globalmindmap.GlobalMindMapRESTApp Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />

<!-- store mindmap node -->
<Route Url="/save" Method="POST" Call="StoreMindmapNode" />

<!-- delete a mindmap node -->
<Route Url="/delete/:id" Method="DELETE" Call="DeleteMindmapNode"/>

<!-- get mindmap content -->
<Route Url="/get" Method="GET" Call="GetMindmap"/>


<!-- has mindmap content - 1: yes - 0: no -->
<Route Url="/hasContent" Method="GET" Call="HasContent"/>

</Routes>
}

/// Store mindmap node
ClassMethod StoreMindmapNode() As %Status
{
  Try {
    
    Set data = {}.%FromJSON(%request.Content) 
    
    Set sc = ##class(dc.globalmindmap.GlobalMindMapService).StoreMindmapNode(data)
    
    Set %response.Status = 200
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    
    If sc = 1 {
      Write "Saved"
    } Else {
      Write "Not saved"
    }
    
    Return sc

  } Catch err {
    write !, "Error name: ", ?20, err.Name,
        !, "Error code: ", ?20, err.Code,
        !, "Error location: ", ?20, err.Location,
        !, "Additional data: ", ?20, err.Data, !
    Return $$$NOTOK
  }
}

/// Delete mindmap node
ClassMethod DeleteMindmapNode(id As %String) As %Status
{
      
  Set sc = ##class(dc.globalmindmap.GlobalMindMapService).DeleteMindmapNode(id)

  Set %response.Status = 200
  Set %response.Headers("Access-Control-Allow-Origin")="*"

  Write "Deleted"

  Return sc
}

/// Has content: 1 - yes, 0 - no
ClassMethod HasContent() As %Status
{
  
  Set %response.Status = 200
  Set %response.Headers("Access-Control-Allow-Origin")="*"

  Set sc = ##class(dc.globalmindmap.GlobalMindMapService).HasContent(.Result)

  Write Result

  Return sc
}

/// Get mindmap content
ClassMethod GetMindmap() As %Status
{

  Set sc = ##class(dc.globalmindmap.GlobalMindMapService).GetMindmap(.Nodes)  

  Set %response.Status = 200
  Set %response.Headers("Access-Control-Allow-Origin")="*"
  Write Nodes.%ToJSON()

  Return sc
}

/// General information
ClassMethod GetInfo() As %Status
{
  SET version = ..#Version
  SET fmt=##class(%SYS.NLS.Format).%New("ptbw")
  
  SET info = {
    "Service": "3DES Service API",
    "version": (version),
    "Developer": "Yuri Gomes",
    "Status": "Ok",
    "Date": ($ZDATETIME($HOROLOG))
  }
  Set %response.ContentType = ..#CONTENTTYPEJSON
  Set %response.Headers("Access-Control-Allow-Origin")="*"

  Write info.%ToJSON()
  Quit $$$OK
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/iris-tts" 
  Set swagger.info.title = "TTS Service API"
  Set swagger.info.version = "1.0"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

ClassMethod %ProcessResult(pStatus As %Status = {$$$OK}, pResult As %DynamicObject = "") As %Status [ Internal ]
{
  #dim %response As %CSP.Response
  SET tSC = $$$OK
  IF $$$ISERR(pStatus) {
    SET %response.Status = 500
    SET tSC = ..StatusToJSON(pStatus, .tJSON)
    IF $isobject(tJSON) {
      SET pResult = tJSON
    } ELSE {
      SET pResult = { "errors": [ { "error": "Unknown error parsing status code" } ] }
    }
  } 
  ELSEIF pStatus=1 {
    IF '$isobject(pResult){
      SET pResult = {
      }
    }
  }
  ELSE {
    SET %response.Status = pStatus
    SET error = $PIECE(pStatus, " ", 2, *)
    SET pResult = {
      "error": (error)
    }
  }
  
  IF pResult.%Extends("%Library.DynamicAbstractObject") {
    WRITE pResult.%ToJSON()
  }
  ELSEIF pResult.%Extends("%JSON.Adaptor") {
    DO pResult.%JSONExport()
  }
  ELSEIF pResult.%Extends("%Stream.Object") {
    DO pResult.OutputToDevice()
  }
  
  QUIT tSC
}

}
