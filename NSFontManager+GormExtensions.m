/* NSFontManager+GormExtensions.m
 *
 * Copyright (C) 2004 Free Software Foundation, Inc.
 *
 * Author:      Gregory John Casamento <greg_casamento@yahoo.com>
 * Date:        2004
 *
 * This file is part of GNUstep.
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <Foundation/NSObject.h>
#include <Foundation/NSException.h>
#include <AppKit/NSApplication.h>
#include "NSFontManager+GormExtensions.h"
#include "GormDocument.h"

@interface GormDocument (FontManagerMethod)
- (id) lastEditor;
@end

@implementation GormDocument (FontManagerMethod)
- (id) lastEditor
{
  return lastEditor;
}
@end

@implementation NSFontManager (GormExtensions)

- (BOOL) sendAction
{
  NSApplication *theApp = [NSApplication sharedApplication];
  BOOL result = NO;

  if (_action)
    result = [theApp sendAction: _action to: nil from: self];

  if(result == NO)
    {
      id object = [(GormDocument *)[(id<IB>)NSApp activeDocument] lastEditor];
      NS_DURING
	{
	  if(object != nil)
	    {
	      if([object respondsToSelector: _action])
		{
		  [object performSelector: _action withObject: self];
		  result = YES;
		}
	    }
	}
      NS_HANDLER
	{
	  NSDebugLog(@"Couldn't set font on %@: %@", object, [localException reason]);
	  result = NO; // just to be sure.
	}
      NS_ENDHANDLER
    }

  return result;
}

@end
