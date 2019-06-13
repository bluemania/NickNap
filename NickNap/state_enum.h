//
//  state_enum.h
//  NickNap
//
//  Created by Nicholas Jenkins on 13/6/19.
//  Copyright © 2019 Nicholas Jenkins. All rights reserved.
//

#ifndef state_enum_h
#define state_enum_h

typedef NS_ENUM(NSInteger, State)
{
    STATE_READY,
    STATE_ACTIVE,
    STATE_ALARMED,
    STATE_STOPPED,
    STATE_PAUSED
};

#endif /* state_enum_h */
