/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'package:framework/base/base_activity.dart';

import 'base_view_controller.dart';

abstract class BaseController extends BaseViewController {
  late BaseActivityState baseActivityState;

  BaseController();
}
