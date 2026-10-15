#import "BluebridgePlugin.h"
#import "Flutterblue.pbobjc.h"

@interface CBUUID (CBUUIDAdditionsFlutterBlue)
- (NSString *)fullUUIDString;
@end

@implementation CBUUID (CBUUIDAdditionsFlutterBlue)
- (NSString *)fullUUIDString {
  if(self.UUIDString.length == 4) {
    return [[NSString stringWithFormat:@"0000%@-0000-1000-8000-00805F9B34FB", self.UUIDString] lowercaseString];
  }
  return [self.UUIDString lowercaseString];
}
@end

typedef NS_ENUM(NSUInteger, LogLevel) {
  emergency = 0,
  alert = 1,
  critical = 2,
  error = 3,
  warning = 4,
  notice = 5,
  info = 6,
  debug = 7
};

@interface BluebridgePlugin ()
@property(nonatomic, retain) NSObject<FlutterPluginRegistrar> *registrar;
@property(nonatomic, retain) FlutterMethodChannel *channel;
@property(nonatomic, retain) FlutterBlueStreamHandler *stateStreamHandler;
@property(nonatomic, retain) CBCentralManager *centralManager; // 蓝牙Manager
@property(nonatomic) NSMutableDictionary *scannedPeripherals; // 当次扫描的所有设备列表
@property(nonatomic) NSMutableArray *returnFlutterPeripherals; // 返回给flutter的所有设备列表
@property(nonatomic) CBPeripheral *connectedPeripheral;       // 当前链接的设备
@property(nonatomic) CBService *connectedService;       // 当前链接的设备的服务
@property(nonatomic) CBCharacteristic *connectedCharacteristic; // 当前链接的设备特征
@property(nonatomic) NSMutableArray *servicesThatNeedDiscovered;
@property(nonatomic) NSMutableArray *characteristicsThatNeedDiscovered;
@property(nonatomic) LogLevel logLevel;
@property(nonatomic) FlutterResult result;
@end

@implementation BluebridgePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                   methodChannelWithName:NAMESPACE @"/bluebridge"
                                   binaryMessenger:[registrar messenger]];
  FlutterEventChannel* stateChannel = [FlutterEventChannel eventChannelWithName:NAMESPACE @"/connect" binaryMessenger:[registrar messenger]];
  BluebridgePlugin* instance = [[BluebridgePlugin alloc] init];
  CBPeripheral * connectedPeripheral = nil;
  CBService * connectedService = nil;
  CBCharacteristic * connectedCharacteristic = nil;
  instance.channel = channel;
  instance.connectedPeripheral = connectedPeripheral;
  instance.connectedService = connectedService;
  instance.connectedCharacteristic = connectedCharacteristic;
  instance.centralManager = [[CBCentralManager alloc] initWithDelegate:instance queue:dispatch_get_main_queue()];
  instance.scannedPeripherals = [NSMutableDictionary new];
  instance.returnFlutterPeripherals = [NSMutableArray new];
  instance.servicesThatNeedDiscovered = [NSMutableArray new];
  instance.characteristicsThatNeedDiscovered = [NSMutableArray new];
  instance.logLevel = emergency;

  
  // STATE
  FlutterBlueStreamHandler* stateStreamHandler = [[FlutterBlueStreamHandler alloc] init];
  [stateChannel setStreamHandler:stateStreamHandler];
  instance.stateStreamHandler = stateStreamHandler;
  
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]){
        result(@"IOS V128.0.0");
    } else if ([@"isAvailable" isEqualToString:call.method]){
      if(self.centralManager.state != 2 && self.centralManager.state != 3) { // CBCentralManager.status 0，1，2，3，4，5 查对应状态
        result(@(YES));
      } else {
        NSLog(@"该设备不支持蓝牙");
        result(@(NO));
      }
    } else if ([@"isEnabled" isEqualToString:call.method]){
      if(self.centralManager.state == 5) {
        NSLog(@"蓝牙可用");
        result(@(YES));
    }  else {
        result(@(NO));
      }
    } else if ([@"requestPermissions" isEqualToString:call.method]){
      result(@(YES));
    } else if ([@"openSettings" isEqualToString:call.method]){
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:nil completionHandler:^(BOOL success) {   
    }];
      // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
      result(@(YES));
    } else if ([@"requestEnable" isEqualToString:call.method]){
        // centralManagerDidUpdateState 里面做提示
        result(@(NO));
    } else if ([@"requestDisable" isEqualToString:call.method]){
      // centralManagerDidUpdateState 里面做提示
        result(@(NO));
    } else if ([@"requestDiscoverable" isEqualToString:call.method]){
      // do nothing
        result(@(YES));
    } else if ([@"isDiscovering" isEqualToString:call.method]){
      // do nothing
        result(@(YES));
    } else if ([@"getBondedDevices" isEqualToString:call.method]){
      // do nothing
        result(@(YES));
    } else if ([@"startDiscovery" isEqualToString:call.method]){
      // do nothing
        result(@(YES));
    } else if ([@"cancelDiscovery" isEqualToString:call.method]){
      // 需要主动关闭蓝牙扫描
      [_centralManager stopScan];
      NSLog(@"%@", self.returnFlutterPeripherals);
      result(self.returnFlutterPeripherals);
    } else if ([@"init" isEqualToString:call.method]){
      // do nothing
      result(@(YES));
    } else if ([@"destory" isEqualToString:call.method]){
      // do nothing
      result(@(YES));
    } else if ([@"searchDevices" isEqualToString:call.method]){
      NSMutableDictionary * dict = [@{@"address":@"4c:55:12",@"name":@"flutter",@"type":@2,@"isConnected":@(YES),@"bondState":@1,@"rssi":@1} mutableCopy];
      NSMutableArray * array = [[NSMutableArray alloc]init];
      [ array addObject:dict];
      [ array addObject:dict];
      [ array addObject:dict];
      [ array addObject:dict];
      [ array addObject:dict];
      // 扫描所有蓝牙设备
      // didDiscoverPeripheral 一个个回调
      // self.scannedPeripherals = [NSMutableDictionary new];
      // self.returnFlutterPeripherals = [NSMutableArray new];
      // 置空
      NSLog(@"searchDevices 开始");
      [self.scannedPeripherals removeAllObjects ];
      [self.returnFlutterPeripherals removeAllObjects ];

      [_centralManager scanForPeripheralsWithServices:nil options:nil];
      
      // result 托管给self
      self.result = result;
        NSTimer *timer = [NSTimer timerWithTimeInterval:8.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
      [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
      // result(array);
    } else if ([@"connect" isEqualToString:call.method]){
      NSString *remoteId = call.arguments[@"mac"]; // ? mac地址作为remoteId
      // NSString *remoteId = @"139D4F26-0DED-0ABA-D4C8-47DB9CF662D5";    
      @try {
        CBPeripheral *peripheral = [_scannedPeripherals objectForKey:remoteId];
        if(peripheral == nil) {
            @throw [FlutterError errorWithCode:@"connect"
                                   message:@"Peripheral not found"
                                   details:nil];
        }
        [_centralManager connectPeripheral:peripheral options:nil];
        result(@(YES));
      } @catch(FlutterError *e) {
        result(e);
      }
    } else if ([@"disConnect" isEqualToString:call.method]){
      // NSString *remoteId = call.arguments[@"mac"]; // ? mac地址作为remoteId
      // NSString *remoteId = [call arguments]; // ? mac地址作为remoteId
      // NSString *remoteId = @"139D4F26-0DED-0ABA-D4C8-47DB9CF662D5";
      @try {
        // CBPeripheral *peripheral = [self findPeripheral:remoteId];
        // CBPeripheral *peripheral = [_scannedPeripherals objectForKey:remoteId];
        // 置空
        // [self.scannedPeripherals removeAllObjects ];
        // [self.returnFlutterPeripherals removeAllObjects ];

        if(self.connectedPeripheral == nil){
          result(@(YES));
          return;
        }
        [_centralManager cancelPeripheralConnection:self.connectedPeripheral];
        self.connectedPeripheral = nil;
        result(@(YES));
      } @catch(FlutterError *e) {
        result(e);
      }
    } else if ([@"sendMessage" isEqualToString:call.method]){
      FlutterStandardTypedData *fdata =call.arguments[@"bytes"];
      if(self.connectedPeripheral == nil){
          result(@(YES));
          return;
        }
      // 根据上面的特征self.characteristic来写入数据
      NSData *data = [fdata data];
      [self.connectedPeripheral writeValue:data forCharacteristic:self.connectedCharacteristic type:CBCharacteristicWriteWithResponse];
      result(@(YES));
    } else {
        result(FlutterMethodNotImplemented);
    }
}
-(void)timerFired:(NSTimer *)theTimer
 {
   NSLog(@"timeout");
   [_centralManager stopScan];
   NSLog(@"return deveices list:%@",self.returnFlutterPeripherals);
   // 扫描返回列表
   self.result(self.returnFlutterPeripherals);
     
 }

- (CBPeripheral*)findPeripheral:(NSString*)remoteId {
  NSArray<CBPeripheral*> *peripherals = [_centralManager retrievePeripheralsWithIdentifiers:@[[[NSUUID alloc] initWithUUIDString:remoteId]]];
  CBPeripheral *peripheral;
  for(CBPeripheral *p in peripherals) {
    if([[p.identifier UUIDString] isEqualToString:remoteId]) {
      peripheral = p;
      break;
    }
  }
  if(peripheral == nil) {
    @throw [FlutterError errorWithCode:@"findPeripheral"
                               message:@"Peripheral not found"
                               details:nil];
  }
  return peripheral;
}

- (CBCharacteristic*)locateCharacteristic:(NSString*)characteristicId peripheral:(CBPeripheral*)peripheral serviceId:(NSString*)serviceId secondaryServiceId:(NSString*)secondaryServiceId {
  CBService *primaryService = [self getServiceFromArray:serviceId array:[peripheral services]];
  if(primaryService == nil || [primaryService isPrimary] == false) {
    @throw [FlutterError errorWithCode:@"locateCharacteristic"
                               message:@"service could not be located on the device"
                               details:nil];
  }
  CBService *secondaryService;
  if(secondaryServiceId.length) {
    secondaryService = [self getServiceFromArray:secondaryServiceId array:[primaryService includedServices]];
    @throw [FlutterError errorWithCode:@"locateCharacteristic"
                               message:@"secondary service could not be located on the device"
                               details:secondaryServiceId];
  }
  CBService *service = (secondaryService != nil) ? secondaryService : primaryService;
  CBCharacteristic *characteristic = [self getCharacteristicFromArray:characteristicId array:[service characteristics]];
  if(characteristic == nil) {
    @throw [FlutterError errorWithCode:@"locateCharacteristic"
                               message:@"characteristic could not be located on the device"
                               details:nil];
  }
  return characteristic;
}

- (CBDescriptor*)locateDescriptor:(NSString*)descriptorId characteristic:(CBCharacteristic*)characteristic {
  CBDescriptor *descriptor = [self getDescriptorFromArray:descriptorId array:[characteristic descriptors]];
  if(descriptor == nil) {
    @throw [FlutterError errorWithCode:@"locateDescriptor"
                               message:@"descriptor could not be located on the device"
                               details:nil];
  }
  return descriptor;
}

// Reverse search to find primary service
- (CBService*)findPrimaryService:(CBService*)secondaryService peripheral:(CBPeripheral*)peripheral {
  for(CBService *s in [peripheral services]) {
    for(CBService *ss in [s includedServices]) {
      if([[ss.UUID UUIDString] isEqualToString:[secondaryService.UUID UUIDString]]) {
        return s;
      }
    }
  }
  return nil;
}

- (CBDescriptor*)findCCCDescriptor:(CBCharacteristic*)characteristic {
  for(CBDescriptor *d in characteristic.descriptors) {
    if([d.UUID.UUIDString isEqualToString:@"2902"]) {
      return d;
    }
  }
  return nil;
}

- (CBService*)getServiceFromArray:(NSString*)uuidString array:(NSArray<CBService*>*)array {
  for(CBService *s in array) {
    if([[s UUID] isEqual:[CBUUID UUIDWithString:uuidString]]) {
      return s;
    }
  }
  return nil;
}

- (CBCharacteristic*)getCharacteristicFromArray:(NSString*)uuidString array:(NSArray<CBCharacteristic*>*)array {
  for(CBCharacteristic *c in array) {
    if([[c UUID] isEqual:[CBUUID UUIDWithString:uuidString]]) {
      return c;
    }
  }
  return nil;
}

- (CBDescriptor*)getDescriptorFromArray:(NSString*)uuidString array:(NSArray<CBDescriptor*>*)array {
  for(CBDescriptor *d in array) {
    if([[d UUID] isEqual:[CBUUID UUIDWithString:uuidString]]) {
      return d;
    }
  }
  return nil;
}

//
// CBCentralManagerDelegate methods
//
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
  if (central.state == CBCentralManagerStatePoweredOff) {
        // 提示开启蓝牙
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Please turn on Bluetooth in Settings" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; 
      // 按照要求去掉提示
      //  [alert show]; 
    }
  // if(_stateStreamHandler.sink != nil) {
  //   FlutterStandardTypedData *data = [self toFlutterData:[self toBluetoothStateProto:self->_centralManager.state]];
  //   self.stateStreamHandler.sink(data);
  // }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
  // 扫描后的回调，发现蓝牙设备
  if ([[_scannedPeripherals allKeys] containsObject:[[peripheral identifier] UUIDString]]) {
    //过滤重复；
    // return;
  }
  // NSLog(@"%s, line = %d, cetral = %@,peripheral = %@, advertisementData = %@, RSSI = %@", __FUNCTION__, __LINE__, central, peripheral, advertisementData, RSSI);
  [self.scannedPeripherals setObject:peripheral
                              forKey:[[peripheral identifier] UUIDString]];
  // 返回flutter设备列表
  if ([advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"]){
    @try {
      CBUUID *uuid = advertisementData[@"kCBAdvDataServiceUUIDs"][0];
      // 只返回当前厂商的设备
      // if ([uuid.UUIDString isEqualToString:@"180F"] || uuid.UUIDString isEqualToString:@"5742"]){ // 兼容两套方案
      if (uuid.UUIDString isEqualToString:@"5742"]){ // 兼容两套方案
            NSMutableDictionary * dict = [@{@"address":[[peripheral identifier] UUIDString]} mutableCopy];
          // ios 15.5之后的bug，不取peripheeral.name 而是advertisementData[@"kCBAdvDataLocalName"]
          // NSString *name = [peripheral name];
          NSString *name = advertisementData[@"kCBAdvDataLocalName"];
          if (name == nil){
            name = @"";
          }
          [dict setObject: name forKey:@"name"];
          [dict setObject:@2 forKey:@"type"];
          [dict setObject: [NSNumber numberWithBool:[peripheral state]] forKey:@"isConnected"];
          
          [dict setObject:@1 forKey:@"bondState"];
          [dict setObject:RSSI forKey:@"rssi"];
          
          // 重复覆盖
          NSLog(@"%s, line = %d, cetral = %@,peripheral = %@, advertisementData = %@, RSSI = %@", __FUNCTION__, __LINE__, central, peripheral, advertisementData, RSSI);
          // for(NSMutableDictionary *d in self.returnFlutterPeripherals) {
          //   if([[d[@"address"] UUIDString] isEqualToString:[dict[@"address"] UUIDString]]) {
          //       NSLog(@"22222222222222222222222222222222222121212121212121212121212");
          //   }
          // }
          for(NSInteger i = 0; i<[self.returnFlutterPeripherals count]; i++){
            NSLog(@"11111%@,,,22222%@",dict[@"address"],self.returnFlutterPeripherals[i][@"address"]);
            if ([self.returnFlutterPeripherals[i][@"address"] isEqualToString:dict[@"address"]]){
              NSLog(@"22222222222222222222222222222222222121212121212121212121212");
              [self.returnFlutterPeripherals removeObjectAtIndex: i];
            }
          }
          [self.returnFlutterPeripherals addObject:dict];
      }

      } @catch (NSException *exception) {
        NSLog( @"NSException caught" ); 
        return;
      }


  }
  // ProtosScanResult *result = [self toScanResultProto:peripheral advertisementData:advertisementData RSSI:RSSI];
  // [_channel invokeMethod:@"RetsearchDevices" arguments:[self toFlutterData:result]];
  // NSLog(@"didDiscoverPeripheral,%@", self.scannedPeripherals);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
  // 蓝牙设备连接成功
  NSLog(@"didConnectPeripheral");
  // 可以停止扫描 如果 没有手动停止的话。
  [_centralManager stopScan];
  // 设置代理
  peripheral.delegate = self;
  // if (self.connectedPeripheral != nil){
  //   [_centralManager cancelPeripheralConnection:self.connectedPeripheral];
  // }
  self.connectedPeripheral = peripheral;
  // 寻找服务
  [peripheral discoverServices:nil];

  NSMutableDictionary * dict = [@{@"operate":@5,@"mac":[[peripheral identifier] UUIDString]} mutableCopy];
  self.stateStreamHandler.sink(dict);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
  // 断开连接
  NSLog(@"didDisconnectPeripheral:");
  NSLog(@"%s, line = %d, %@=断开连接", __FUNCTION__, __LINE__, peripheral.name);
  // Unregister self as delegate for peripheral, not working #42
  peripheral.delegate = nil;
  // 状态回传给flutter
  NSMutableDictionary * dict = [@{@"operate":@6,@"mac":[[peripheral identifier] UUIDString]} mutableCopy];
  self.stateStreamHandler.sink(dict);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
  // TODO 蓝牙设备连接失败，是否需要重连几次？？
  NSLog(@"didFailToConnectPeripheral:");
  NSLog(@"%s, line = %d, %@=连接失败", __FUNCTION__, __LINE__, peripheral.name);
}

//
// CBPeripheralDelegate methods
// 
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
  // 发现服务
  NSLog(@"didDiscoverServices");
  // 遍历出外设中所有的服务
  for (CBService *service in peripheral.services) {
    NSLog(@"所有的服务：%@",service);
  }
  self.connectedService = peripheral.services.firstObject;
  [peripheral discoverCharacteristics:nil forService:self.connectedService];

}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
  // 发现特征
  NSLog(@"didDiscoverCharacteristicsForService");
  // 遍历出所需要的特征
  for (CBCharacteristic *characteristic in service.characteristics) {
    NSLog(@"所有特征：%@", characteristic);
    // 从外设开发人员那里拿到不同特征的UUID，不同特征做不同事情，比如有读取数据的特征，也有写入数据的特征
  }
  // 这里只获取一个特征，写入数据的时候需要用到这个特征
  self.connectedCharacteristic = service.characteristics.firstObject;
  // 直接读取这个特征数据，会调用didUpdateValueForCharacteristic
  // [peripheral readValueForCharacteristic:self.connectedCharacteristic];
  // 订阅通知
  [peripheral setNotifyValue:YES forCharacteristic:self.connectedCharacteristic];
 
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  NSLog(@"didDiscoverDescriptorsForCharacteristic");
  [_characteristicsThatNeedDiscovered removeObject:characteristic];
  if(_servicesThatNeedDiscovered.count > 0 || _characteristicsThatNeedDiscovered.count > 0) {
    // Still discovering
    return;
  }
  // Send updated tree
  ProtosDiscoverServicesResult *result = [self toServicesResultProto:peripheral];
  [_channel invokeMethod:@"DiscoverServicesResult" arguments:[self toFlutterData:result]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error {
  NSLog(@"didDiscoverIncludedServicesForService");
  // Loop through and discover characteristics for secondary services
  for(CBService *ss in [service includedServices]) {
    [peripheral discoverCharacteristics:nil forService:ss];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  // 蓝牙发过来的 notify 回调都走这里
  NSLog(@"%s, line = %d, %@=，%@", __FUNCTION__, __LINE__, peripheral,characteristic);
  NSData *data = characteristic.value;
  
  // 通过Streamchannel 回传给flutter
  NSMutableDictionary * dict = [@{@"operate":@3,@"mac":[[peripheral identifier] UUIDString],@"isIndicate":@(YES),@"serviceUuid":@"Unused",@"characterUuid":@"UNused",@"bytes":data} mutableCopy];
  self.stateStreamHandler.sink(dict);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  NSLog(@"didWriteValueForCharacteristic");
  NSLog(@"写入成功");
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  // 订阅notification状态改变
  NSLog(@"didUpdateNotificationStateForCharacteristic");
  if (error) {
        NSLog(@"订阅失败");
        NSLog(@"%@",error);
    }
    if (characteristic.isNotifying) {
        NSLog(@"订阅成功");
    } else {
        NSLog(@"取消订阅");
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
  ProtosReadDescriptorRequest *q = [[ProtosReadDescriptorRequest alloc] init];
  [q setRemoteId:[peripheral.identifier UUIDString]];
  [q setCharacteristicUuid:[descriptor.characteristic.UUID fullUUIDString]];
  [q setDescriptorUuid:[descriptor.UUID fullUUIDString]];
  if([descriptor.characteristic.service isPrimary]) {
    [q setServiceUuid:[descriptor.characteristic.service.UUID fullUUIDString]];
  } else {
    [q setSecondaryServiceUuid:[descriptor.characteristic.service.UUID fullUUIDString]];
    CBService *primaryService = [self findPrimaryService:[descriptor.characteristic service] peripheral:[descriptor.characteristic.service peripheral]];
    [q setServiceUuid:[primaryService.UUID fullUUIDString]];
  }
  ProtosReadDescriptorResponse *result = [[ProtosReadDescriptorResponse alloc] init];
  [result setRequest:q];
  int value = [descriptor.value intValue];
  [result setValue:[NSData dataWithBytes:&value length:sizeof(value)]];
  [_channel invokeMethod:@"ReadDescriptorResponse" arguments:[self toFlutterData:result]];

  // If descriptor is CCCD, send a SetNotificationResponse in case anything is awaiting
  if([descriptor.UUID.UUIDString isEqualToString:@"2902"]){
    ProtosSetNotificationResponse *response = [[ProtosSetNotificationResponse alloc] init];
    [response setRemoteId:[peripheral.identifier UUIDString]];
    [response setCharacteristic:[self toCharacteristicProto:peripheral characteristic:descriptor.characteristic]];
    [response setSuccess:true];
    [_channel invokeMethod:@"SetNotificationResponse" arguments:[self toFlutterData:response]];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error {
  ProtosWriteDescriptorRequest *request = [[ProtosWriteDescriptorRequest alloc] init];
  [request setRemoteId:[peripheral.identifier UUIDString]];
  [request setCharacteristicUuid:[descriptor.characteristic.UUID fullUUIDString]];
  [request setDescriptorUuid:[descriptor.UUID fullUUIDString]];
  if([descriptor.characteristic.service isPrimary]) {
    [request setServiceUuid:[descriptor.characteristic.service.UUID fullUUIDString]];
  } else {
    [request setSecondaryServiceUuid:[descriptor.characteristic.service.UUID fullUUIDString]];
    CBService *primaryService = [self findPrimaryService:[descriptor.characteristic service] peripheral:[descriptor.characteristic.service peripheral]];
    [request setServiceUuid:[primaryService.UUID fullUUIDString]];
  }
  ProtosWriteDescriptorResponse *result = [[ProtosWriteDescriptorResponse alloc] init];
  [result setRequest:request];
  [result setSuccess:(error == nil)];
  [_channel invokeMethod:@"WriteDescriptorResponse" arguments:[self toFlutterData:result]];
}

//
// Proto Helper methods
//
- (FlutterStandardTypedData*)toFlutterData:(GPBMessage*)proto {
  FlutterStandardTypedData *data = [FlutterStandardTypedData typedDataWithBytes:[[proto data] copy]];
  return data;
}

- (ProtosBluetoothState*)toBluetoothStateProto:(CBManagerState)state  API_AVAILABLE(ios(10.0)){
  ProtosBluetoothState *result = [[ProtosBluetoothState alloc] init];
  switch(state) {
    case CBManagerStateResetting:
      [result setState:ProtosBluetoothState_State_TurningOn];
      break;
    case CBManagerStateUnsupported:
      [result setState:ProtosBluetoothState_State_Unavailable];
      break;
    case CBManagerStateUnauthorized:
      [result setState:ProtosBluetoothState_State_Unauthorized];
      break;
    case CBManagerStatePoweredOff:
      [result setState:ProtosBluetoothState_State_Off];
      break;
    case CBManagerStatePoweredOn:
      [result setState:ProtosBluetoothState_State_On];
      break;
    default:
      [result setState:ProtosBluetoothState_State_Unknown];
      break;
  }
  return result;
}

- (ProtosScanResult*)toScanResultProto:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
  ProtosScanResult *result = [[ProtosScanResult alloc] init];
  [result setDevice:[self toDeviceProto:peripheral]];
  [result setRssi:[RSSI intValue]];
  ProtosAdvertisementData *ads = [[ProtosAdvertisementData alloc] init];
  [ads setConnectable:[advertisementData[CBAdvertisementDataIsConnectable] boolValue]];
  [ads setLocalName:advertisementData[CBAdvertisementDataLocalNameKey]];
  // Tx Power Level
  NSNumber *txPower = advertisementData[CBAdvertisementDataTxPowerLevelKey];
  if(txPower != nil) {
    ProtosInt32Value *txPowerWrapper = [[ProtosInt32Value alloc] init];
    [txPowerWrapper setValue:[txPower intValue]];
    [ads setTxPowerLevel:txPowerWrapper];
  }
  // Manufacturer Specific Data
  NSData *manufData = advertisementData[CBAdvertisementDataManufacturerDataKey];
  if(manufData.length > 2) {
    unsigned short manufacturerId;
    [manufData getBytes:&manufacturerId length:2];
    [[ads manufacturerData] setObject:[manufData subdataWithRange:NSMakeRange(2, manufData.length - 2)] forKey:manufacturerId];
  }
  // Service Data
  NSDictionary *serviceData = advertisementData[CBAdvertisementDataServiceDataKey];
  for (CBUUID *uuid in serviceData) {
    [[ads serviceData] setObject:serviceData[uuid] forKey:uuid.UUIDString];
  }
  // Service Uuids
  NSArray *serviceUuids = advertisementData[CBAdvertisementDataServiceUUIDsKey];
  for (CBUUID *uuid in serviceUuids) {
    [[ads serviceUuidsArray] addObject:uuid.UUIDString];
  }
  [result setAdvertisementData:ads];
  return result;
}

- (ProtosBluetoothDevice*)toDeviceProto:(CBPeripheral *)peripheral {
  ProtosBluetoothDevice *result = [[ProtosBluetoothDevice alloc] init];
  [result setName:[peripheral name]];
  [result setRemoteId:[[peripheral identifier] UUIDString]];
  [result setType:ProtosBluetoothDevice_Type_Le]; // TODO: Does iOS differentiate?
  return result;
}

- (ProtosDeviceStateResponse*)toDeviceStateProto:(CBPeripheral *)peripheral state:(CBPeripheralState)state {
  ProtosDeviceStateResponse *result = [[ProtosDeviceStateResponse alloc] init];
  switch(state) {
    case CBPeripheralStateDisconnected:
      [result setState:ProtosDeviceStateResponse_BluetoothDeviceState_Disconnected];
      break;
    case CBPeripheralStateConnecting:
      [result setState:ProtosDeviceStateResponse_BluetoothDeviceState_Connecting];
      break;
    case CBPeripheralStateConnected:
      [result setState:ProtosDeviceStateResponse_BluetoothDeviceState_Connected];
      break;
    case CBPeripheralStateDisconnecting:
      [result setState:ProtosDeviceStateResponse_BluetoothDeviceState_Disconnecting];
      break;
  }
  [result setRemoteId:[[peripheral identifier] UUIDString]];
  return result;
}

- (ProtosDiscoverServicesResult*)toServicesResultProto:(CBPeripheral *)peripheral {
  ProtosDiscoverServicesResult *result = [[ProtosDiscoverServicesResult alloc] init];
  [result setRemoteId:[peripheral.identifier UUIDString]];
  NSMutableArray *servicesProtos = [NSMutableArray new];
  for(CBService *s in [peripheral services]) {
    [servicesProtos addObject:[self toServiceProto:peripheral service:s]];
  }
  [result setServicesArray:servicesProtos];
  return result;
}

- (ProtosConnectedDevicesResponse*)toConnectedDeviceResponseProto:(NSArray<CBPeripheral*>*)periphs {
  ProtosConnectedDevicesResponse *result = [[ProtosConnectedDevicesResponse alloc] init];
  NSMutableArray *deviceProtos = [NSMutableArray new];
  for(CBPeripheral *p in periphs) {
    [deviceProtos addObject:[self toDeviceProto:p]];
  }
  [result setDevicesArray:deviceProtos];
  return result;
}

- (ProtosBluetoothService*)toServiceProto:(CBPeripheral *)peripheral service:(CBService *)service  {
  ProtosBluetoothService *result = [[ProtosBluetoothService alloc] init];
  NSLog(@"peripheral uuid:%@", [peripheral.identifier UUIDString]);
  NSLog(@"service uuid:%@", [service.UUID fullUUIDString]);
  [result setRemoteId:[peripheral.identifier UUIDString]];
  [result setUuid:[service.UUID fullUUIDString]];
  [result setIsPrimary:[service isPrimary]];
  
  // Characteristic Array
  NSMutableArray *characteristicProtos = [NSMutableArray new];
  for(CBCharacteristic *c in [service characteristics]) {
    [characteristicProtos addObject:[self toCharacteristicProto:peripheral characteristic:c]];
  }
  [result setCharacteristicsArray:characteristicProtos];
  
  // Included Services Array
  NSMutableArray *includedServicesProtos = [NSMutableArray new];
  for(CBService *s in [service includedServices]) {
    [includedServicesProtos addObject:[self toServiceProto:peripheral service:s]];
  }
  [result setIncludedServicesArray:includedServicesProtos];
  
  return result;
}

- (ProtosBluetoothCharacteristic*)toCharacteristicProto:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic {
  ProtosBluetoothCharacteristic *result = [[ProtosBluetoothCharacteristic alloc] init];
  [result setUuid:[characteristic.UUID fullUUIDString]];
  [result setRemoteId:[peripheral.identifier UUIDString]];
  [result setProperties:[self toCharacteristicPropsProto:characteristic.properties]];
  [result setValue:[characteristic value]];
  NSLog(@"uuid: %@ value: %@", [characteristic.UUID fullUUIDString], [characteristic value]);
  NSMutableArray *descriptorProtos = [NSMutableArray new];
  for(CBDescriptor *d in [characteristic descriptors]) {
    [descriptorProtos addObject:[self toDescriptorProto:peripheral descriptor:d]];
  }
  [result setDescriptorsArray:descriptorProtos];
  if([characteristic.service isPrimary]) {
    [result setServiceUuid:[characteristic.service.UUID fullUUIDString]];
  } else {
    // Reverse search to find service and secondary service UUID
    [result setSecondaryServiceUuid:[characteristic.service.UUID fullUUIDString]];
    CBService *primaryService = [self findPrimaryService:[characteristic service] peripheral:[characteristic.service peripheral]];
    [result setServiceUuid:[primaryService.UUID fullUUIDString]];
  }
  return result;
}

- (ProtosBluetoothDescriptor*)toDescriptorProto:(CBPeripheral *)peripheral descriptor:(CBDescriptor *)descriptor {
  ProtosBluetoothDescriptor *result = [[ProtosBluetoothDescriptor alloc] init];
  [result setUuid:[descriptor.UUID fullUUIDString]];
  [result setRemoteId:[peripheral.identifier UUIDString]];
  [result setCharacteristicUuid:[descriptor.characteristic.UUID fullUUIDString]];
  [result setServiceUuid:[descriptor.characteristic.service.UUID fullUUIDString]];
  int value = [descriptor.value intValue];
  [result setValue:[NSData dataWithBytes:&value length:sizeof(value)]];
  return result;
}

- (ProtosCharacteristicProperties*)toCharacteristicPropsProto:(CBCharacteristicProperties)props {
  ProtosCharacteristicProperties *result = [[ProtosCharacteristicProperties alloc] init];
  [result setBroadcast:(props & CBCharacteristicPropertyBroadcast) != 0];
  [result setRead:(props & CBCharacteristicPropertyRead) != 0];
  [result setWriteWithoutResponse:(props & CBCharacteristicPropertyWriteWithoutResponse) != 0];
  [result setWrite:(props & CBCharacteristicPropertyWrite) != 0];
  [result setNotify:(props & CBCharacteristicPropertyNotify) != 0];
  [result setIndicate:(props & CBCharacteristicPropertyIndicate) != 0];
  [result setAuthenticatedSignedWrites:(props & CBCharacteristicPropertyAuthenticatedSignedWrites) != 0];
  [result setExtendedProperties:(props & CBCharacteristicPropertyExtendedProperties) != 0];
  [result setNotifyEncryptionRequired:(props & CBCharacteristicPropertyNotifyEncryptionRequired) != 0];
  [result setIndicateEncryptionRequired:(props & CBCharacteristicPropertyIndicateEncryptionRequired) != 0];
  return result;
}

- (ProtosMtuSizeResponse*)toMtuSizeResponseProto:(CBPeripheral *)peripheral mtu:(uint32_t)mtu {
  ProtosMtuSizeResponse *result = [[ProtosMtuSizeResponse alloc] init];
  [result setRemoteId:[[peripheral identifier] UUIDString]];
  [result setMtu:mtu];
  return result;
}

- (void)log:(LogLevel)level format:(NSString *)format, ... {
  if(level <= _logLevel) {
    va_list args;
    va_start(args, format);
//    NSString* formattedMessage = [[NSString alloc] initWithFormat:format arguments:args];
    NSLog(format, args);
    va_end(args);
  }
}

- (uint32_t)getMtu:(CBPeripheral *)peripheral {
  if (@available(iOS 9.0, *)) {
    // Which type should we use? (issue #365)
    return (uint32_t)[peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithoutResponse];
  } else {
    // Fallback to minimum on earlier versions. (issue #364)
    return 20;
  }
}

@end

@implementation FlutterBlueStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  self.sink = eventSink;
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  self.sink = nil;
  return nil;
}

@end
