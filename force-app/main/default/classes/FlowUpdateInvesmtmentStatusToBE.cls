/***************
* @group Flow Invocable Class
* @description used in flow Opportunity_Update_SMI_Send_Stage_Status
*/
public class FlowUpdateInvesmtmentStatusToBE {
    @InvocableMethod(label='Update Investment Status to external service')
    public static void updatedProductDataToExternalSystem(List<Opportunity> investments){
        for(Opportunity opp:investments)
            OpportuntiyInvestmentService.sendInvestmentStatus(opp.id);
    }
}