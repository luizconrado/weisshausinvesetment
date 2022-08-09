({
    onInit: function (component, event, helper) {
        helper.setupData(component);
        helper.fetchData(component,null,null);
        
    },
    onNext: function (component, event, helper) {
        let tableData=component.get('v.tableData');
        let currentIndex=null;
        if(tableData.length>0){
             currentIndex= tableData[0][0].logNumber;
           
        }
         helper.fetchData(component,currentIndex,'NEXT');
        
    },
    onBack: function (component, event, helper) {
        let tableData=component.get('v.tableData');
        let currentIndex=null;
        if(tableData.length>0){
             currentIndex= tableData[tableData.length-1][0].logNumber;    
            
        }
        helper.fetchData(component,currentIndex,'PREV');
    },
     
})