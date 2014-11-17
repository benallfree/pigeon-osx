// file Log.m
#import "Logging.h"
#import "Utilities.h"

int debug = 0;
//@implementation Log
void _Log(NSString *prefix, const char *file, int lineNumber, const char *funcName, NSString *format,...) {
    
    
    va_list ap;
    va_start (ap, format);
    format = [format stringByAppendingString:@"\n"];
    NSString *msg = [[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@",format] arguments:ap];   
    va_end (ap);
    NSDate *currentTime = [NSDate date];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    NSString *fullMsg =  [[NSString alloc] initWithFormat:@"[%@]: %@", resultString, msg];
    
    if (debug)
        fprintf(stderr,"%s%50s:%3d - %s",[prefix UTF8String], funcName, lineNumber, [fullMsg UTF8String]);
    appendToFile(fullMsg);
  }

void appendToFile(NSString *msg){
    // get path to Documents/somefile.txt
    NSString *path = [[[Utilities TimerDbFilePath] stringByDeletingLastPathComponent] stringByAppendingFormat:@"/Timer.log"];
    
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    
    if (dict)
    {
        long long size = [[dict objectForKey:NSFileSize] longLongValue];
        
        //if file was 5 mb, delete it.
        if (size >= 5 * 1024 * 1024)
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
    // create if needed
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSData data] writeToFile:path atomically:YES];
    } 
    // append
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
}
//@end