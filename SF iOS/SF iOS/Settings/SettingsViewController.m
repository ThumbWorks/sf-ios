//
//  SettingsViewController.m
//  SF iOS
//
//  Created by Zachary Drayer on 4/7/19.
//

#import "SettingsViewController.h"
#import "NSUserDefaults+Settings.h"

typedef NS_ENUM(NSInteger, SettingsSection) {
    SettingsSectionDirectionsProvider,
    SettingsSectionCount
};

typedef NS_ENUM(NSInteger, SettingsSectionDirectionsProviderValues) {
    SettingsSectionDirectionsProviderApple,
    SettingsSectionDirectionsProviderGoogle,
    SettingsSectionDirectionsProviderCount
};

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

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
    _tableView.tintColor = UIColor.blackColor;

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

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SettingsSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch ((SettingsSection)section) {
        case SettingsSectionDirectionsProvider:
            return SettingsSectionDirectionsProviderCount;
        case SettingsSectionCount:
            NSAssert(NO, @".Count enum value does not have any data to display");
    }

    NSAssert(NO, @"Should not reach this point");
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch ((SettingsSection)section) {
        case SettingsSectionDirectionsProvider: {
            UITextView *headerView = [[UITextView alloc] initWithFrame:CGRectZero];
            headerView.editable = NO;
            headerView.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
            headerView.text = NSLocalizedString(@"Map Provider", @"Title for 'Map Provider' section in Settings.");
            headerView.font = [UIFont systemFontOfSize:34 weight:UIFontWeightBold];
            return headerView;
        } case SettingsSectionCount:
            NSAssert(NO, @".Count enum value does not have any data to display");
    }

    NSAssert(NO, @"Should not reach this point");
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];

    switch ((SettingsSection)indexPath.section) {
        case SettingsSectionDirectionsProvider: {
            BOOL isPreferredDirectionsProvider = NO;

            switch ((SettingsSectionDirectionsProviderValues)indexPath.row) {
                case SettingsSectionDirectionsProviderApple:
                    cell.textLabel.text = NSLocalizedString(@"Apple Maps", @"Title for 'Apple Maps' row in Settings.");
                    isPreferredDirectionsProvider = NSUserDefaults.standardUserDefaults.directionsProvider == SettingsDirectionProviderApple;
                    break;
                case SettingsSectionDirectionsProviderGoogle:
                    cell.textLabel.text = NSLocalizedString(@"Google Maps", @"Title for 'Google Maps' row in Settings.");
                    isPreferredDirectionsProvider = NSUserDefaults.standardUserDefaults.directionsProvider == SettingsDirectionProviderGoogle;
                    break;
                case SettingsSectionDirectionsProviderCount:
                    NSAssert(NO, @".Count enum value does not have any data to display");
            }

            if (isPreferredDirectionsProvider) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.textLabel.textColor = UIColor.blackColor;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.textColor = [UIColor.blackColor colorWithAlphaComponent:0.2];
            }

            break;
        }
        case SettingsSectionCount:
            NSAssert(NO, @".Count enum value does not have any data to display");
    }

    cell.textLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightRegular];

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
        case SettingsSectionCount:
            NSAssert(NO, @".Count enum value does not have any data to display");
    }

    [tableView reloadData];
}

@end
