//
//  MCViewController.h
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

#import <UIKit/UIKit.h>

#import "WQQuiz.h"
#import "WQScoreButton.h"

@interface MCViewController : UIViewController {
	WQQuiz * m_quiz;
    NSArray *m_optionButtons;
	
	UILabel *questionIdentifierLabel;
	UILabel *answerIdentifierLabel;
	UILabel *questionLabel;
	
	UIButton *opt1Button;
	UIButton *opt2Button;
	UIButton *opt3Button;
	
	WQScoreButton *questionCountButton;
	WQScoreButton *answerCountButton;
	WQScoreButton *correctCountButton;
	WQScoreButton *errorCountButton;
	
	UILabel *previousQuestionHeaderLabel;
	UILabel *previousQuestionLabel;
	UILabel *yourAnswerHeaderLabel;
	UILabel *yourAnswerLabel;
	UILabel *correctAnswerHeaderLabel;
	UILabel *correactAnswerLabel;
	
	UIView * questionLine;
    UIView * answerLine;
	UIView * previousQuestionLine;
	UIView * yourAnswerLine;
	UIView * correctAnswerLine;
	
	UIView *questionView;
	UIView *previousView;
}

- (void) start;
- (void) restart;
- (void) slotCheck;
- (void) showQuestion;
- (void) animate:(UILabel *)aLabel error:(BOOL) flag;

@property (nonatomic, strong) WQQuiz *quiz;

@property (nonatomic, strong) IBOutlet UILabel *questionIdentifierLabel;
@property (nonatomic, strong) IBOutlet UILabel *answerIdentifierLabel;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;

@property (nonatomic, strong) IBOutlet UIButton *opt1Button;
@property (nonatomic, strong) IBOutlet UIButton *opt2Button;
@property (nonatomic, strong) IBOutlet UIButton *opt3Button;

@property (nonatomic, strong) IBOutlet WQScoreButton *questionCountButton;
@property (nonatomic, strong) IBOutlet WQScoreButton *answerCountButton;
@property (nonatomic, strong) IBOutlet WQScoreButton *correctCountButton;
@property (nonatomic, strong) IBOutlet WQScoreButton *errorCountButton;

@property (nonatomic, strong) IBOutlet UILabel *previousQuestionHeaderLabel;
@property (nonatomic, strong) IBOutlet UILabel *previousQuestionLabel;
@property (nonatomic, strong) IBOutlet UILabel *yourAnswerHeaderLabel;
@property (nonatomic, strong) IBOutlet UILabel *yourAnswerLabel;
@property (nonatomic, strong) IBOutlet UILabel *correctAnswerHeaderLabel;
@property (nonatomic, strong) IBOutlet UILabel *correactAnswerLabel;

@property (nonatomic, strong) IBOutlet UIView * questionLine;
@property (nonatomic, strong) IBOutlet UIView * answerLine;
@property (nonatomic, strong) IBOutlet UIView * previousQuestionLine;
@property (nonatomic, strong) IBOutlet UIView * yourAnswerLine;
@property (nonatomic, strong) IBOutlet UIView * correctAnswerLine;

@property (nonatomic, strong) IBOutlet UIView *questionView;
@property (nonatomic, strong) IBOutlet UIView *previousView;

- (IBAction) doChoice:(id)sender;
- (IBAction) doRestart;
- (IBAction) doRepeat;

@end
