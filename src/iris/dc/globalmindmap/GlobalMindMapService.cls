Class dc.globalmindmap.GlobalMindMapService
{

/// Store mindmap node 
ClassMethod StoreMindmapNode(data As %DynamicObject) As %Status
{
    Try {

        Set ^mindmap(data.id) = data.id
        Set ^mindmap(data.id, "topic") = data.topic
        Set ^mindmap(data.id, "style", "fontSize") = data.style.fontSize
        Set ^mindmap(data.id, "style", "color") = data.style.color
        Set ^mindmap(data.id, "style", "background") = data.style.background
        Set ^mindmap(data.id, "parent") = data.parent
        Set ^mindmap(data.id, "tags") = data.tags.%ToJSON()
        Set ^mindmap(data.id, "icons") = data.icons.%ToJSON()
        Set ^mindmap(data.id, "hyperLink") = data.hyperLink

        Return 1

    } Catch err {
        write !, "Error name: ", ?20, err.Name,
            !, "Error code: ", ?20, err.Code,
            !, "Error location: ", ?20, err.Location,
            !, "Additional data: ", ?20, err.Data, !
        Return 0
    }
}

ClassMethod GetMindmap(Output Nodes As %DynamicArray) As %Status
{
    Try {
      
      Set Nodes = []

      Set Key = $ORDER(^mindmap(""))
      Set Row = 0
      
      While (Key '= "") {
        Do Nodes.%Push({})
        Set Nodes.%Get(Row).style = {}
        Set Nodes.%Get(Row).id = Key
        Set Nodes.%Get(Row).hyperLink = ^mindmap(Key,"hyperLink")
        Set Nodes.%Get(Row).icons = ^mindmap(Key,"icons")
        Set Nodes.%Get(Row).parent = ^mindmap(Key,"parent")
        Set Nodes.%Get(Row).style.background = ^mindmap(Key,"style", "background")
        Set Nodes.%Get(Row).style.color = ^mindmap(Key,"style", "color")
        Set Nodes.%Get(Row).style.fontSize = ^mindmap(Key,"style", "fontSize")
        Set Nodes.%Get(Row).tags = ^mindmap(Key,"tags")
        Set Nodes.%Get(Row).topic = ^mindmap(Key,"topic") 
        Set Row = Row + 1
        
        Set Key = $ORDER(^mindmap(Key))
      }
      
      Return 1
    
    } Catch err {
      Write !, "Error name: ", ?20, err.Name,
          !, "Error code: ", ?20, err.Code,
          !, "Error location: ", ?20, err.Location,
          !, "Additional data: ", ?20, err.Data, !
      Return 0
    }
}

/// Delete mindmap node
ClassMethod DeleteMindmapNode(id As %String) As %Status
{
    Try {
      
      Kill ^mindmap(id)
      
      Return 1

    } Catch err {
      write !, "Error name: ", ?20, err.Name,
          !, "Error code: ", ?20, err.Code,
          !, "Error location: ", ?20, err.Location,
          !, "Additional data: ", ?20, err.Data, !
      Return 0
  }
}

/// Has content: 1 - yes, 0 - no
ClassMethod HasContent(Output Result As %String) As %Status
{
    Try {
      
        Set key = $ORDER(^mindmap(""))
      
        If key = "" {
            Set Result = "0"
        } Else {
            Set Result = "1"
        }

      Return 1
    
    } Catch err {
      Write !, "Error name: ", ?20, err.Name,
          !, "Error code: ", ?20, err.Code,
          !, "Error location: ", ?20, err.Location,
          !, "Additional data: ", ?20, err.Data, !
      Return 0
    }
}

}
