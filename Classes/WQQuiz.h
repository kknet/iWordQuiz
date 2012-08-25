//
//  WQQuiz.h
//  iWordQuiz
//

/************************************************************************

Copyright 2012 Peter Hedlund peter.hedlund@me.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*************************************************************************/

#import <Foundation/Foundation.h>

typedef enum {
    WQQuizTypeFC,
    WQQuizTypeMC,
    WQQuizTypeQA
} WQQuizType;

@interface WQQuiz : NSObject {
	
    NSMutableArray * m_list;
    NSMutableArray * m_errorList;
    NSMutableArray * entries;
	
    int m_quizMode;
    int m_currentQuestion;
    int m_questionCount;
	int m_correctCount;
	int m_errorCount;

    NSString * m_correctBlank;
    NSString * m_answerBlank;
	NSString * frontIdentifier;
    NSString * backIdentifier;	
	NSString * fileName;
}

- (int) column:(int )aColumn;

- (void) activateErrorList;
- (void) activateBaseList;

- (void) finish;
- (void) toNext;
- (bool) atEnd;
- (bool) checkAnswer:(NSString *)anAnswer;
- (bool) hasErrors;

- (NSArray *) multiOptions;
- (int) questionCount;
- (void) countIncrement:(int )aValue;

- (NSString*) question;
- (NSString*) answer;
- (NSString*) langQuestion;
- (NSString*) langAnswer;

@property (nonatomic, strong) NSMutableArray *entries;
@property (nonatomic, strong) NSString *frontIdentifier;
@property (nonatomic, strong) NSString *backIdentifier;

@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, assign) int quizMode;
@property (nonatomic, assign) int correctCount;
@property (nonatomic, assign) int errorCount;

@property (nonatomic) WQQuizType quizType;

@end
