//
// Tree.h
//
// Katharina Winkler
//
// Definition eines Tree Objekts
//

#import <Foundation/Foundation.h>

@interface Tree : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSArray *info;

@end
