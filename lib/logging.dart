import 'package:flutter_logs/flutter_logs.dart';

const _myLogFileName = 'MyLogFile';

Future setUpLogs() async {
    await FlutterLogs.initLogs(
        logLevelsEnabled: [
          LogLevel.INFO,
          LogLevel.WARNING,
          LogLevel.ERROR,
          LogLevel.SEVERE
        ],
        timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
        directoryStructure: DirectoryStructure.FOR_DATE,
        logTypesEnabled: [_myLogFileName],
        logFileExtension: LogFileExtension.LOG,
        logsWriteDirectoryName: "MyLogs",
        logsExportDirectoryName: "MyLogs/Exported",
        debugFileOperations: true,
        isDebuggable: true);
}

void logToFile(String logMessage) {
    FlutterLogs.logToFile(
        logFileName: _myLogFileName,
        overwrite: false,
        //If set 'true' logger will append instead of overwriting
        logMessage: logMessage,
        appendTimeStamp: true); //Add time stamp at the end of log message
}

printAllLogs() {
   FlutterLogs.printLogs(
        exportType: ExportType.ALL, decryptBeforeExporting: true);
}