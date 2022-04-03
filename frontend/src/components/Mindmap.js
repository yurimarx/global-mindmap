import React from "react";
import MindElixir, { E } from "mind-elixir";
import axios from 'axios';

class Mindmap extends React.Component {

    componentDidMount() {

        this.dynamicWidth = window.innerWidth;
        this.dynamicHeight = window.innerHeight;
        
        axios.get(`http://localhost:52773/global-mindmap/hasContent`)
            .then(res => {
                if (res.data == "1") {
                    this.ME = new MindElixir({
                        el: "#map",
                        direction: MindElixir.LEFT,
                        data: MindElixir.new("has data - I will bring"),
                        draggable: true, // default true
                        contextMenu: true, // default true
                        toolBar: true, // default true
                        nodeMenu: true, // default true
                        keypress: true // default true
                    });
                    this.ME.bus.addListener('operation', operation => {
                        console.log(operation)
            
                        if (operation.name == 'finishEdit') {
                            this.saveMindmapNode(operation.obj)
                        } else if (operation.name == 'removeNode') {
                            this.deleteMindmapNode(operation.obj.id)
                        }
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
                }

                this.ME.init();
            })


    }

    render() {
        return (
            <div id="map" style={{ height: window.innerHeight + 'px', width: '100%' }} />
        );
    }

    deleteMindmapNode(mindmapNodeId) {
        axios.delete(`http://localhost:52773/global-mindmap/delete/${mindmapNodeId}`)
            .then(res => {
                console.log(res);
                console.log(res.data);
            })
    }

    saveMindmapNode(node) {

        axios.post(`http://localhost:52773/global-mindmap/save`, {
            topic: (node.topic === undefined ? "" : node.topic),
            id: node.id,
            style: (node.style === undefined ? "" : node.style),
            parent: (node.parent === undefined ? "" : node.parent.id),
            tags: (node.tags === undefined ? [] : node.tags),
            icons: (node.icons === undefined ? [] : node.icons),
            hyperLink: (node.hyperLink === undefined ? "" : node.hyperLink)
        })
            .then(res => {
                console.log(res);
                console.log(res.data);
            })
    }
}

export default Mindmap;
