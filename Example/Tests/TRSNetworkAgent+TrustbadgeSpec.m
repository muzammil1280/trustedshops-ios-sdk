#import "TRSNetworkAgent+Trustbadge.h"
#import "TRSErrors.h"
#import "TRSTrustbadge.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OCMock/OCMock.h>
#import <Specta/Specta.h>


SpecBegin(TRSNetworkAgent_Trustbadge)

describe(@"TRSNetworkAgent+Trustbadge", ^{

    __block TRSNetworkAgent *agent;
    beforeAll(^{
        agent = [[TRSNetworkAgent alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost/"]];
    });

    afterAll(^{
        agent = nil;
    });

    sharedExamplesFor(@"an unsuccessful response", ^(NSDictionary *data) {

        beforeEach(^{
            NSString *URLFormatString = @"http://localhost/rest/public/v2/shops/%@/quality";
            NSString *URLString = [NSString stringWithFormat:URLFormatString, data[@"trustedShopsID"]];
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                BOOL shouldStubResponse = [request.URL.absoluteString isEqualToString:URLString];
                return shouldStubResponse;
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                OHHTTPStubsResponse *response = data[@"response"];
                return response;
            }];
        });

        afterEach(^{
            [OHHTTPStubs removeAllStubs];
        });

        it(@"executes the failure block", ^{
            waitUntil(^(DoneCallback done) {
                [agent getTrustbadgeForTrustedShopsID:data[@"trustedShopsID"]
                                              success:nil
                                              failure:^(NSError *error) {
                                                  done();
                                              }];
            });
        });

    });

    describe(@"-getTrustbadgeForTrustedShopsID:success:failure", ^{

        it(@"returns a data task", ^{
            id task = [agent getTrustbadgeForTrustedShopsID:nil success:nil failure:nil];
            expect(task).to.beKindOf([NSURLSessionDataTask class]);
        });

        it(@"has the correct URL", ^{
            NSURLSessionDataTask *task = (NSURLSessionDataTask *)[agent getTrustbadgeForTrustedShopsID:@"123" success:nil failure:nil];
            expect(task.originalRequest.URL).to.equal([NSURL URLWithString:@"http://localhost/rest/public/v2/shops/123/quality"]);
        });

        it(@"calls '-GET:success:failure'", ^{
            id agentMock = OCMPartialMock(agent);
            OCMExpect([agentMock GET:@"/rest/public/v2/shops/123/quality" success:[OCMArg any] failure:[OCMArg any]]);

            [agent getTrustbadgeForTrustedShopsID:@"123" success:nil failure:nil];

            OCMVerifyAll(agentMock);
        });

        context(@"on success", ^{

            beforeEach(^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.absoluteString isEqualToString:@"http://localhost/rest/public/v2/shops/123/quality"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
                    NSString *path = [bundle pathForResource:@"trustbadge" ofType:@"data"];
                    NSData *data = [NSData dataWithContentsOfFile:path];
                    return [OHHTTPStubsResponse responseWithData:data
                                                      statusCode:200
                                                         headers:nil];
                }];
            });

            afterEach(^{
                [OHHTTPStubs removeAllStubs];
            });

            it(@"executes the success block", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"123"
                                                  success:^(TRSTrustbadge *trustbadge) {
                                                      done();
                                                  }
                                                  failure:nil];
                });
            });

            it(@"passes a model object", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"123"
                                                  success:^(TRSTrustbadge *trustbadge) {
                                                      expect(trustbadge).notTo.beNil();
                                                      done();
                                                  }
                                                  failure:nil];
                });
            });

            it(@"passes a 'TRSTrustbadge' data model ", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"123"
                                                  success:^(TRSTrustbadge *trustbadge) {
                                                      expect(trustbadge).to.beKindOf([TRSTrustbadge class]);
                                                      done();
                                                  }
                                                  failure:nil];
                });
            });

        });

        context(@"on failure", ^{

            beforeEach(^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.absoluteString isEqualToString:@"http://localhost/foo/bar/baz"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    NSError *networkError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil];
                    return [OHHTTPStubsResponse responseWithError:networkError];
                }];
            });

            afterEach(^{
                [OHHTTPStubs removeAllStubs];
            });

            it(@"executes the failure block", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"error"
                                                  success:nil
                                                  failure:^(NSError *error) {
                                                      done();
                                                  }];
                });
            });

            it(@"passes an error object with a 'NSURLErrorDomain' error domain", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"error"
                                                  success:nil
                                                  failure:^(NSError *error) {
                                                      expect(error.domain).to.equal(@"NSURLErrorDomain");
                                                      done();
                                                  }];
                });
            });

            it(@"passes an error object with a 'NSURLErrorCannotConnectToHost' error code", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"error"
                                                  success:nil
                                                  failure:^(NSError *error) {
                                                      expect(error.code).to.equal(NSURLErrorCannotConnectToHost);
                                                      done();
                                                  }];
                });
            });

        });

        context(@"with a HTTP 400 code", ^{

            beforeEach(^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return YES;
                }
                                    withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                                        NSString *file = OHPathForFileInBundle(@"trustbadge-badrequest.response", [NSBundle bundleForClass:[self class]]);
                                        NSData *messageData = [NSData dataWithContentsOfFile:file];
                                        return [OHHTTPStubsResponse responseWithHTTPMessageData:messageData];
                                    }];
            });

            afterEach(^{
                [OHHTTPStubs removeAllStubs];
            });

            it(@"passes a custom trustbadge error domain", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"123123123"
                                                  success:nil
                                                  failure:^(NSError *error) {
                                                      expect(error.domain).to.equal(TRSErrorDomain);
                                                      done();
                                                  }];
                });
            });

            it(@"passes a custom error code", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"123123123"
                                                  success:nil
                                                  failure:^(NSError *error) {
                                                      expect(error.code).to.equal(TRSErrorDomainTrustbadgeInvalidTSID);
                                                      done();
                                                  }];
                });
            });

        });

        context(@"with an 404 error", ^{

            beforeEach(^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return YES;
                }
                                    withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                                        NSString *file = OHPathForFileInBundle(@"trustbadge-notfound.response", [NSBundle bundleForClass:[self class]]);
                                        NSData *messageData = [NSData dataWithContentsOfFile:file];
                                        return [OHHTTPStubsResponse responseWithHTTPMessageData:messageData];
                                    }];
            });

            afterEach(^{
                [OHHTTPStubs removeAllStubs];
            });

            it(@"passes a custom trustbadge error domain", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"000111222333444555666777888999111"
                                                  success:nil
                                                  failure:^(NSError *error) {
                                                      expect(error.domain).to.equal(TRSErrorDomain);
                                                      done();
                                                  }];
                });
            });

            it(@"passes a custom error code", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"000111222333444555666777888999111"
                                                  success:nil
                                                  failure:^(NSError *error) {
                                                      expect(error.code).to.equal(TRSErrorDomainTrustbadgeTSIDNotFound);
                                                      done();
                                                  }];
                });
            });

        });

        context(@"when receiving an unkown error", ^{

            beforeEach(^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return YES;
                }
                                    withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                                        return [OHHTTPStubsResponse responseWithData:[[NSString stringWithFormat:@"not a HTTP status code"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                          statusCode:460
                                                                             headers:nil];
                                    }];
            });

            afterEach(^{
                [OHHTTPStubs removeAllStubs];
            });

            it(@"passes a data object", ^{
                waitUntil(^(DoneCallback done) {
                    [agent GET:@"/foo/bar/baz"
                       success:nil
                       failure:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
                           expect(data).to.equal([[NSString stringWithFormat:@"not a HTTP status code"] dataUsingEncoding:NSUTF8StringEncoding]);
                           done();
                       }];
                });
            });

            it(@"passes a custom error domain", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"error"
                                                  success:nil
                                                  failure:^(NSError *error) {
                                                      expect(error.domain).to.equal(TRSErrorDomain);
                                                      done();
                                                  }];
                });
            });

            it(@"passes a custom error code", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"error"
                                                  success:nil
                                                  failure:^(NSError *error) {
                                                      expect(error.code).to.equal(TRSErrorDomainTrustbadgeUnknownError);
                                                      done();
                                                  }];
                });
            });

        });

        context(@"when data is invalid", ^{

            beforeEach(^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.absoluteString isEqualToString:@"http://localhost/rest/public/v2/shops/111222333444555666777888999111222/quality"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithData:[[NSString stringWithFormat:@"no json data"] dataUsingEncoding:NSUTF8StringEncoding]
                                                      statusCode:200
                                                         headers:nil];
                }];
            });

            afterEach(^{
                [OHHTTPStubs removeAllStubs];
            });

            it(@"executes the failure block", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"error"
                                                  success:nil
                                                  failure:^(NSError *error) {
                                                      done();
                                                  }];
                });
            });

            it(@"passes a custom trustbadge error domain", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"111222333444555666777888999111222"
                                                  success:nil
                                                  failure:^(NSError *error) {
                                                      expect(error.domain).to.equal(TRSErrorDomain);
                                                      done();
                                                  }];
                });
            });

            it(@"passes a custom error code", ^{
                waitUntil(^(DoneCallback done) {
                    [agent getTrustbadgeForTrustedShopsID:@"111222333444555666777888999111222"
                                                  success:nil
                                                  failure:^(NSError *error) {
                                                      expect(error.code).to.equal(TRSErrorDomainTrustbadgeInvalidData);
                                                      done();
                                                  }];
                });
            });

        });

    });

});

SpecEnd
