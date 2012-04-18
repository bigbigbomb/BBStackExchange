//
//  Created by Brian Romanko on 4/3/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "QuestionTableViewCell.h"
#import "BBStackAPIQuestion.h"


@implementation QuestionTableViewCell

@synthesize question = _question;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        self.detailTextLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    return self;
}

- (void)dealloc {
    [_question release];
    [super dealloc];
}

- (void)setQuestion:(BBStackAPIQuestion *)aQuestion {
    _question = [aQuestion retain];

    self.textLabel.text = self.question.title;
    self.detailTextLabel.text = self.question.body;

    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textLabel.frame = CGRectMake(10, 10, 300, 20);

    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0, 25);
    self.detailTextLabel.frame = detailTextLabelFrame;
}


@end