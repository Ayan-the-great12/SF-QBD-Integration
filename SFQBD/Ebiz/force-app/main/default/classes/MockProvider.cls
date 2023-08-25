@isTest
public class MockProvider implements System.StubProvider {
    public static Object handleMethodCall(Object stubbedObject, String stubbedMethodName, Type returnType, List < Type > listOfParamTypes, List < String > listOfParamNames, List < Object > listOfArgs) {
        System.debug('Name of stubbed method: ' + stubbedMethodName);
        System.debug('Return type of stubbed method: ' + returnType.getName());
        for (integer i = 0; i < listOfParamNames.size(); i++) {
            System.debug('parameter name: ' + listOfParamNames.get(i));
            System.debug('  parameter type: ' + listOfArgs.get(i));
        }
        System.debug('number of parameters passed into the mocked call: ' + listOfArgs.size());
        System.debug('parameter(s) sent into the mocked call: ' + listOfArgs);
        System.debug('Class name: ' + stubbedObject);
        System.debug('Method name: ' + stubbedMethodName);
        System.debug('Return Type: ' + returnType.getName());
        if (stubbedMethodName == 'selectRecords' && returnType.getName() == 'list<sObject>' && listOfParamTypes.get(0).getName() == 'String' && listOfParamTypes.get(1).getName() == 'String' && listOfParamTypes.get(2).getName() == 'String' && listOfParamTypes.get(3).getName() == 'String' && listOfParamTypes.get(4).getName() == 'String' && listOfParamTypes.get(5).getName() == 'String') {
            System.debug('----------------------selectRecords-----Start');
            System.debug('----------------------selectRecords-----end');
            return StaticMockData.getObjectRecord((String) listOfArgs[1]);
        }
        if (stubbedMethodName == 'selectAggregateRecords' && returnType.getName() == 'list<AggregateResult>' && listOfParamTypes.get(0).getName() == 'String' && listOfParamTypes.get(1).getName() == 'String' && listOfParamTypes.get(2).getName() == 'String' && listOfParamTypes.get(3).getName() == 'String' && listOfParamTypes.get(4).getName() == 'String' && listOfParamTypes.get(5).getName() == 'String') {
            System.debug('----------------------selectRecords-----Start');
            // list<AggregateResult> agg = new list<AggregateResult>();
            DML dml = new DML();
            System.debug('----------------------selectRecords-----end');
            return dml.selectAggregateRecords((String) listOfArgs[0], (String) listOfArgs[1], (String) listOfArgs[2], (String) listOfArgs[3], (String) listOfArgs[4], (String) listOfArgs[5]);
        } else if (stubbedMethodName == 'selectSingleRecord' && returnType.getName() == 'sObject' && listOfParamTypes.get(0).getName() == 'String' && listOfParamTypes.get(1).getName() == 'String' && listOfParamTypes.get(2).getName() == 'String' && listOfParamTypes.get(3).getName() == 'String' && listOfParamTypes.get(4).getName() == 'String') {
            System.debug('----------------------selectSingleRecord-----Start');
            System.debug('----------------------selectSingleRecord-----end');
            return StaticMockData.getObjectRecord((String) listOfArgs[1])[0];
        }
        if (stubbedMethodName == 'selectRecordsInList' && returnType.getName() == 'list<sObject>' && listOfParamTypes.get(0).getName() == 'list<String>' && listOfParamTypes.get(1).getName() == 'String' && listOfParamTypes.get(2).getName() == 'String' && listOfParamTypes.get(3).getName() == 'String' && listOfParamTypes.get(4).getName() == 'String' && listOfParamTypes.get(5).getName() == 'String' && listOfParamTypes.get(6).getName() == 'String') {
            System.debug('----------------------selectRecordsInList-----Start');
            System.debug('----------------------selectRecordsInList-----end');
            return StaticMockData.getObjectRecord((String) listOfArgs[2]);
        } else if (stubbedMethodName == 'updateRecord' && returnType.getName() == 'sObject' && listOfParamTypes.get(0).getName() == 'sObject') {
            System.debug('----------------------updateRecord-----Start');
            System.debug('----------------------updateRecord-----end');
            return listOfArgs[0];
        } else if (stubbedMethodName == 'updateRecord' && returnType.getName() == 'list<sObject>' && listOfParamTypes.get(0).getName() == 'list<sObject>') {
            list < sObject > ls = new list < sObject > ();
            System.debug('----------------------updateRecord-----Start');
            System.debug('----------------------updateRecord-----end');
            return ls;
        } else if (stubbedMethodName == 'upsertRecord' && returnType.getName() == 'list<sObject>' && listOfParamTypes.get(0).getName() == 'list<sObject>') {
            list < sObject > ls = new list < sObject > ();
            System.debug('----------------------upsertRecord-----Start');
            System.debug('----------------------upsertRecord-----end');
            return ls;
        } else if (stubbedMethodName == 'upsertRecord' && returnType.getName() == 'sObject' && listOfParamTypes.get(0).getName() == 'sObject') {
            System.debug('----------------------upsertRecord-----Start');
            System.debug('----------------------upsertRecord-----end');
            return listOfArgs[0];
        }
        ///////
        else if (stubbedMethodName == 'upsertRecord' && returnType.getName() == 'list<sObject>' && listOfParamTypes.get(0).getName() == 'list<sObject>' && listOfParamTypes.get(1).getName() == 'String') {
            list < sObject > ls = new list < sObject > ();
            System.debug('----------------------upsertRecord-----Start');
            System.debug('----------------------upsertRecord-----end');
            return ls;
        } else if (stubbedMethodName == 'upsertRecord' && returnType.getName() == 'sObject' && listOfParamTypes.get(0).getName() == 'sObject' && listOfParamTypes.get(1).getName() == 'String') {
            System.debug('----------------------upsertRecord-----Start');
            System.debug('----------------------upsertRecord-----end');
            return listOfArgs[0];
        } else if (stubbedMethodName == 'insertRecord' && returnType.getName() == 'sObject' && listOfParamTypes.get(0).getName() == 'sObject') {
            System.debug('----------------------updateRecord-----Start');
            System.debug('----------------------updateRecord-----end');
            return listOfArgs[0];
        } else if (stubbedMethodName == 'insertRecord' && returnType.getName() == 'list<sObject>' && listOfParamTypes.get(0).getName() == 'list<sObject>') {
            list < sObject > ls = new list < sObject > ();
            System.debug('----------------------updateRecord-----Start');
            System.debug('----------------------updateRecord-----end');
            return ls;
        } else {
            return null;
        }
    }
}