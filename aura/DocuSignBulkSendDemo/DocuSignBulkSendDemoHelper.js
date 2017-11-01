({
    showToast : function(cmp, evt, helper, type, title, message) {
        debugger;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":    type,
            "title":   title,
            "message": message,
            "mode":    "sticky "
        });
        toastEvent.fire();
    }
})