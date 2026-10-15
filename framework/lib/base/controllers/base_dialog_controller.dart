/**
 * @author snakeway
 * @description:
 * @date :2021/3/23
 */
abstract class BaseDialogController {
  bool isShowing();

  void show(String title);

  void hide();

  void dispose();
}
