import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsViewContract {
  void onNameUpdated(String message);
}

class SettingsPresenter {

  SettingsViewContract _view;

  SettingsPresenter(this._view);

  void updateName(String name) {
    _view.onNameUpdated('Name changed to $name');
  }

}
