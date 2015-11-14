//
//  RssReader.m
//  com.slk.FreshmanGuider
//
//  Created by Takanashirin on 15/10/11.
//  Copyright © 2015年 Takanashirin. All rights reserved.
//


#import "RssReader.h"
#import "AppDelegate.h"
#import "newsRecord.h"
//
@class newsRecord;
//static NSString *kEntryStr  = @"entry";
static NSString *kTitle     = @"title";
static NSString *kLink      = @"link";
static NSString *kDate  = @"pubDate";
static NSString *kStartNode = @"item";
//static NSString *kIDStr     = @"id";
//static NSString *kNameStr   = @"summary";
//static NSString *kImageStr  = @"im:image";
//static NSString *kArtistStr = @"im:artist";


@interface RssReader ()
//TODO:
@property (nonatomic, copy) ArrayBlock completionHandler;
@property (nonatomic, retain) NSData *dataToParse;
@property (nonatomic, retain) NSMutableArray *workingArray;
@property (nonatomic, retain) newsRecord *workingEntry;
@property (nonatomic, retain) NSMutableString *workingPropertyString;
@property (nonatomic, retain) NSArray *elementsToParse;
@property (nonatomic, assign) BOOL storingCharacterData;
@end

@implementation RssReader

@synthesize completionHandler, errorHandler, dataToParse, workingArray, workingEntry, workingPropertyString, elementsToParse, storingCharacterData;

- (id)initWithData:(NSData *)data completionHandler:(ArrayBlock)handler
{
    NSLog(@"in function initWithData:completionHandler:\n");

    self = [super init];
    if (self != nil)
    {
        NSLog(@"2333333");
        self.dataToParse = data;
        self.completionHandler = handler;
//        self.elementsToParse = [NSArray arrayWithObjects:kIDStr, kNameStr, kArtistStr, nil];
        self.elementsToParse = [NSArray arrayWithObjects:kTitle, kLink, kDate, nil];
    }
    return self;
}


- (void)main
{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"in function main\n");
    
    self.workingArray = [NSMutableArray array];
    self.workingPropertyString = [NSMutableString string];
    
    
    //
//        NSLog(@"%@", [[NSString alloc] initWithData:dataToParse encoding:NSUTF8StringEncoding]);
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToParse];
    [parser setDelegate:self];
    [parser parse];
        NSLog(@"in function main\n");
    if (![self isCancelled])
    {
        // call our completion handler with the result of our parsing
        self.completionHandler(self.workingArray);
    }
    
    self.workingArray = nil;
    self.workingPropertyString = nil;
    self.dataToParse = nil;
    
//    [parser release];
//    
//    [pool release];
}
#pragma mark RSS processing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{

    NSLog(@"in function parser:didStartElement:\n");
//    NSLog(@"eleName: %@ \n", elementName);
    if ([elementName isEqualToString:kStartNode])
    {
        
        self.workingEntry = [[newsRecord alloc] init];
    }
    storingCharacterData = [elementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    NSLog(@"in function parser:didEndElement:\n");
    if (self.workingEntry)
    {
        if (storingCharacterData)
        {
            NSString *trimmedString = [workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [workingPropertyString setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:kTitle])
            {
                self.workingEntry.title = trimmedString;
            }
            else if ([elementName isEqualToString:kLink])
            {
                self.workingEntry.link = trimmedString;
            }
            else if ([elementName isEqualToString:kDate])
            {
                self.workingEntry.newsDate = trimmedString;
            }
        }
        else if ([elementName isEqualToString:kStartNode])
        {
            [self.workingArray addObject:self.workingEntry];
            self.workingEntry = nil;
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
#ifdef DEBUG
//    NSLog(@"in function parser:foundCharacters:\n");
#endif
    if (storingCharacterData)
    {
        [workingPropertyString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"in function parser:parseErrorOccurred:\n");
    self.errorHandler(parseError);
}

@end

