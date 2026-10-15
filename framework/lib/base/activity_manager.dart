/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
import 'base_activity.dart';
import 'base_fragment.dart';
import 'base_view.dart';
import 'controllers/base_controller.dart';
import 'controllers/base_view_controller.dart';

class ActivityManager {
  final List<BaseActivityState> _activityList = [];

  static ActivityManager? _activityManager;

  ActivityManager._internal();

  factory ActivityManager() => _activityManager ??= ActivityManager._internal();

  List<BaseActivityState> get activityList => _activityList;

  void addActivity(BaseActivityState baseActivityState) {
    _activityList.add(baseActivityState);
  }

  void removeActivity(BaseActivityState baseActivityState) {
    _activityList.remove(baseActivityState);
  }

  bool isTopActivity(BaseActivityState baseActivityState) {
    bool result = false;
    if (_activityList.length > 0 &&
        baseActivityState == _activityList[_activityList.length - 1]) {
      result = true;
    }
    return result;
  }

  BaseActivityState? getTopActivityState() {
    List<BaseActivityState> activityList = ActivityManager().activityList;
    if (activityList.length != 0) {
      return activityList[activityList.length - 1];
    }
    return null;
  }

  T? getTargetActivity<T extends BaseActivityState>() {
    List<BaseActivityState> baseActivityStates = ActivityManager().activityList;
    T? targetActivity;
    baseActivityStates.forEach((baseActivityState) {
      if (baseActivityState is T) {
        targetActivity = baseActivityState;
      }
    });
    return targetActivity;
  }

  T? getTargetActivityController<T extends BaseController>(BaseActivity? baseActivity) {
    if(baseActivity==null){
      return null;
    }
    return baseActivity.stateCache.state?.baseController!=null?(baseActivity.stateCache.state?.baseController as T):null;
  }

  T? getTargetFragmentController<T extends BaseController>(BaseFragment? baseFragment) {
    if(baseFragment==null){
      return null;
    }
    return baseFragment.stateCache.state?.baseController!=null?(baseFragment.stateCache.state?.baseController as T):null;
  }

  T? getTargetViewController<T extends BaseViewController>(BaseView? baseView) {
    if(baseView==null){
      return null;
    }
    return baseView.stateCache.state?.baseController!=null?(baseView.stateCache.state?.baseController as T):null;
  }

}
