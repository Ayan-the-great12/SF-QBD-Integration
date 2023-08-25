public with sharing class TransactionsShedulable implements Schedulable {
    public void execute(SchedulableContext ctx) {
        System.debug('Transactions job running');
        fetchTransactions();
    }
    @future(callout = true)
    public static void fetchTransactions() {
        System.debug('future method called');
        List < eBc_SyncDownloadController.TransactionsWrapper > TransList = new List < eBc_SyncDownloadController.TransactionsWrapper > ();
        if (!test.isRunningTest()) {
            TransList = eBc_SyncDownloadController.getPaymentsApxc('0', '1000');
        }
        System.debug('transactions returned are');
        System.debug(TransList);
    }
}