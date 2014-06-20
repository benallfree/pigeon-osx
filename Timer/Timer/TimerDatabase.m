//
//  TimerDatabase.m
//  Timer
//
//  Created by jenkins on 6/20/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "TimerDatabase.h"
#import "Utilities.h"

#define DB_VER @"1.0"

@implementation TimerDatabase

static TimerDatabase *m_sharedInstance = nil;


/**
 *  initializes egnyte database object.
 *
 *  @return TimerDatabase object
 */


-(id) init
{
	self = [super init];
	
	if (self)
	{
		m_dbHandle = NULL;
	}
	
	return self;
}

/**
 *  returns a shared object.
 *
 *  @return TimerDatabase object
 */

+(TimerDatabase *) sharedInstance
{
    //if already allocated
    
	if (m_sharedInstance)
	{
		return m_sharedInstance;
	}
	
    //otherwise create a new one.
	m_sharedInstance = [[TimerDatabase alloc] init];
	[m_sharedInstance openTimerDatabase:[Utilities TimerDbFilePath]];
	return m_sharedInstance;
    
}



- (BOOL) insertTimerDBVersion
{
    NSString *insertSql = [[NSString alloc] initWithFormat:@"insert or replace into TimerDBVersion values(%@);",
                           DB_VER];
    sqlite3_stmt *statement;
    @synchronized(self)
    {
        // NSLog(@"%@", insertSql);
		int ret = SQLITE_OK;
		if ((ret = sqlite3_prepare_v2(m_dbHandle, [insertSql cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL)) == SQLITE_OK)
		{
            sqlite3_step(statement);
			sqlite3_finalize(statement);
            return YES;
            
        }
    }
    
    return NO;
}

/**
 *  creates a new database
 *
 *  @param NSString *dbPath: path to the database file.
 *
 *  @return YES for success otherwise NO
 */

-(BOOL) createEgnyteDB:(NSString *)dbPath
{
    
    int res = 0;
    
    //creates a new DB file,
    if(sqlite3_open([dbPath UTF8String], &m_dbHandle) == SQLITE_OK)
    {
        
        sqlite3_exec(m_dbHandle, "BEGIN TRANSACTION;", NULL, NULL, NULL);
        
        //create File Table
        if ((res = sqlite3_exec(m_dbHandle, "CREATE TABLE Clients (Client TEXT PRIMARY KEY);",
                                NULL, NULL, NULL )) != SQLITE_OK)
        {
            return NO;
        }
        
        //Create EgnyteUploadQueue Table.
        if ((res = sqlite3_exec(m_dbHandle, "CREATE TABLE LOGS (Client TEXT, COUNT NUMERIC, MEMO TEXT);",
                                NULL, NULL, NULL)) != SQLITE_OK)
        {
            return NO;
        }
        
        //Create version table.
        if ((res = sqlite3_exec(m_dbHandle, "CREATE TABLE TimerDBVersion (DBVersion TEXT);",
                                NULL, NULL, NULL)) != SQLITE_OK)
        {
            return NO;
        }

        
               //commit changes
        sqlite3_exec(m_dbHandle, "COMMIT;", NULL, NULL, NULL);
        
        //insert current db version, and return;
        [self insertTimerDBVersion];
    }
    return NO;
}

/**
 *  opens an existing database file. If not existed, it will attempt to create.
 *
 *  @param NSString *dbPath: path to the database file.
 *
 *  @return YES for success otherwise NO.
 */

-(BOOL) openTimerDatabase:(NSString *)dbPath
{
    
    
	if(sqlite3_open([dbPath UTF8String], &m_dbHandle) == SQLITE_OK)
    {
        NSLog(@"Database Opened Successfully");
        NSString *dbVersion = [self TimerDbVersion];
        
        if (!dbVersion || ![dbVersion isEqualToString:DB_VER])
        {
            sqlite3_close(m_dbHandle);
            remove([dbPath UTF8String]);
            NSLog(@"recreating database for dbversion expected = %@ - failed = %@", DB_VER, dbVersion);
            [self createEgnyteDB:dbPath];
        }
	}
    else
    {
        return [self createEgnyteDB:dbPath];
    }
	
	return YES;
}


- (NSString *) TimerDbVersion
{
    NSString *update = [NSString stringWithFormat:@"select * from TimerDBVersion"];
    sqlite3_stmt *statement;
    
    @synchronized(self)
    {
		if (sqlite3_prepare_v2(m_dbHandle, [update cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
		{
			
            NSString *mVersion = nil;
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char *version      = (const char *)sqlite3_column_text(statement, 0);
                mVersion = [NSString stringWithUTF8String:version];
                
                
            }
			sqlite3_finalize(statement);
            return mVersion;
		}
    }
    return nil;
    

}
-(BOOL) insertClient:(NSString *)Client;
{
    NSString *insertSql = [[NSString alloc] initWithFormat:@"insert or replace into Clients values(?);"];
    sqlite3_stmt *statement;
    @synchronized(self)
    {
        // NSLog(@"%@", insertSql);
		int ret = SQLITE_OK;
		if ((ret = sqlite3_prepare_v2(m_dbHandle, [insertSql cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL)) == SQLITE_OK)
		{
            if ([self bindVariable:1 textValue:Client int64Value:0 context:statement useText:YES  useFSR:YES] != SQLITE_OK)
            {
                //throw an error - will do later not enough time for now
                sqlite3_finalize(statement);
                return NO;
            }
            sqlite3_step(statement);
			sqlite3_finalize(statement);
            return YES;
            
        }
        
        
    }
    
    return NO;
}


/**
 *  binds a variable with sql query
 *
 *  @param int index: index of the variable in query
 *  @param NSString *text: text value to be used for binding.
 *  @param long long int64Valu: the long long value to be used into binding
 *  @param sqlite3_stmt *context: sqlite statement object for performing the bind operation.
 *  @param BOOL useText: indicates if binding should be done using text value(2nd paramter) or int64Value(3rd parameter)
 *  @param BOOL fsFlag: this indicates if text needs to be converted to filesystem representation
 *
 *  @return file object or nil
 */

-(int) bindVariable:(int)index textValue:(NSString *)text int64Value:(long long)intValue context: (sqlite3_stmt *)statement useText:(BOOL)flag useFSR:(BOOL)fsFlag

{
    
    int result = 0;
    if (flag)
        
    {
        
        const char *_text = 0;
        if (fsFlag && [text length] > 0)
            
        {
            
            _text = [text cStringUsingEncoding:NSUTF8StringEncoding];//[[NSFileManager defaultManager] fileSystemRepresentationWithPath:text];
            
        }
        
        else {
            
            _text = [text UTF8String];
            
        }
        
        result =   sqlite3_bind_text (
                                      
                                      statement,
                                      
                                      index,
                                      
                                      _text,
                                      
                                      strlen([text UTF8String]),
                                      
                                      SQLITE_STATIC
                                      
                                      );
        
        return result;
        
    }
    else {
        result =   sqlite3_bind_int64 (
                                       
                                       statement,
                                       
                                       index,
                                       
                                       intValue
                                       
                                       );
        
    }
    return result;
    
}


-(BOOL) insertLog:(NSString *)logs forClient:(NSString *)client
{
    NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into LOGS(Client, Count, Memo) values(?, 1, ?);"];
    sqlite3_stmt *statement;
    @synchronized(self)
    {
        // NSLog(@"%@", insertSql);
		int ret = SQLITE_OK;
		if ((ret = sqlite3_prepare_v2(m_dbHandle, [insertSql cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL)) == SQLITE_OK)
		{
            if ([self bindVariable:1 textValue:client int64Value:0 context:statement useText:YES  useFSR:YES] != SQLITE_OK)
            {
                //throw an error - will do later not enough time for now
                sqlite3_finalize(statement);
                return NO;
            }
            
            if ([self bindVariable:2 textValue:logs int64Value:0 context:statement useText:YES  useFSR:YES] != SQLITE_OK)
            {
                //throw an error - will do later not enough time for now
                sqlite3_finalize(statement);
                return NO;
            }

            sqlite3_step(statement);
			sqlite3_finalize(statement);
            return YES;
            
        }
        
        
    }

    return YES;
}

-(NSArray *) getClients
{
    NSString *select = [NSString stringWithFormat:@"select * from Clients;"];
    sqlite3_stmt *statement;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    @synchronized(self)
    {
		if (sqlite3_prepare_v2(m_dbHandle, [select cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
		{
			
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char *client_name = (const char *)sqlite3_column_text(statement, 0);
                
                if (client_name)
                {
                    [arr addObject:[NSString stringWithCString:client_name encoding:NSUTF8StringEncoding]];
                }
                
            }
            sqlite3_finalize(statement);
            return arr;
		}
    }
    return arr;

}

-(NSArray *) getLogsForClient:(NSString *)client
{
    NSString *select = [NSString stringWithFormat:@"select distinct Memo from Logs where Client = ?;"];
    sqlite3_stmt *statement;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    @synchronized(self)
    {
		if (sqlite3_prepare_v2(m_dbHandle, [select cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
		{
            if ([self bindVariable:1 textValue:client int64Value:0 context:statement useText:YES  useFSR:YES] != SQLITE_OK)
            {
                //throw an error - will do later not enough time for now
                sqlite3_finalize(statement);
                return NO;
            }
            
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char *memo = (const char *)sqlite3_column_text(statement, 0);
                
                if (memo)
                {
                    [arr addObject:[NSString stringWithCString:memo encoding:NSUTF8StringEncoding]];
                }
                
            }
    		sqlite3_finalize(statement);
            return arr;
		}
    }
    return arr;

}

-(void) removeLogs
{
    NSString *delete = [NSString stringWithFormat:@"delete from logs;"];
    sqlite3_stmt *statement;
    @synchronized(self)
    {
		if (sqlite3_prepare_v2(m_dbHandle, [delete cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
		{
            
            sqlite3_step(statement);
    		sqlite3_finalize(statement);
 		}
    }
 
}

-(NSString *) getLogsAsCSV
{
    NSString *select = [NSString stringWithFormat:@"select client,sum(count),memo from logs group by client,memo order by client;"];
    sqlite3_stmt *statement;
    NSString *arr = @"";
    @synchronized(self)
    {
		if (sqlite3_prepare_v2(m_dbHandle, [select cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
		{
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char *client = (const char *)sqlite3_column_text(statement, 0);
                const char *log = (const char *)sqlite3_column_text(statement, 2);
                int sum = sqlite3_column_int(statement, 1);
                
                if (log && client)
                {
                    arr = [arr stringByAppendingString:[NSString stringWithFormat:@"%s,%d,%s\n", client,sum,log]];
                }
                
            }
    		sqlite3_finalize(statement);
            return arr;
		}
    }
    return arr;

}



@end
