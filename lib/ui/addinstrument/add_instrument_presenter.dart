import 'package:gigtrack/base/base_presenter.dart';

abstract class AddInstrumentContract extends BaseContract {
  void addInstrumentSuccess();
}

class AddInstrumentPresenter extends BasePresenter {
  AddInstrumentPresenter(BaseContract view) : super(view);

  void addInstrument() async {
    await Future.delayed(Duration(seconds: 2));
    (view as AddInstrumentContract).addInstrumentSuccess();
  }
}
