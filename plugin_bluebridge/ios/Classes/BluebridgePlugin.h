#import <Flutter/Flutter.h> 
#import <CoreBluetooth/CoreBluetooth.h>

#define NAMESPACE @"blue_bridge_plugin"

@interface BluebridgePlugin : NSObject<FlutterPlugin, CBCentralManagerDelegate, CBPeripheralDelegate>
@end

@interface FlutterBlueStreamHandler : NSObject<FlutterStreamHandler>
@property FlutterEventSink sink;
@end