/* GormMenuInspectors.m
 *
 * Copyright (C) 2000 Free Software Foundation, Inc.
 *
 * Author:	Richard Frith-Macdonald <richard@brainstrom.co.uk>
 * Date:	2000
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

#include <AppKit/AppKit.h>
#include <InterfaceBuilder/InterfaceBuilder.h>
#include "GormPrivate.h"
#include "GormDocument.h"

@interface GormMenuAttributesInspector : IBInspector
{
  NSTextField	*titleText;
  NSMatrix      *menuType;
}
- (void) updateMenuType: (id)sender;
@end

@implementation GormMenuAttributesInspector

- (void) controlTextDidEndEditing: (NSNotification*)aNotification
{
  [object setTitle: [titleText stringValue]];
}

- (id) init
{
  if ([super init] == nil)
    return nil;

  if ([NSBundle loadNibNamed: @"GormMenuAttributesInspector" owner: self] == NO)
    {
      NSLog(@"Could not gorm GormMenuAttributesInspector");
      return nil;
    }
  return self;
}

- (void) setObject: (id)anObject
{
  GormDocument *doc = (GormDocument *)[(id<IB>)NSApp activeDocument];
  // BOOL flag = NO;

  object = nil; // remove reference to old object...
  [super setObject: anObject];
  [titleText setStringValue: [object title]];
  
  // set up the menu type matrix...
  if([doc windowsMenu] == anObject)
    {
      [menuType selectCellAtRow: 0 column: 0];
    }
  else if([doc servicesMenu] == anObject)
    {
      [menuType selectCellAtRow: 1 column: 0];
    }
  else // normal menu without any special function
    {
      [menuType selectCellAtRow: 2 column: 0];
    }
}

- (void) updateMenuType: (id)sender
{
  BOOL flag;
  GormDocument *doc = (GormDocument *)[(id<IB>)NSApp activeDocument];

  // look at the values passed back in the matrix.
  flag = ([[menuType cellAtRow: 0 column: 0] state] == NSOnState) ? YES : NO; // windows menu...
  if(flag) 
    { 
      [doc setWindowsMenu: [self object]]; 
      if([doc servicesMenu] == [self object])
	{
	  [doc setServicesMenu: nil];
	}
    }

  flag = ([[menuType cellAtRow: 1 column: 0] state] == NSOnState) ? YES : NO; // services menu...
  if(flag) 
    { 
      [doc setServicesMenu: [self object]];
      if([doc windowsMenu] == [self object])
	{
	  [doc setWindowsMenu: nil];
	}
    }

  flag = ([[menuType cellAtRow: 2 column: 0] state] == NSOnState) ? YES : NO; // normal menu...
  if(flag) 
    {
      [doc setWindowsMenu: nil]; 
      [doc setServicesMenu: nil]; 
    }
}
@end



@implementation	NSMenuItem (IBObjectAdditions)
- (NSString*) inspectorClassName
{
  return @"GormMenuItemAttributesInspector";
}
@end

@interface GormMenuItemAttributesInspector : IBInspector
{
  NSTextField	*titleText;
  NSTextField	*shortCut;
  NSTextField	*tagText;
}
@end

@implementation GormMenuItemAttributesInspector

- (void) controlTextDidEndEditing: (NSNotification*)aNotification
{
  id	o = [aNotification object];

  if (o == titleText)
    {
      [object setTitle: [titleText stringValue]];
    }
  if (o == shortCut)
    {
      NSString	*s = [[shortCut stringValue] stringByTrimmingSpaces];

      [object setKeyEquivalent: s];
    }
  if (o == tagText)
    {
      [object setTag: [tagText intValue]];
    }
  [[object menu] display];
}

- (id) init
{
  if ([super init] == nil)
    return nil;

  if ([NSBundle loadNibNamed: @"GormMenuItemAttributesInspector" owner: self] == NO)
    {
      NSLog(@"Could not gorm GormMenuItemAttributesInspector");
      return nil;
    }
  return self;
}

- (void) setObject: (id)anObject
{
  [super setObject: anObject];
  [titleText setStringValue: [object title]];
  [shortCut setStringValue: [object keyEquivalent]];
  [tagText setIntValue: [object tag]];
}

@end
