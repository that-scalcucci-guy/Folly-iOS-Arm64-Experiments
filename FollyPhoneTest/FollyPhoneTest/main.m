//
//  main.m
//  FollyPhoneTest
//
//  Created by WS Build on 4/19/21.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//#if __has_include(<features.h>)
//#include <features.h>
//#endif
#define FOLLY_MOBILE 1
#define FOLLY_HAVE_PTHREAD 1
#define FOLLY_HAVE_PTHREAD_ATFORK 1
#define FOLLY_HAVE_LIBGFLAGS 0
#define FOLLY_UNUSUAL_GFLAGS_NAMESPACE 0
#define FOLLY_GFLAGS_NAMESPACE @FOLLY_GFLAGS_NAMESPACE@
#define FOLLY_HAVE_LIBGLOG 0
#define FOLLY_USE_JEMALLOC 1
#define FOLLY_USE_LIBSTDCPP 1
#define FOLLY_HAVE_ACCEPT4 1
#define FOLLY_HAVE_GETRANDOM 1
#define FOLLY_HAVE_PREADV 1
#define FOLLY_HAVE_PWRITEV 1
#define FOLLY_HAVE_CLOCK_GETTIME 1
#define FOLLY_HAVE_PIPE2 1
#define FOLLY_HAVE_SENDMMSG 1
#define FOLLY_HAVE_RECVMMSG 1
#define FOLLY_HAVE_OPENSSL_ASN1_TIME_DIFF 1
#define FOLLY_HAVE_IFUNC 1
#define FOLLY_HAVE_STD__IS_TRIVIALLY_COPYABLE 1
#define FOLLY_HAVE_UNALIGNED_ACCESS 0
#define FOLLY_HAVE_VLA 1
#define FOLLY_HAVE_WEAK_SYMBOLS 0
#define FOLLY_HAVE_LINUX_VDSO 0
#define FOLLY_HAVE_MALLOC_USABLE_SIZE 0
#define FOLLY_HAVE_INT128_T 1
#define FOLLY_SUPPLY_MISSING_INT128_TRAITS 1
#define FOLLY_HAVE_WCHAR_SUPPORT 0
#define FOLLY_HAVE_EXTRANDOM_SFMT19937 1
#define FOLLY_USE_LIBCPP 1
#define HAVE_VSNPRINTF_ERRORS 0
#define FOLLY_HAVE_LIBUNWIND 0
#define FOLLY_HAVE_DWARF 0
#define FOLLY_HAVE_ELF 0
#define FOLLY_HAVE_SWAPCONTEXT 1
#define FOLLY_HAVE_BACKTRACE 1
#define FOLLY_USE_SYMBOLIZER 1
#define FOLLY_DEMANGLE_MAX_SYMBOL_SIZE 1024
#define FOLLY_HAVE_SHADOW_LOCAL_WARNINGS 1
#define FOLLY_HAVE_LIBLZ4 0
#define FOLLY_HAVE_LIBLZMA 0
#define FOLLY_HAVE_LIBSNAPPY 0
#define FOLLY_HAVE_LIBZ 0
#define FOLLY_HAVE_LIBZSTD 0
#define FOLLY_HAVE_LIBBZ2 0
#define FOLLY_LIBRARY_SANITIZE_ADDRESS 1
#define FOLLY_SUPPORT_SHARED_LIBRARY 1
#define FOLLY_HAVE_LIBRT 0

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}



