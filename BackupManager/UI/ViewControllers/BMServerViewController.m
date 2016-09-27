//
//  BMServerViewController.m
//  BackupManager
//


#import "BMServerViewController.h"
#import "BMAdvertiser.h"


@interface BMServerViewController () <BMAdvertiserDelegate>

@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UITableView *connectedDevicesTableView;
@property (nonatomic, strong) NSMutableArray *connectedDevices;

- (IBAction)startButtonClicked:(UIButton *)sender;
- (IBAction)stopButtonClicked:(UIButton *)sender;
- (void)adjustUIState;

@end


@implementation BMServerViewController


#pragma mark - Getters/Setters


- (NSMutableArray *)connectedDevices {
    if (_connectedDevices == nil) {
        _connectedDevices = [NSMutableArray array];
    }
    
    return _connectedDevices;
}


#pragma mark - Lifecycle Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    [[BMAdvertiser sharedInstance]addDelegate:self];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self adjustUIState];
}


- (void)dealloc {
    [[BMAdvertiser sharedInstance]removeDelegate:self];
}


#pragma mark - IBAction


- (IBAction)startButtonClicked:(UIButton *)sender {
    [[BMAdvertiser sharedInstance]start];
    [self adjustUIState];
}


- (IBAction)stopButtonClicked:(UIButton *)sender {
    [[BMAdvertiser sharedInstance]stop];
    [self adjustUIState];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.connectedDevices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.connectedDevices[indexPath.row];
    
    return cell;
}


#pragma mark - BMAdvertiserDelegate


- (void)advertiser:(BMAdvertiser *)advertiser
    didChangeState:(MCSessionState)state
           session:(MCSession *)session
              peer:(MCPeerID *)peerID {
    if (state != MCSessionStateConnecting) {
        [self.connectedDevices removeAllObjects];
        
        if (state == MCSessionStateConnected) {
            for (MCPeerID *peer in session.connectedPeers) {
                [self.connectedDevices addObject:peer.displayName];
            }
        }
        
        [_connectedDevicesTableView reloadData];
    }
}


#pragma mark - Internal Logic


- (void)adjustUIState {
    BOOL isStarted = [[BMAdvertiser sharedInstance]isStarted];
    
    if (isStarted) {
        _startButton.enabled = NO;
        _stopButton.enabled = YES;
        
        _statusLabel.text = @"Status: Run";
        _statusLabel.textColor = [UIColor greenColor];
    }
    else {
        _startButton.enabled = YES;
        _stopButton.enabled = NO;
        
        _statusLabel.text = @"Status: Idle";
        _statusLabel.textColor = [UIColor redColor];
        
        [self.connectedDevices removeAllObjects];
        [_connectedDevicesTableView reloadData];
    }
}

@end
