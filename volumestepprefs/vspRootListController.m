#include "vspRootListController.h"


@interface PSListController (iOS12Plus)
-(BOOL)containsSpecifier:(PSSpecifier *)arg1;
@end

@implementation vspRootListController
bool separate;
- (instancetype)init {
	self = [super init];
	if (self) {
		AppearanceSettings *appearanceSettings = [[AppearanceSettings alloc] init];

		self.hb_appearanceSettings = appearanceSettings;
		self.navigationItem.titleView = [UIView new];
		self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,10,10)];
		self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		self.titleLabel.text = @"VolumeStep13/14";
		self.titleLabel.textColor = [UIColor whiteColor];
		self.titleLabel.textAlignment = NSTextAlignmentCenter;
		[self.navigationItem.titleView addSubview:self.titleLabel];

		self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,10)];
		self.iconView.contentMode = UIViewContentModeScaleAspectFit;
		self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/volumestepprefs.bundle/head.png"];
		self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
		self.iconView.alpha = 0.0;
		[self.navigationItem.titleView addSubview:self.iconView];

		[NSLayoutConstraint activateConstraints:@[

		[self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
		[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
		[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
		[self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
		[self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
		[self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
		[self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
		[self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        ]];
	}
	return self;
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

		NSArray *chosenIDs = @[@"VibeHide", @"vsSeperate", @"VolumeUp", @"VolumeUpDown", @"prefInt", @"VolumeDown", @"prefIntDown"];
    self.savedSpecifiers = (_savedSpecifiers) ?: [[NSMutableDictionary alloc] init];
		for(PSSpecifier *specifier in _specifiers) {
			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
			}
		}
	}
	return _specifiers;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	tableView.tableHeaderView = self.headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat offsetY = scrollView.contentOffset.y;

	if (offsetY > 200) {
		[UIView animateWithDuration:0.2 animations:^{
			self.iconView.alpha = 1.0;
			self.titleLabel.alpha = 0.0;
		}];
	} else {
		[UIView animateWithDuration:0.2 animations:^{
			self.iconView.alpha = 0.0;
			self.titleLabel.alpha = 1.0;
		}];
	}

	if (offsetY > 0) offsetY = 0;
	self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	[super setPreferenceValue:value specifier:specifier];
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];

	NSString *key = [specifier propertyForKey:@"key"];
	if ([key isEqualToString:@"VSStepEnabled"]) {
		if (![value boolValue]) {
			if([self containsSpecifier:self.savedSpecifiers[@"vsSeperate"]]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"vsSeperate"]] animated:YES];
			}
			
			if([self containsSpecifier:self.savedSpecifiers[@"VolumeUp"]]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeUp"]] animated:NO];
			}
			
			if([self containsSpecifier:self.savedSpecifiers[@"VolumeUpDown"]]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeUpDown"]] animated:NO];
			}
			
			if([self containsSpecifier:self.savedSpecifiers[@"prefInt"]]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"prefInt"]] animated:YES];
			}
			
			if([self containsSpecifier:self.savedSpecifiers[@"VolumeDown"]]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeDown"]] animated:YES];
			}
			
			if([self containsSpecifier:self.savedSpecifiers[@"prefIntDown"]]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"prefIntDown"]] animated:YES];
			}
		} else {
			if (![self containsSpecifier:self.savedSpecifiers[@"vsSeperate"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"vsSeperate"]] afterSpecifierID:@"vsEnable" animated:YES];
			}
			if (![self containsSpecifier:self.savedSpecifiers[@"prefInt"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"prefInt"]] afterSpecifierID:@"vsSeperate" animated:YES];
			}
			if (separate) {
				if (![self containsSpecifier:self.savedSpecifiers[@"VolumeUp"]]) {
					[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeUp"]] afterSpecifierID:@"vsSeperate" animated:NO];
				}

				if (![self containsSpecifier:self.savedSpecifiers[@"VolumeDown"]]) {
					[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeDown"]] afterSpecifierID:@"prefInt" animated:YES];
				}
				if (![self containsSpecifier:self.savedSpecifiers[@"prefIntDown"]]) {
					[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"prefIntDown"]] afterSpecifierID:@"VolumeDown" animated:YES];
				}
				if ([self containsSpecifier:self.savedSpecifiers[@"VolumeUpDown"]]) {
					[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeUpDown"]] animated:NO];
				}
			} else {
				if (![self containsSpecifier:self.savedSpecifiers[@"VolumeUpDown"]]) {
					[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeUpDown"]] afterSpecifierID:@"vsSeperate" animated:NO];
				}
				if ([self containsSpecifier:self.savedSpecifiers[@"VolumeDown"]]) {
					[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeDown"]] animated:YES];
				}
				if ([self containsSpecifier:self.savedSpecifiers[@"VolumeUp"]]) {
					[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeUp"]] animated:NO];
				}
				if ([self containsSpecifier:self.savedSpecifiers[@"prefIntDown"]]) {
					[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"prefIntDown"]] animated:YES];
				}
			}
		}
	}
	
	
	
	if ([key isEqualToString:@"vsSeperate"]) {
		if (![value boolValue]) {
			separate = NO;
			if([self containsSpecifier:self.savedSpecifiers[@"prefInt"]]) {
				if (![self containsSpecifier:self.savedSpecifiers[@"VolumeUpDown"]]) {
					[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeUpDown"]] afterSpecifierID:@"vsSeperate" animated:NO];
				}
				if ([self containsSpecifier:self.savedSpecifiers[@"VolumeDown"]]) {
					[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeDown"]] animated:YES];
				}
				if ([self containsSpecifier:self.savedSpecifiers[@"VolumeUp"]]) {
					[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeUp"]] animated:NO];
				}
				if ([self containsSpecifier:self.savedSpecifiers[@"prefIntDown"]]) {
					[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"prefIntDown"]] animated:YES];
				}
			}
		} else if([self containsSpecifier:self.savedSpecifiers[@"prefInt"]]) {
			separate = YES;
			if (![self containsSpecifier:self.savedSpecifiers[@"vsSeperate"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"vsSeperate"]] afterSpecifierID:@"vsEnable" animated:YES];
			}
			if (![self containsSpecifier:self.savedSpecifiers[@"VolumeUp"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeUp"]] afterSpecifierID:@"vsSeperate" animated:NO];
			}
			if (![self containsSpecifier:self.savedSpecifiers[@"VolumeDown"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeDown"]] afterSpecifierID:@"prefInt" animated:YES];
			}
			if (![self containsSpecifier:self.savedSpecifiers[@"prefIntDown"]]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"prefIntDown"]] afterSpecifierID:@"VolumeDown" animated:YES];
			}
			if ([self containsSpecifier:self.savedSpecifiers[@"VolumeUpDown"]]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeUpDown"]] animated:NO];
			}
		}
	}
	
	
	
	
	
	if ([key isEqualToString:@"vsVibEnabled"]) {
		if (![value boolValue]) {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VibeHide"]] animated:YES];
		} else if(![self containsSpecifier:self.savedSpecifiers[@"VibeHide"]]) {
			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"VibeHide"]] afterSpecifierID:@"Vibration" animated:YES];
		}
	}

	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}
}

-(void)reloadSpecifiers {
	[super reloadSpecifiers];
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.randy420.volumestepprefs.plist"];
if (![preferences[@"VSStepEnabled"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"vsSeperate"], self.savedSpecifiers[@"VolumeUp"], self.savedSpecifiers[@"VolumeUpDown"], self.savedSpecifiers[@"prefInt"], self.savedSpecifiers[@"VolumeDown"], self.savedSpecifiers[@"prefIntDown"]] animated:YES];
	}

	if(![preferences[@"vsSeperate"] boolValue]) {
		separate = NO;
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeUp"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeDown"]] animated:YES];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"prefIntDown"]] animated:YES];
	} else {
		separate = YES;
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VolumeUpDown"]] animated:NO];
	}
	
	
	if(![preferences[@"vsVibEnabled"] boolValue]) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"VibeHide"]] animated:YES];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self reloadSpecifiers];

	CGFloat height = [UIScreen mainScreen].bounds.size.height;
	CGFloat width = [UIScreen mainScreen].bounds.size.width;
	self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,width,0.15 * width)];
	self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width,0.15 * width)];
	self.credit = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,height)];
	self.credit.text = @"";
	self.headerImageView.contentMode = UIViewContentModeScaleToFill;
	self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/volumestepprefs.bundle/head.png"];
	self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.headerView addSubview:self.headerImageView];

	[NSLayoutConstraint activateConstraints:@[
	[self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
	[self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
	[self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
	[self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

	_table.tableHeaderView = self.headerView;
}

-(id)readPreferenceValue:(PSSpecifier *)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

-(void)pay {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/4Randy420"] options:@{} completionHandler:nil];
}

-(void)Twitter2 {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/rj_skins"] options:@{} completionHandler:nil];
}
@end
