

// NOTE: experiment
class StateLock{
  bool _state = false;

  StateLock();

  // returns: statuscode that tells the caller if the opperation was successfull
  // FIXME: hihi lets trust the caller they obey the statelock for now, fix needed thoughS
  bool aquireStateLock() {
    if (_state == true) {
      return false;
    }
    _state = true;
    return true;
  }

  void releaseStateLock() {
    _state = false;
  }
}