//
//  SettingsViewController.m
//  SF iOS
//
//  Created by Zachary Drayer on 4/7/19.
//

#import "SettingsViewController.h"
#import "NSUserDefaults+Settings.h"
#import "AffogatoStyle.h"
#import "EspressoStyle.h"
#import "MochaStyle.h"

typedef NS_ENUM(NSInteger, SettingsSection) {
    SettingsSectionDirectionsProvider,
	SettingsSectionStyle,
    SettingsSectionCount
};

typedef NS_ENUM(NSInteger, SettingsSectionDirectionsProviderValues) {
    SettingsSectionDirectionsProviderApple,
    SettingsSectionDirectionsProviderGoogle,
    SettingsSectionDirectionsProviderCount
};

typedef NS_ENUM(NSInteger, SettingsSectionStyleValues) {
	SettingsSectionStyleDefault, // based on UIUserInterfaceStyle, equivalent to .Affogato at the moment
	SettingsSectionStyleAffogato,
	SettingsSectionStyleEspresso,
	SettingsSectionStyleMocha,
	SettingsSectionStyleCount
};

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic) id<Style> style;

@end

@implementation SettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nil];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    _tableView.rowHeight = 64;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    _tableView.translatesAutoresizingMaskIntoConstraints = false;
    _tableView.delaysContentTouches = NO;

    return self;
}

- (void)loadView {
    [super loadView];

    [self.view addSubview:self.tableView];

    [NSLayoutConstraint activateConstraints:
     @[
       [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
       [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
       [self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
       [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
       [self.tableView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor]
       ]
     ];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SettingsSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch ((SettingsSection)section) {
        case SettingsSectionDirectionsProvider:
            return SettingsSectionDirectionsProviderCount;
		case SettingsSectionStyle:
			return SettingsSectionStyleCount;
        case SettingsSectionCount:
            NSAssert(NO, @".Count enum value does not have any data to display");
    }

    NSAssert(NO, @"Should not reach this point");
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UITextView *headerView = nil;

	switch ((SettingsSection)section) {
        case SettingsSectionDirectionsProvider: {
            headerView = [[UITextView alloc] initWithFrame:CGRectZero];
			headerView.text = NSLocalizedString(@"Map Provider", @"Title for 'Map Provider' section in Settings.");
			break;
		} case SettingsSectionStyle: {
			headerView = [[UITextView alloc] initWithFrame:CGRectZero];
			headerView.text = NSLocalizedString(@"Style", @"Title for 'Style' section in Settings.");
			break;
        } case SettingsSectionCount:
            NSAssert(NO, @".Count enum value does not have any data to display");
    }

	headerView.backgroundColor = tableView.backgroundColor;
	headerView.editable = NO;
	headerView.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
	headerView.font = self.style.fonts.headerFont;
	headerView.textColor = self.style.colors.primaryTextColor;

    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];

	BOOL isPreferredItem = NO;

    switch ((SettingsSection)indexPath.section) {
        case SettingsSectionDirectionsProvider: {
            switch ((SettingsSectionDirectionsProviderValues)indexPath.row) {
                case SettingsSectionDirectionsProviderApple:
                    cell.textLabel.text = NSLocalizedString(@"Apple Maps", @"Title for 'Apple Maps' row in Settings.");
                    isPreferredItem = NSUserDefaults.standardUserDefaults.directionsProvider == SettingsDirectionProviderApple;
                    break;
                case SettingsSectionDirectionsProviderGoogle:
                    cell.textLabel.text = NSLocalizedString(@"Google Maps", @"Title for 'Google Maps' row in Settings.");
                    isPreferredItem = NSUserDefaults.standardUserDefaults.directionsProvider == SettingsDirectionProviderGoogle;
                    break;
                case SettingsSectionDirectionsProviderCount:
                    NSAssert(NO, @".Count enum value does not have any data to display");
            }

            break;
        } case SettingsSectionStyle: {
			switch ((SettingsSectionStyleValues)indexPath.row) {
				case SettingsSectionStyleDefault:
					cell.textLabel.text = NSLocalizedString(@"Default", @"Title for 'Default' row in Settings.");
					isPreferredItem = NSUserDefaults.standardUserDefaults.activeStyleIdentifier == nil;
					break;
				case SettingsSectionStyleAffogato:
					cell.textLabel.text = NSLocalizedString(@"Affogato", @"Title for 'Affogato' row in Settings.");
					isPreferredItem = [NSUserDefaults.standardUserDefaults.activeStyleIdentifier isEqualToString:AffogatoStyle.identifier];
					break;
				case SettingsSectionStyleEspresso:
					cell.textLabel.text = NSLocalizedString(@"Espresso", @"Title for 'Espresso' row in Settings.");
					isPreferredItem = [NSUserDefaults.standardUserDefaults.activeStyleIdentifier isEqualToString:EspressoStyle.identifier];
					break;
				case SettingsSectionStyleMocha:
					cell.textLabel.text = NSLocalizedString(@"Cherry Mocha", @"Title for 'Cherry Mocha' row in Settings.");
					isPreferredItem = [NSUserDefaults.standardUserDefaults.activeStyleIdentifier isEqualToString:MochaStyle.identifier];
					break;
				case SettingsSectionStyleCount:
					NSAssert(NO, @".Count enum value does not have any data to display");
			}

			break;
		} case SettingsSectionCount:
            NSAssert(NO, @".Count enum value does not have any data to display");
    }

	if (isPreferredItem) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textLabel.textColor = self.style.colors.primaryTextColor;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textColor = self.style.colors.inactiveTextColor;
	}

	cell.backgroundColor = tableView.backgroundColor;
	cell.textLabel.font = self.style.fonts.secondaryFont;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((SettingsSection)indexPath.section) {
        case SettingsSectionDirectionsProvider:
            switch ((SettingsSectionDirectionsProviderValues)indexPath.row) {
                case SettingsSectionDirectionsProviderApple:
                    NSUserDefaults.standardUserDefaults.directionsProvider = SettingsDirectionProviderApple;
                    break;
                case SettingsSectionDirectionsProviderGoogle:
                    NSUserDefaults.standardUserDefaults.directionsProvider = SettingsDirectionProviderGoogle;
                    break;
                case SettingsSectionDirectionsProviderCount:
                    NSAssert(NO, @".Count enum value does not have any data to display");
            }
            break;
		case SettingsSectionStyle:
			switch ((SettingsSectionStyleValues)indexPath.row) {
				case SettingsSectionStyleDefault:
					NSUserDefaults.standardUserDefaults.activeStyleIdentifier = nil;
					break;
				case SettingsSectionStyleAffogato:
					NSUserDefaults.standardUserDefaults.activeStyleIdentifier = AffogatoStyle.identifier;
					break;
				case SettingsSectionStyleEspresso:
					NSUserDefaults.standardUserDefaults.activeStyleIdentifier = EspressoStyle.identifier;
					break;
				case SettingsSectionStyleMocha:
					NSUserDefaults.standardUserDefaults.activeStyleIdentifier = MochaStyle.identifier;
					break;
				case SettingsSectionStyleCount:
					NSAssert(NO, @".Count enum value does not have any data to display");
			}
			break;
        case SettingsSectionCount:
            NSAssert(NO, @".Count enum value does not have any data to display");
    }

    [tableView reloadData];
}

#pragma mark - Styleable

- (void)applyStyle:(id<Style>)style {
	self.style = style;

	self.tableView.tintColor = style.colors.tintColor;
	self.tableView.backgroundColor = style.colors.backgroundColor;

	[self.tableView reloadData];
	[self setNeedsStatusBarAppearanceUpdate];
}

@end
