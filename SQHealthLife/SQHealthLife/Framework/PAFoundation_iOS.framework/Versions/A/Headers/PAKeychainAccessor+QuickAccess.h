//
//  PAKeychainAccessor+QuickAccessor.h
//  PAFoundation
//
//  Created by S Q on 13-3-4.
//
//

#import <PAFoundation_iOS/PAKeychainAccessor.h>

@interface PAKeychainAccessor (QuickAccess)

+ (BOOL) addToKeychainUsingName:(NSString *) name andValue:(NSString *) value andServiceName:(NSString *) serviceName error:(NSError **) error;

+ (NSString *) valueForName:(NSString *) name andServiceName:(NSString *) serviceName error:(NSError **)error;

+ (BOOL) removeName:(NSString *) name andServiceName:(NSString *) serviceName error:(NSError **) error;

@end
