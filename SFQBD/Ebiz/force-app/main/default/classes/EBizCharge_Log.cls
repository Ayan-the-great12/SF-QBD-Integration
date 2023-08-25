public with sharing class EBizCharge_Log {

    public static void logMessage(string className, string funcName, string message, string logLevel)
    {
        string trace = 'Class: ' + className + ' Function: ' + funcName + ' Message: ' + message;
        if(logLevel == 'ERROR')
        {
            System.debug(LoggingLevel.ERROR, trace);
        }
        else if(logLevel == 'INFO')
        {
            System.debug(LoggingLevel.INFO, trace);
        }
        else if(logLevel == 'WARN')
        {
            System.debug(LoggingLevel.WARN, trace);
        }
    }

    public static void logMessage(string className, string funcName, string message)
    {
        string trace = 'Class: ' + className + ' Function: ' + funcName + ' Message: ' + message;
        System.debug(trace);
    }
}