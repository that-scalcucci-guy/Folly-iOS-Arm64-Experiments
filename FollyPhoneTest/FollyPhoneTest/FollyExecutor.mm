//
//  FollyExecutor.m
//  FollyPhoneTest
//
//  Created by WS Build on 4/19/21.
//

#import "FollyExecutor.h"

#include <iostream>
#include <folly/executors/ThreadedExecutor.h>
#include <folly/futures/Future.h>

@interface FollyExecutor () {
    folly::ThreadedExecutor executor;
}
@end

@implementation FollyExecutor

using namespace folly;
using namespace std;

-(instancetype)init {
    return self;
}

-(void)beginTest {
    Promise<int> *p;
    /*Future<int> f = p->getSemiFuture().via(&executor);
    auto f2 = move(f).thenValue(foo);
    cout << "Future chain made" << endl;
    
    cout << "Fulfilling Promise" << endl;
    p->setValue(42);
    move(f2).get();
    cout << "Promise fulfilled" << endl;*/
}

void foo(int x) {
    cout << "foo(" << x << ")" << endl;
}
@end
