({
    doInit: function(cmp, evt, helper) {
        
        var action = cmp.get("c.getWrapReportsList");
        
        action.setCallback(this, function(response) {
            
            console.log(response);
            
            if (response.getState() == "SUCCESS") {
                cmp.set("v.wrapReportsList", response.getReturnValue());
            } else if(response.getState() === "ERROR") {
                
            }
            
        });
        $A.enqueueAction(action); 
        
    },
    
    
    bulkSendPreview: function(cmp, evt, helper) {
        
        var reportId = '';
        var res;
        var wrapReportsList = cmp.get("v.wrapReportsList")
        var action = cmp.get("c.bulkSendPreviewAura");
        
        for (var i = 0; i < wrapReportsList.length; i++) {
            if (wrapReportsList[i].isSelected) {
                reportId = wrapReportsList[i].reportItem.Id;
            }
        }
        
        action.setParams({
            'reportId': reportId
        });
        
        action.setCallback(this, function(response) {
            
            res = response.getReturnValue();
            
            if (response.getState() == "SUCCESS") {
                cmp.set("v.isReportList", "false");
                cmp.set("v.csvFile", res.recipientsInfo.csvFile);
                cmp.set("v.recipientsList", res.recipientsInfo.recipientsList);
                
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    bulkSend: function(cmp, evt, helper) {
        
        var action = cmp.get("c.bulkSendAura");
        var wrapReportsList = cmp.get("v.wrapReportsList");
        var array = [];
        
        for (var i = 0; i < wrapReportsList.length; i++) {
            if (wrapReportsList[i].isSelected) {
                array.push(wrapReportsList[i].reportItem.Id);
            }
        }
        
        action.setParams({
            'bulkRecipientsCSV': cmp.get("v.csvFile")
        });
        
        if (array.length > 0) {
            action.setCallback(this, function(response) {
                
                if (response.getState() == "SUCCESS") {
                    
                    response = response.getReturnValue();
                    cmp.set("v.redirectURL", response.redirectUrl);
                    
                    if (response.status == 'success') {
                        
                        helper.showToast(cmp, evt, helper, "success", "Success", response.message);
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": response.redirectUrl
                        });
                        urlEvent.fire();
                        
                    } else if (response.status == 'error') {
                        helper.showToast(cmp, evt, helper, "error", "Error", response.error.message);
                    }
                    
                } else if(response.getState() === "ERROR") {
                    helper.showToast(cmp, evt, helper, "error", "ERROR", "Unexpected error.");
                }
                
            });
            $A.enqueueAction(action);
        } else {
            helper.showToast(cmp, evt, helper, "warning", "Warning", "Please select a report.");
        }
        
    }
})