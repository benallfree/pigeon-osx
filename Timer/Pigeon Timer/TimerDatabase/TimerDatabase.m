//
//  TimerDatabase.m
//  Timer
//
//  Created by jenkins on 6/20/14.
//  Copyright (c) 2014 GreatBasinGroup. All rights reserved.
//

#import "TimerDatabase.h"
#import "Utilities.h"

#define DB_VER @"2.4"

@implementation TimerDatabase

static TimerDatabase *m_sharedInstance = nil;


/**
 *  initializes timer database object.
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

/**
 *  insert db schema version
 *
 *  @return YES for success otherwise NO.
 */

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

-(BOOL) createTimerDB:(NSString *)dbPath
{
    
    int res = 0;
    
    //creates a new DB file,
    if(sqlite3_open([dbPath UTF8String], &m_dbHandle) == SQLITE_OK)
    {
        
        sqlite3_exec(m_dbHandle, "BEGIN TRANSACTION;", NULL, NULL, NULL);
        
        //create File Table
        if ((res = sqlite3_exec(m_dbHandle, "CREATE TABLE clients ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);",
                                NULL, NULL, NULL )) != SQLITE_OK)
        {
            return NO;
        }
        
        if ((res = sqlite3_exec(m_dbHandle, "CREATE TABLE logs (id INTEGER PRIMARY KEY AUTOINCREMENT, client_id INTEGER, memo TEXT, created_at INTEGER, exported_at INTEGER);",
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
            [self createTimerDB:dbPath];
        }
	}
    else
    {
        return [self createTimerDB:dbPath];
    }
	
	return YES;
}
/**
 *  get the db version value from database
 *
 *  @return DB version saved in database.
 */

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
/**
 *  inserts a client into database
 *
 *  @param Client Client name
 *
 *  @return YES if done successfuly otherwise NO
 */
-(BOOL) insertClient:(NSString *)Client;
{
    NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into clients(name) values(?);"];
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
                                      
                                      (int)strlen([text UTF8String]),
                                      
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

/**
 *  retrieve a clients id
 *
 *  @param name client name
 *
 *  @return client id if found otherwise 0
 */
-(long long) getClientID:(NSString *)name
{
    NSString *select = [NSString stringWithFormat:@"select id from clients where name = ?;"];
    sqlite3_stmt *statement;
    long long retVal = 0;
    
    @synchronized(self)
    {
		if (sqlite3_prepare_v2(m_dbHandle, [select cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
		{
            if ([self bindVariable:1 textValue:name int64Value:0 context:statement useText:YES  useFSR:YES] != SQLITE_OK)
            {
                //throw an error - will do later not enough time for now
                sqlite3_finalize(statement);
                return 0;
            }

            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                retVal = sqlite3_column_int64(statement, 0);
                
            }
            sqlite3_finalize(statement);
		}
    }
    return retVal;

}

/**
 *  inserts a log into database
 *
 *  @param logs   log string
 *  @param client client name
 *
 *  @return <#return value description#>
 */
-(BOOL) insertLog:(NSString *)logs forClient:(long long)client
{
    NSString *insertSql = [[NSString alloc] initWithFormat:@"insert into logs(client_id, memo, created_at) values(%lld, ?, %ld);", client, time(0)];
    sqlite3_stmt *statement;
    @synchronized(self)
    {
        // NSLog(@"%@", insertSql);
		int ret = SQLITE_OK;
		if ((ret = sqlite3_prepare_v2(m_dbHandle, [insertSql cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL)) == SQLITE_OK)
		{
            
            if ([self bindVariable:1 textValue:logs int64Value:0 context:statement useText:YES  useFSR:YES] != SQLITE_OK)
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

/**
 *  get list of clients from database
 *
 *  @return NSArray containing client names
 */
-(NSArray *) getClients
{
    NSString *select = [NSString stringWithFormat:@"select name from clients c order by (select max(created_at) from logs where client_id = c.id)  desc;"];
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

/**
 *  get recent log for a client
 *
 *  @param client client id
 *
 *  @return recent log
 */
-(NSArray *) getRecentLogsForClient:(long long)client
{
    NSString *select = [NSString stringWithFormat:@"select l.memo from logs l join (select id,max(created_at) from logs where client_id = %lld and exported_at is not null group by memo) n on l.id=n.id order by l.created_at desc limit 10;", client];
    sqlite3_stmt *statement;
    NSMutableDictionary *arr = nil;;
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    @synchronized(self)
    {
		if (sqlite3_prepare_v2(m_dbHandle, [select cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
		{
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char *memo = (const char *)sqlite3_column_text(statement, 0);
                
                if (memo)
                {
                    arr = [[NSMutableDictionary alloc] init];
                    NSString *originalStr = [NSString stringWithCString:memo encoding:NSUTF8StringEncoding];
                     NSString *key = [originalStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                    [arr setObject:key forKey:@"logs"];
                    [arr setObject:originalStr forKey:@"originalLogs"];
                    [retVal addObject:arr];
                }
                
            }
    		sqlite3_finalize(statement);
  		}
    }
    
    return retVal;
    
    

}


/**
 *  gets logs for a given client name
 *
 *  @param client client name
 *
 *  @return Array containing the logs
 */
-(NSArray *) getLogsForClient:(long long)client
{
    NSString *select = [NSString stringWithFormat:@"select l.memo from logs l join (select id,max(created_at) from logs where client_id = %lld and exported_at is null group by memo) n on l.id=n.id order by l.created_at desc;", client];
    sqlite3_stmt *statement;
    NSMutableDictionary *arr = nil;;
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    @synchronized(self)
    {
		if (sqlite3_prepare_v2(m_dbHandle, [select cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
		{
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char *memo = (const char *)sqlite3_column_text(statement, 0);
                
                if (memo)
                {
                    arr = [[NSMutableDictionary alloc] init];
                    NSString *originalStr = [NSString stringWithCString:memo encoding:NSUTF8StringEncoding];
                    NSString *key = [originalStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                    [arr setObject:key forKey:@"logs"];
                    [arr setObject:originalStr forKey:@"originalLogs"];
                    [retVal addObject:arr];
                    //[arr addObject:[NSString stringWithCString:memo encoding:NSUTF8StringEncoding]];
                }
                
            }
    		sqlite3_finalize(statement);
  		}
    }
    
     return retVal;

}

-(void) removeLogsForclients:(NSArray *)clients
{
    //update logs set exported_at=1233 where client_id in (select id from clients where name in ('Munir', 'Jamshaid Ahmed'))

    NSString *selectByClients = @"";
    BOOL first = YES;
    if (clients && [clients count])
    {
        selectByClients = @" and client_id in (select id from clients where name in (";
        for (NSString *client in clients)
        {
            selectByClients = [selectByClients stringByAppendingString:[NSString stringWithFormat:@"%@ '%@'", (first) ? @"": @",", client]];
            first = NO;
        }
        selectByClients = [selectByClients stringByAppendingString:@"))"];
    }

    NSString *delete = [NSString stringWithFormat:@"update logs set exported_at = %ld where exported_at is NULL%@;", time(0), selectByClients];
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
/**
 *  removes logs from database
 */
-(void) removeLogs
{
    NSString *delete = [NSString stringWithFormat:@"update logs set exported_at = %ld where exported_at is NULL;", time(0)];
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

/**
 *  converts logs in database to a CSV string
 *
 *  @return CSV string
 */
-(NSArray *) getLogsAsCSV:(NSArray *)clients
{
    NSString *selectByClients = @"";
    BOOL first = YES;
    if (clients && [clients count])
    {
        selectByClients = @"and c.name in (";
        for (NSString *client in clients)
        {
            selectByClients = [selectByClients stringByAppendingString:[NSString stringWithFormat:@"%@ '%@'", (first) ? @"": @",", client]];
            first = NO;
        }
        selectByClients = [selectByClients stringByAppendingString:@")"];
    }
    NSString *select = [NSString stringWithFormat:@"select c.name, count(l.client_id) as count, memo from \
                        clients c join logs l on c.id = l.client_id \
                        where l.exported_at is null %@\
                        group by  l.memo \
                        order by c.name, l.created_at;", selectByClients];
    sqlite3_stmt *statement;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
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
                    NSArray *line = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%s", client],
                                     [NSString stringWithFormat:@"%d", sum],
                                     [NSString stringWithFormat:@"%s", log], nil];
                    [arr addObject:line];
                }
                
            }
    		sqlite3_finalize(statement);
            return arr;
		}
    }
    return arr;

}

-(BOOL) LogsAvailableToReport
{
    NSString *select = [NSString stringWithFormat:@"select count(*) from logs where \
                        exported_at is null;"];
    sqlite3_stmt *statement;
    BOOL retVal = NO;
    @synchronized(self)
    {
		if (sqlite3_prepare_v2(m_dbHandle, [select cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK)
		{
            
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                int sum = sqlite3_column_int(statement, 0);
                
                if (sum > 0)
                {
                    retVal = YES;
                }
                
            }
    		sqlite3_finalize(statement);
            return retVal;
		}
    }
    return retVal;
    

}




@end
