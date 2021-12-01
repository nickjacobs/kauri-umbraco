TreeMultiPickerUI = function (containerID, tblNodesID, rowPrefix, txbPickedNodesID, treeType) {
        /// <summary>
        /// Constructor method, must be called before the rest of the class can be used
        /// </summary>

        //private members
        this._containerID = containerID;
        this._tblNodesID = tblNodesID;
        this._rowPrefix = rowPrefix;
        this._txbPickedNodesID = txbPickedNodesID;
        this._treeType = treeType;
},
/// <summary>
/// Class to perform javascript actions for TreeMultiPickerUI
/// </summary>

TreeMultiPickerUI.prototype = {
    Init: function() {
        jQuery("#" + this._tblNodesID).tableDnD({
            onDrop: Function.createDelegate(this, this.SortDrop),
            dragHandle: "tmpDragHandle",
            onDragClass: "tmpWhileDrag",
            onDragStart: Function.createDelegate(this, this.ResetSelection)
        });

        jQuery("#" + this._tblNodesID).click(Function.createDelegate(this, this.SelectRow));

    },

    // Called by a click on a node
    TreeNodeClick: function(nodeID) {
        var txbPickedNodes = document.getElementById(this._txbPickedNodesID);

        if (txbPickedNodes.value.indexOf(nodeID + ",")<0) {
            // Add the node checked to the textbox 
            txbPickedNodes.value = txbPickedNodes.value + nodeID + ",";

            // Add an empty row to the table
            var newRow = "<tr id=\"" + this._rowPrefix + nodeID + "\"><td class=\"tmpDragHandle\">&nbsp;</td><td class=\"tmpNode\"></td></tr>";
            jQuery("#" + this._tblNodesID).append(newRow);

            // Loads the selected node in the new row
            jQuery("#" + this._tblNodesID + " tr:last td.tmpNode").load("treeMultiPickerNode.aspx?rnd=" + Math.random() + "&treeType=" + this._treeType + "&id=" + nodeID);
        }

        // Update selection
        jQuery("#" + this._tblNodesID + " .tmpSelected").removeClass("tmpSelected")
        jQuery("#" + this._tblNodesID + " #" + this._rowPrefix + nodeID + " td.tmpNode").addClass("tmpSelected");

        // Update Drag and Drop
        jQuery("#" + this._tblNodesID).tableDnDUpdate();
    },
    
    // Called after a drag&drop sort of Picked Nodes table to reset an eventually selected node
    ResetSelection: function(table, row) {
        jQuery("#" + this._tblNodesID + " .tmpSelected").removeClass("tmpSelected")
    },

    // Called after a drag&drop sort of Picked Nodes tabel
    SortDrop: function(table, row) {
        var txbPickedNodes = document.getElementById(this._txbPickedNodesID);

        var neworder = "";
        var rows = table.tBodies[0].rows;

        // skip first row (table header)
        for (var i=1; i<rows.length; i++) {
            neworder += rows[i].id.replace(this._rowPrefix,"")+",";
        }

        // Update the textbox with the new order
        txbPickedNodes.value = neworder;
    },

    // Called by a click on Delete button
    DeleteRow: function () {
        var txbPickedNodes = document.getElementById(this._txbPickedNodesID);
        
        // Retrieve the ID of the selected row
        var selectedRowID = jQuery("#" + this._tblNodesID + " .tmpSelected").parent("tr").attr("id");
            
        if (selectedRowID !== undefined) {
            var selectedNode = selectedRowID.replace(this._rowPrefix, "");
            // Delete the selected row from the table
            jQuery("#" + selectedRowID).remove();
            // Remove the selection
            jQuery("#" + this._tblNodesID + " .tmpSelected").removeClass("tmpSelected")
            // Delete the node unchecked from the textboxes
            txbPickedNodes.value = txbPickedNodes.value.replace(selectedNode + ",","");

            // Update Drag & Drop
            jQuery("#" + this._tblNodesID).tableDnDUpdate();
        }
    },

    // Called by a click on Delete button
    SyncTree: function () {
        // Retrieve the path of the selected node which is stored in an invisible SPAN
        var nodePath = jQuery("#" + this._tblNodesID + " .tmpSelected .tmpPath").text();

        if (nodePath !== undefined) {
            // Call SyncTree on the inner IFRAME
            window.frames[this._containerID + "_treeframe"].SyncTree(nodePath.split(","));
        }
    },

    // Called by a click on a Picked Node table cell
    SelectRow: function (event) {
        jQuery("#" + this._tblNodesID + " .tmpSelected").removeClass("tmpSelected")

        // This doesn't seem to work in Chrome when clicking on images in the media picker.
        // jQuery(event.target).closest("td.tmpNode").addClass("tmpSelected");
        if (jQuery(event.target).is("td.tmpNode")) {
            jQuery(event.target).addClass("tmpSelected");
        }
        else {
            jQuery(event.target).parents("td.tmpNode").addClass("tmpSelected");
        }
    }
}
