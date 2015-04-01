
#import "virus_spread-Swift.h"

#ifndef ERROR_OBJC_H
#define ERROR_OBJC_H

#define defaultError(err)   \
    [[AppDelegate instance] defaultError_int: err]

#define fatalErrorWithUi(err)   \
    [[AppDelegate instance] fatalErrorWithUi_int: ^() { return err; }]

#define debugMessage(msg)   \
    [[AppDelegate instance] debugMessage_int: msg]

#endif /* ERROR_OBJC_H */

