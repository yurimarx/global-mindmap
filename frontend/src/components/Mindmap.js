import React from "react";
import MindElixir from "mind-elixir";
import axios from 'axios';

class Mindmap extends React.Component {

    getIpAddress() {
        return window.location.hostname;
    }
    

    componentDidMount() {

        this.dynamicWidth = window.innerWidth;
        this.dynamicHeight = window.innerHeight;

        const ipaddress = this.getIpAddress();

        axios.get(`http://${ipaddress}:52773/global-mindmap/hasContent`)
            .then(res => {
                if (res.data == "1") {
                    axios.get(`http://${ipaddress}:52773/global-mindmap/get`)
                        .then(res2 => {
                            this.ME = new MindElixir({
                                el: "#map",
                                direction: MindElixir.LEFT,
                                data: this.renderExistentMindmap(res2.data),
                                draggable: true, // default true
                                contextMenu: true, // default true
                                toolBar: true, // default true
                                nodeMenu: true, // default true
                                keypress: true // default true
                            });
                            this.ME.bus.addListener('operation', operation => {
                                console.log(operation)
                    
                                if (operation.name == 'finishEdit' || operation.name == 'editStyle') {
                                    this.saveMindmapNode(operation.obj)
                                } else if (operation.name == 'removeNode') {
                                    this.deleteMindmapNode(operation.obj.id)
                                }
                            })
                            this.ME.init();
                        })
                    
                } else {
                    this.ME = new MindElixir({
                        el: "#map",
                        direction: MindElixir.LEFT,
                        data: MindElixir.new("New Mindmap"),
                        draggable: true, // default true
                        contextMenu: true, // default true
                        toolBar: true, // default true
                        nodeMenu: true, // default true
                        keypress: true // default true
                    });
                    this.ME.bus.addListener('operation', operation => {
                        console.log(operation)
            
                        if (operation.name == 'finishEdit' || operation.name == 'editStyle') {
                            this.saveMindmapNode(operation.obj)
                        } else if (operation.name == 'removeNode') {
                            this.deleteMindmapNode(operation.obj.id)
                        }
                    })
                    this.saveMindmapNode(this.ME.nodeData)
                    this.ME.init();
                }

                
            })


    }

    render() {
        return (
            <div id="map" style={{ height: window.innerHeight + 'px', width: '100%' }} />
        );
    }

    deleteMindmapNode(mindmapNodeId) {
        axios.delete(`http://${this.getIpAddress()}:52773/global-mindmap/delete/${mindmapNodeId}`)
            .then(res => {
                console.log(res);
                console.log(res.data);
            })
    }

    saveMindmapNode(node) {

        axios.post(`http://${this.getIpAddress()}:52773/global-mindmap/save`, {
            topic: (node.topic == undefined ? "" : node.topic),
            id: node.id,
            style: (node.style == undefined ? "" : node.style),
            parent: (node.parent == undefined ? "" : node.parent.id),
            tags: (node.tags == undefined ? [] : node.tags),
            icons: (node.icons == undefined ? [] : node.icons),
            hyperLink: (node.hyperLink == undefined ? "" : node.hyperLink)
        })
            .then(res => {
                console.log(res);
                console.log(res.data);
            })
    }

    renderExistentMindmap(data) {
        
        let root = data[0]

        let nodeData = {
            id: root.id,
            topic: root.topic,
            root: true,
            style: {
                background: root.style.background,
                color: root.style.color,
                fontSize: root.style.fontSize,
            },
            hyperLink: root.hyperLink,
            children: []
        }

        this.createTree(nodeData, data)

        return { nodeData }
    }

    createTree(nodeData, data) {
        for(let i = 1; i < data.length; i++) {
            if(data[i].parent == nodeData.id) {
                let newNode = {
                    id: data[i].id,
                    topic: data[i].topic,
                    root: false,
                    style: {
                        background: data[i].style.background,
                        color: data[i].style.color,
                        fontSize: data[i].style.fontSize,
                    },
                    hyperLink: data[i].hyperLink,
                    children: []
                }
                nodeData.children.push(newNode)
                this.createTree(newNode, data)
            }
        }
    }

    
}

export default Mindmap;
