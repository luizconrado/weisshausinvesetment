public class FlowUpdateInvesmtmentStatusToBE {
    @InvocableMethod(label='Update Investment Status to external service')
    public static void updatedProductDataToExternalSystem(List<Opportunity> investments){
        for(Opportunity opp:investments)
            OpportuntiyInvestmentService.sendInvestmentStatus(opp.id);
    }
}