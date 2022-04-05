Class UnitTests.GlobalMindMapServiceTest Extends %UnitTest.TestCase
{

Method TestStoreMindmapNode()
{
    Set data = {}
    Set data.id = "TestId"
    Set data.topic = "TestTopic"
    Set data.parent = ""
    Set data.tags = []
    Set data.icons = []
    Set data.style = {}
    Set data.style.background = "black"
    Set data.style.fontSize = "arial"
    Set data.style.color = "white"
    Set data.style.hyperLink = "intersystems.com"
    Do ##class(dc.globalmindmap.GlobalMindMapService).StoreMindmapNode(data)
    Set Key = ^mindmap(data.id)
    Do $$$AssertEquals(data.id, Key)
    Do ##class(dc.globalmindmap.GlobalMindMapService).DeleteMindmapNode(data.id)
}

Method TestDeleteMindmapNode() As %Status
{
    Set data = {}
    Set data.id = "TestDelete"
    Set data.topic = "TestDelete"
    Set data.parent = ""
    Set data.tags = []
    Set data.icons = []
    Set data.style = {}
    Set data.style.background = "black"
    Set data.style.fontSize = "arial"
    Set data.style.color = "white"
    Set data.style.hyperLink = "intersystems.com"
    Do ##class(dc.globalmindmap.GlobalMindMapService).StoreMindmapNode(data)
    Do ##class(dc.globalmindmap.GlobalMindMapService).DeleteMindmapNode(data.id)
    Set Key = $ORDER(^mindmap(data.id))
    Do $$$AssertEquals("", Key)
}

Method TestGetMindmap()
{
    Set data = {}
    Set data.id = "TestGet"
    Set data.topic = "TestGet"
    Set data.parent = ""
    Set data.tags = []
    Set data.icons = []
    Set data.style = {}
    Set data.style.background = "black"
    Set data.style.fontSize = "arial" 
    Set data.style.color = "white"
    Set data.style.hyperLink = "intersystems.com"
    Do ##class(dc.globalmindmap.GlobalMindMapService).StoreMindmapNode(data)
    Do ##class(dc.globalmindmap.GlobalMindMapService).GetMindmap(.Result)
    Set Count = Result.%Size()
    Do $$$AssertEquals(Count, 1)
    Do ##class(dc.globalmindmap.GlobalMindMapService).DeleteMindmapNode(data.id)
}

}
